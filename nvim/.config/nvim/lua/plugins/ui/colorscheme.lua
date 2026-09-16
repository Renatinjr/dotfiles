-- Colorscheme plugin specs live next to their palettes in lua/themes/<name>.lua;
-- this just hands lazy the list. The active scheme is chosen by
-- config.theme.switcher (:Theme, <leader>uc), not by any spec.
local specs = {}
for _, name in ipairs(require("config.theme").modules) do
	table.insert(specs, require("themes." .. name).spec)
end
return specs
