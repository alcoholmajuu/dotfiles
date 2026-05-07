local chezmoi_filetype = require("user.chezmoi_filetype")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "filetypedetect",
  pattern = "*",
  callback = function(event)
    local filetype = chezmoi_filetype.detect(event.file)

    if filetype then
      vim.api.nvim_buf_call(event.buf, function()
        vim.cmd("setlocal filetype=" .. filetype)
      end)
    end
  end,
})
