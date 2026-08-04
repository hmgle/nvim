local map = require('utils').map

map('n', 'gt', '<cmd>bn<cr>')
map('n', 'gT', '<cmd>bp<cr>')

require('config.diagnostics').setup()

vim.opt.completeopt = 'menu,menuone,noselect,popup'
vim.opt.pumborder = 'rounded'
vim.opt.pummaxwidth = 80
vim.opt.mouse = 'a'

local remote_env_names = { 'SSH_CLIENT', 'SSH_CONNECTION', 'SSH_TTY', 'MOSH_IP', 'MOSH_CONNECTION' }

local function is_remote_session()
  for _, name in ipairs(remote_env_names) do
    if vim.env[name] then
      return true
    end
  end

  return false
end

-- A pane's own shell env is frozen at the moment the pane was created, so a
-- long-lived pane that started locally and was later reattached over SSH
-- still reports no SSH_* vars here even though the attached client is now
-- remote. tmux itself refreshes a separate session-level environment on
-- every attach (see the update-environment session option), so check that
-- instead of the pane's env when deciding whether this tmux session is
-- currently attached remotely.
local function tmux_session_is_remote()
  if not vim.env.TMUX or vim.fn.executable 'tmux' ~= 1 then
    return false
  end

  local output = vim.fn.system { 'tmux', 'show-environment' }
  if vim.v.shell_error ~= 0 or type(output) ~= 'string' then
    return false
  end

  for line in output:gmatch '[^\n]+' do
    local name = line:match '^(%u[%u_]*)='
    if name then
      for _, remote_name in ipairs(remote_env_names) do
        if name == remote_name then
          return true
        end
      end
    end
  end

  return false
end

-- SSH sessions can attach to a long-lived tmux pane whose shell still has
-- local desktop variables such as DISPLAY and XAUTHORITY. In that state
-- Neovim may select xclip or wl-copy before its tmux clipboard provider, so
-- yanks land on the target machine's graphical clipboard instead of the SSH
-- client. Restrict the provider override to remote sessions so local desktop
-- tmux panes keep using the faster native provider. Set
-- NVIM_CLIPBOARD_PROVIDER=native to skip this override. Neovim may still
-- auto-detect tmux when no other provider is available.
--
-- The built-in tmux provider is intentionally not used for remote sessions.
-- Its paste command runs `tmux refresh-client -l`, which asks the outer
-- terminal for its clipboard through OSC 52. A slow or fragmented reply can
-- hit tmux's partial-key timeout and be delivered to the active pane as
-- literal keystrokes. This is the failure tracked in:
-- https://github.com/tmux/tmux/issues/5388
-- The related Neovim provider behavior is intentional and documented in:
-- https://github.com/neovim/neovim/issues/36786
--
-- The custom provider keeps copy one-way through `load-buffer -w`, so remote
-- yanks still reach the attached terminal's clipboard. Paste only reads
-- tmux's own buffer and therefore does not initiate an OSC 52 query. Use the
-- terminal's normal paste action for outer-client clipboard -> Neovim input.
-- The trade-off is that outer-client clipboard contents are not imported into
-- the `+` register automatically. See docs/ssh-tmux-clipboard.md for the
-- background, security trade-offs, and Yanky startup behavior.
--
-- Check the pane's own env first: a pane created directly inside an SSH
-- session already has SSH_* vars, so this is both correct and avoids
-- spawning `tmux show-environment` on every such startup. Fall back to
-- tmux's session-level env (kept fresh across reattach) only when the
-- pane's own env doesn't already say remote, which is what makes an old
-- pane reattached over SSH still detected correctly.
if vim.env.TMUX and vim.env.NVIM_CLIPBOARD_PROVIDER ~= 'native' and vim.fn.executable 'tmux' == 1 and (is_remote_session() or tmux_session_is_remote()) then
  -- `load-buffer -w` needs tmux >= 3.2. Older versions still get a local
  -- tmux buffer, but cannot forward yanks to the outer terminal clipboard.
  local load_buffer = { 'tmux', 'load-buffer', '-' }
  local tmux_version = vim.version.parse(vim.fn.system { 'tmux', '-V' })
  if tmux_version and not vim.version.lt(tmux_version, { 3, 2, 0 }) then
    load_buffer = { 'tmux', 'load-buffer', '-w', '-' }
  end

  vim.g.clipboard = {
    name = 'tmux-quiet',
    copy = {
      ['+'] = load_buffer,
      ['*'] = load_buffer,
    },
    -- A new tmux server may have no paste buffer. Suppress that expected
    -- error and expose an empty clipboard instead.
    paste = {
      ['+'] = { 'sh', '-c', 'tmux save-buffer - 2>/dev/null || true' },
      ['*'] = { 'sh', '-c', 'tmux save-buffer - 2>/dev/null || true' },
    },
    -- Keep yanks asynchronous while allowing each paste to re-read tmux's
    -- current buffer after the short-lived copy job has exited.
    cache_enabled = true,
  }
