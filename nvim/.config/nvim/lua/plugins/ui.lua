local load_plugin = function(name)
	return require("plugins.ui." .. name) -- Fixed: using concatenation instead of {name}
end

local nvim_tree = load_plugin("nvim-tree")
local gitsigns = load_plugin("gitsigns")
local heirline = load_plugin("heirline")
local dash = load_plugin("dash")
local bufferline = load_plugin("bufferline")
local icons = load_plugin("icons")
local crates = load_plugin("crates")
local incline = load_plugin("incline")

return {
	nvim_tree,
	gitsigns,
	heirline,
	dash,
	bufferline,
	icons,
	crates,
	incline,
}
