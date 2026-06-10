local map = require('utils').map

map('n', 'gt', '<cmd>bn<cr>')
map('n', 'gT', '<cmd>bp<cr>')

require('config.diagnostics').setup()

vim.opt.completeopt = 'menu,menuone,noselect,popup'
vim.opt.pumborder = 'rounded'
vim.opt.pummaxwidth = 80
vim.opt.mouse = 'a'
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus' -- Sync with system clipboard
end)

-- https://github.com/preservim/tagbar/wiki#zig
vim.g.tagbar_type_zig = {
  ctagstype = 'zig',
  kinds = {
    'f:functions',
    's:structs',
    'e:enums',
    'u:unions',
    'E:errors',
  },
}

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

local function make_switcher()
  local fallback

  if vim.fn.executable 'xdotool' == 1 then
    -- Use the custom rime keybinding to switch to English mode (Control+Alt+Shift+F12)
    -- rime config:
    -- patch:
    --   key_binder/bindings/+:
    --     - { when: always, accept: "Control+Alt+Shift+F12", set_option: ascii_mode }
    local command = { 'xdotool', 'key', 'ctrl+alt+shift+F12' }
    fallback = throttle(function()
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

  if not fallback and vim.fn.executable 'fcitx5-remote' == 1 then
    fallback = fcitx_switcher 'fcitx5-remote'
  end

  if not fallback and vim.fn.executable 'fcitx-remote' == 1 then
    fallback = fcitx_switcher 'fcitx-remote'
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
  -- Regaining focus after typing Chinese in another application
  vim.api.nvim_create_autocmd('FocusGained', {
    group = group,
    pattern = '*',
    callback = switch_to_en,
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
