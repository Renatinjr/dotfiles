-- Helpers shared by the palette builders in lua/themes/*.lua and by the few
-- consumers (config.heirline) that derive colors from a palette.
local M = {}

-- Build the full set of NvimTree highlight groups from a small semantic color
-- map, so each palette only has to name its accents once. nvim-tree applies the
-- `*FileHL`/`*FolderHL` groups (folder links to file by default) plus the legacy
-- status-icon groups; we set both so colors land regardless of which the
-- renderer reaches for.
function M.make_nvim_tree(c)
	return {
		-- Window / chrome
		NvimTreeNormal = { fg = c.fg, bg = c.bg },
		NvimTreeNormalFloat = { fg = c.fg, bg = c.bg },
		NvimTreeNormalNC = { fg = c.fg, bg = c.bg },
		NvimTreeEndOfBuffer = { fg = c.bg, bg = c.bg },
		NvimTreeNormalFloatBorder = { fg = c.border, bg = c.bg },
		NvimTreeWinSeparator = { fg = c.border, bg = c.bg },
		NvimTreeCursorLine = { bg = c.sel_bg },
		NvimTreeLiveFilterPrefix = { fg = c.accent, bold = true },
		NvimTreeLiveFilterValue = { fg = c.fg },
		-- Files / folders
		NvimTreeRootFolder = { fg = c.accent, bold = true },
		NvimTreeFolderName = { fg = c.folder },
		NvimTreeOpenedFolderName = { fg = c.folder, bold = true, italic = true },
		NvimTreeEmptyFolderName = { fg = c.comment },
		NvimTreeFolderIcon = { fg = c.folder },
		NvimTreeIndentMarker = { fg = c.comment },
		NvimTreeSymlink = { fg = c.symlink },
		NvimTreeSpecialFile = { fg = c.special, bold = true },
		NvimTreeOpenedFile = { fg = c.fg, bold = true },
		NvimTreeOpenedHL = { fg = c.fg, bold = true },
		NvimTreeModifiedFile = { fg = c.modified },
		NvimTreeModifiedFileHL = { fg = c.modified },
		NvimTreeModifiedIcon = { fg = c.modified },
		NvimTreeWindowPicker = { fg = c.bg, bg = c.accent, bold = true },
		-- Git: new
		NvimTreeGitNew = { fg = c.git_new },
		NvimTreeGitNewIcon = { fg = c.git_new },
		NvimTreeGitFileNewHL = { fg = c.git_new },
		NvimTreeGitFolderNewHL = { fg = c.git_new },
		-- Git: dirty / unstaged
		NvimTreeGitDirty = { fg = c.git_dirty },
		NvimTreeGitDirtyIcon = { fg = c.git_dirty },
		NvimTreeGitFileDirtyHL = { fg = c.git_dirty },
		NvimTreeGitFolderDirtyHL = { fg = c.git_dirty },
		-- Git: staged
		NvimTreeGitStaged = { fg = c.git_staged },
		NvimTreeGitStagedIcon = { fg = c.git_staged },
		NvimTreeGitFileStagedHL = { fg = c.git_staged },
		NvimTreeGitFolderStagedHL = { fg = c.git_staged },
		-- Git: renamed
		NvimTreeGitRenamed = { fg = c.git_renamed },
		NvimTreeGitRenamedIcon = { fg = c.git_renamed },
		NvimTreeGitFileRenamedHL = { fg = c.git_renamed },
		NvimTreeGitFolderRenamedHL = { fg = c.git_renamed },
		-- Git: deleted
		NvimTreeGitDeleted = { fg = c.git_deleted },
		NvimTreeGitDeletedIcon = { fg = c.git_deleted },
		NvimTreeGitFileDeletedHL = { fg = c.git_deleted },
		NvimTreeGitFolderDeletedHL = { fg = c.git_deleted },
		-- Git: merge conflict
		NvimTreeGitMerge = { fg = c.git_merge },
		NvimTreeGitMergeIcon = { fg = c.git_merge },
		NvimTreeGitFileMergeHL = { fg = c.git_merge },
		NvimTreeGitFolderMergeHL = { fg = c.git_merge },
		-- Git: ignored
		NvimTreeGitIgnored = { fg = c.comment, italic = true },
		NvimTreeGitIgnoredIcon = { fg = c.comment, italic = true },
		NvimTreeGitFileIgnoredHL = { fg = c.comment, italic = true },
		NvimTreeGitFolderIgnoredHL = { fg = c.comment, italic = true },
	}
end

-- Mix two hex colors: `alpha` is the weight of `fg` (1 = fg, 0 = bg). Used for
-- diagnostic virtual-text washes and for deriving middle greys on very flat
-- palettes (black-metal).
function M.blend(fg, bg, alpha)
	local function mix(i)
		local a = tonumber(fg:sub(i, i + 1), 16) * alpha
		local b = tonumber(bg:sub(i, i + 1), 16) * (1 - alpha)
		return math.floor(math.min(math.max(a + b, 0), 255) + 0.5)
	end
	return string.format("#%02X%02X%02X", mix(2), mix(4), mix(6))
end

return M