end

vim.opt.clipboard = 'unnamedplus' -- Sync with system clipboard

local uv = vim.uv

local function throttle(fn)
  if not uv or not uv.now then
    return fn
  end

  local last = 0
  return function(...)
    local now = uv.now()
    if last ~= 0 and now - last < 200 then
      return
    end
    last = now
    return fn(...)
  end
end

local function env_enabled(name)
  local value = vim.env[name]
  return value == '1' or value == 'true' or value == 'yes' or value == 'on'
end

local function make_switcher()
  local fallback

  if env_enabled 'NVIM_DISABLE_IM_SWITCH' then
    return nil
  end

  if is_remote_session() and not env_enabled 'NVIM_ALLOW_REMOTE_IM_SWITCH' then
    return nil
  end

  local function can_use_xdotool()
    if not env_enabled 'NVIM_ALLOW_XDOTOOL_IM_SWITCH' then
      return false
    end

    -- xdotool sends synthetic X11 keyboard input, which can wake a DPMS-off
    -- monitor. Keep it opt-in even on local graphical sessions.
    return vim.fn.executable 'xdotool' == 1 and vim.env.DISPLAY ~= nil and vim.env.DISPLAY ~= ''
  end

  local function xdotool_switcher()
    if not can_use_xdotool() then
      return nil
    end

    -- Use the custom rime keybinding to switch to English mode (Control+Alt+Shift+F12)
    -- rime config:
    -- patch:
    --   key_binder/bindings/+:
    --     - { when: always, accept: "Control+Alt+Shift+F12", set_option: ascii_mode }
    local command = { 'xdotool', 'key', 'ctrl+alt+shift+F12' }
    return throttle(function()
      vim.fn.jobstart(command, {
        on_exit = function(_, code)
          if code ~= 0 then
            vim.notify('Failed to switch input method', vim.log.levels.WARN)
          end
        end,
      })
    end)
  end

  local function fcitx_switcher(bin)
    return throttle(function()
      vim.fn.jobstart({ bin }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if type(data) ~= 'table' then
            return
          end
          for _, line in ipairs(data) do
            if line == '2' then -- 简体中文输入状态
              vim.fn.jobstart { bin, '-c' }
              return
            end
          end
        end,
        on_exit = function(_, code)
          if code ~= 0 then
            vim.notify(string.format('%s exited with code %d', bin, code), vim.log.levels.WARN)
          end
        end,
      })
    end)
  end

  if vim.fn.executable 'fcitx5-remote' == 1 then
    fallback = fcitx_switcher 'fcitx5-remote'
  end

  if not fallback and vim.fn.executable 'fcitx-remote' == 1 then
    fallback = fcitx_switcher 'fcitx-remote'
  end

  if not fallback then
    fallback = xdotool_switcher()
  end

  if vim.fn.executable 'busctl' == 1 and vim.env.DBUS_SESSION_BUS_ADDRESS and (vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY) then
    local is_ascii_command = {
      'busctl',
      '--user',
      'call',
      'org.fcitx.Fcitx5',
      '/rime',
      'org.fcitx.Fcitx.Rime1',
      'IsAsciiMode',
    }
    local set_ascii_command = {
      'busctl',
      '--user',
      'call',
      'org.fcitx.Fcitx5',
      '/rime',
      'org.fcitx.Fcitx.Rime1',
      'SetAsciiMode',
      'b',
      'true',
    }

    return throttle(function()
      local is_ascii = false

      vim.fn.jobstart(is_ascii_command, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if type(data) ~= 'table' then
            return
          end

          is_ascii = table.concat(data, '\n'):find('b true', 1, true) ~= nil
        end,
        on_exit = function(_, code)
          if code ~= 0 then
            if fallback then
              fallback()
            end
            return
          end

          if is_ascii then
            return
          end

          vim.fn.jobstart(set_ascii_command, {
            on_exit = function(_, set_code)
              if set_code ~= 0 and fallback then
                fallback()
              end
            end,
          })
        end,
      })
    end)
  end

  return fallback
