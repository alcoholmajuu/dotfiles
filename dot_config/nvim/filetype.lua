local chezmoi_filetype = require("user.chezmoi_filetype")

vim.filetype.add({
  filename = {
    [".tool-versions"] = "conf",
  },
  pattern = {
    [".*/[^/]+%.tmpl"] = chezmoi_filetype.detect,
    [".*/dot_[^/]*"] = chezmoi_filetype.detect,
    [".*/dot_[^/]*/.*"] = chezmoi_filetype.detect,
    [".*/private_[^/]*"] = chezmoi_filetype.detect,
    [".*/private_[^/]*/.*"] = chezmoi_filetype.detect,
    [".*/readonly_[^/]*"] = chezmoi_filetype.detect,
    [".*/readonly_[^/]*/.*"] = chezmoi_filetype.detect,
    [".*/executable_[^/]*"] = chezmoi_filetype.detect,
    [".*/encrypted_[^/]*"] = chezmoi_filetype.detect,
    [".*/run_[^/]*"] = chezmoi_filetype.detect,
    [".*/create_[^/]*"] = chezmoi_filetype.detect,
    [".*/modify_[^/]*"] = chezmoi_filetype.detect,
    [".*/remove_[^/]*"] = chezmoi_filetype.detect,
  },
})
