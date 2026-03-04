local load_plugin = function(name)
	return require("plugins.lsp.config." .. name) -- Fixed: using concatenation instead of {name}
end

local lsp = load_plugin("lspconfig")
local rustace = load_plugin("rustace")
local vtsls = load_plugin("vtsls")
local kotlin = load_plugin("kotlin")

return {
	lsp,
	rustace,
	vtsls,
	kotlin,
}