end

local switch_to_en = make_switcher()

if switch_to_en then
  local group = vim.api.nvim_create_augroup('fcitx', { clear = true })
  vim.api.nvim_create_autocmd('VimEnter', {
    group = group,
    pattern = '*',
    callback = function()
      vim.schedule(switch_to_en)
    end,
  })
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = group,
    pattern = '*',
    callback = switch_to_en,
  })
  -- Returning to normal mode after typing Chinese in cmdline (e.g. /搜索)
  vim.api.nvim_create_autocmd('CmdlineLeave', {
    group = group,
    pattern = '*',
    callback = function()
      vim.schedule(switch_to_en)
    end,
  })
  -- Returning to normal mode from a terminal buffer (toggleterm, Aider)
  vim.api.nvim_create_autocmd('TermLeave', {
    group = group,
    pattern = '*',
    callback = switch_to_en,
  })
  -- Regaining focus after typing Chinese in another application. Skip
  -- text-input modes (insert/replace/cmdline/terminal/select) so a quick
  -- app switch does not interrupt ongoing Chinese input there.
  vim.api.nvim_create_autocmd('FocusGained', {
    group = group,
    pattern = '*',
    callback = function()
      local mode = vim.api.nvim_get_mode().mode
      if not mode:find '^[iRctsS\19]' then
        switch_to_en()
      end
    end,
  })

  -- Full-width punctuation commits instantly (no candidate window), so it
  -- reaches normal mode as a multibyte keypress; remap it to the intended
  -- half-width key and correct the input method on the way.
  local fullwidth_keys = {
    ['：'] = ':',
    ['？'] = '?',
    ['／'] = '/',
    ['，'] = ',', -- leader
  }
  for fw, half in pairs(fullwidth_keys) do
    map({ 'n', 'x' }, fw, function()
      switch_to_en()
      return half
    end, { expr = true, remap = true })
  end

  -- Letters typed while the IM is composing are consumed by the IM and
  -- never reach nvim, so they cannot be remapped. Pressing <Esc> cancels
  -- the composition; the next <Esc> lands here and resets the IM.
  map({ 'n', 'x' }, '<Esc>', function()
    switch_to_en()
    return '<Esc>'
  end, { expr = true })
end

local function resolve_node_host_prog()
  local output = vim.fn.system { 'bash', '-lc', 'nvm which default' }
  if vim.v.shell_error == 0 then
    local path = vim.fn.trim(output)
    if path ~= '' and vim.fn.filereadable(path) == 1 then
      return path
    end
  end

  local node = vim.fn.exepath 'node'
  if node ~= '' then
    return node
  end
end

vim.schedule(function()
  local node_host_prog = resolve_node_host_prog()
  if node_host_prog then
    vim.g.node_host_prog = node_host_prog
  end
end)

-- Some performance issues that seems to be related to the foldexpr setting
-- https://github.com/akinsho/toggleterm.nvim/issues/610
-- -- https://github.com/LazyVim/LazyVim/discussions/1233
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.opt.foldenable = false
