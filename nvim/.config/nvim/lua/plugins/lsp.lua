local load_plugin = function(name)
	return require("plugins.lsp." .. name) -- Fixed: using concatenation instead of {name}
end

local lsp = load_plugin("init")

return{
  lsp
}
