local M = {}

local chezmoi_prefixes = {
  "create_",
  "modify_",
  "remove_",
  "run_",
  "encrypted_",
  "private_",
  "readonly_",
  "executable_",
  "once_",
  "onchange_",
  "before_",
  "after_",
  "symlink_",
  "empty_",
  "external_",
  "exact_",
}

local function strip_chezmoi_prefixes(name)
  local changed = true

  while changed do
    changed = false

    for _, prefix in ipairs(chezmoi_prefixes) do
      if name:sub(1, #prefix) == prefix then
        name = name:sub(#prefix + 1)
        changed = true
        break
      end
    end
  end

  return name
end

local function has_chezmoi_prefix(segment)
  if segment:sub(1, 4) == "dot_" or segment:sub(1, 8) == "literal_" then
    return true
  end

  for _, prefix in ipairs(chezmoi_prefixes) do
    if segment:sub(1, #prefix) == prefix then
      return true
    end
  end

  return false
end

local function has_chezmoi_marker(path)
  local dir = vim.fs.dirname(path)

  if dir == nil or dir == "" then
    return false
  end

  local markers = vim.fs.find({
    ".chezmoiignore",
    ".chezmoiroot",
    ".chezmoi.toml",
    ".chezmoi.toml.tmpl",
  }, { path = dir, upward = true, limit = 1 })

  return #markers > 0
end

local function is_chezmoi_source_path(path)
  for segment in path:gmatch("[^/]+") do
    if segment:match("^%.chezmoi") or has_chezmoi_prefix(segment) then
      return true
    end
  end

  return has_chezmoi_marker(path)
end

local function resolve_chezmoi_segment(segment)
  segment = strip_chezmoi_prefixes(segment)

  if segment:sub(1, 4) == "dot_" then
    segment = "." .. segment:sub(5)
  end

  if segment:sub(1, 8) == "literal_" then
    segment = segment:sub(9)
  end

  return segment
end

local function resolve_chezmoi_source_path(path)
  local parts = {}
  local is_absolute = path:sub(1, 1) == "/"

  for segment in path:gmatch("[^/]+") do
    table.insert(parts, resolve_chezmoi_segment(segment))
  end

  local target = table.concat(parts, "/")

  if is_absolute then
    target = "/" .. target
  end

  target = target:gsub("%.tmpl$", "")
  target = target:gsub("%.literal$", "")

  return target
end

local function base_filetype(path)
  local filetype = vim.filetype.match({ filename = path })

  if filetype == nil or filetype == "" then
    local name = path:match("[^/]+$") or path
    local by_name = {
      [".gitconfig"] = "gitconfig",
      [".tool-versions"] = "conf",
      [".zshrc"] = "zsh",
    }
    local by_extension = {
      bash = "sh",
      json = "json",
      lua = "lua",
      sh = "sh",
      toml = "toml",
      yaml = "yaml",
      yml = "yaml",
      zsh = "zsh",
    }
    local extension = name:match("%.([^%.]+)$")

    return by_name[name] or by_extension[extension]
  end

  return filetype
end

function M.detect(path)
  if path == nil or path == "" or not is_chezmoi_source_path(path) then
    return nil
  end

  local is_template = path:match("%.tmpl$") ~= nil
  local target = resolve_chezmoi_source_path(path)
  local filetype = base_filetype(target)

  if target:match("/%.tool%-versions$") or target == ".tool-versions" then
    filetype = "conf"
  end

  if is_template then
    return filetype and (filetype .. ".chezmoitmpl") or "chezmoitmpl"
  end

  return filetype
end

return M
