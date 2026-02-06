local load_plugin = function(name)
	return require("plugins.coding." .. name) -- Fixed: using concatenation instead of {name}
end

local coding = load_plugin("fzf")
local conform = load_plugin("conform")
local comment = load_plugin("comment")
local autopairs = load_plugin("autopairs")
local wk = load_plugin("wichkey")
local indentblank = load_plugin("indentblank")
local blink = load_plugin("blinkcmp")
local noice = load_plugin("noice")
local tmux_navigator = load_plugin("tmux-navigator")
local ts_error = load_plugin("ts-error")
local claudecode = load_plugin("claudecode")

return {
	coding,
	conform,
	comment,
	autopairs,
	wk,
	indentblank,
	blink,
	noice,
	tmux_navigator,
	ts_error,
	claudecode,
}
