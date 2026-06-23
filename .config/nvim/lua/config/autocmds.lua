-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Gentle autosave: save only when leaving insert mode or when Neovim loses
-- focus, debounced so rapid edits don't trigger a write storm. Only real,
-- named, writable file buffers are saved; special buffers (snacks picker,
-- terminals, prompts, no-name) are skipped so this never throws E32.
local function autosave_ok(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].modified
    and vim.bo[buf].buftype == ""
    and vim.bo[buf].modifiable
    and not vim.bo[buf].readonly
    and vim.api.nvim_buf_get_name(buf) ~= ""
end

local autosave_timer = assert(vim.uv.new_timer())

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
  callback = function(args)
    local buf = args.buf
    autosave_timer:stop()
    autosave_timer:start(
      1000,
      0,
      vim.schedule_wrap(function()
        if autosave_ok(buf) then
          pcall(function()
            vim.api.nvim_buf_call(buf, function()
              vim.cmd("silent write")
            end)
          end)
        end
      end)
    )
  end,
})
