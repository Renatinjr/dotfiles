-- intelephense: PHP language server.
--
-- Mason package "intelephense" -- a Node server, so it needs no php binary of
-- its own (php is still required for pint, Xdebug and composer tooling).
--
-- LICENCE: the free tier covers completion, signature help, hover, diagnostics
-- and goto-definition. A paid key additionally unlocks rename across files,
-- find-all-implementations and the full code-action set. intelephense looks for
-- the key in ~/intelephense/licence.txt by itself; `init_options` below only
-- forwards it when that file exists, so dropping the key in place is all that
-- is needed -- no config change.
--
-- BLADE: deliberately not in `filetypes`. intelephense is a PHP parser, and a
-- .blade.php file is mostly NOT PHP to it -- `@extends('x')` reads as an
-- error-suppressed call to an undefined function, and the expression inside
-- `{{ ... }}` is plain text, so there is nothing to complete there anyway. The
-- result would be a steady stream of bogus diagnostics for almost no gain.
-- Blade is handled instead by the treesitter `blade` parser (which injects
-- php_only and html, so highlighting/indent/textobjects are correct), by
-- blade-formatter in plugins/coding/conform.lua, and by html-ls attaching to
-- blade for tag and attribute completion (see servers/html.lua).

-- Read once, at config load. Returns nil when there is no key, which leaves
-- init_options empty and the server in its free tier.
local function licence_key()
	local path = vim.fn.expand("~/intelephense/licence.txt")
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local key = vim.trim(file:read("*a") or "")
	file:close()
	return key ~= "" and key or nil
end

-- Extension stubs the server loads. NOTE: `intelephense.stubs` REPLACES
-- intelephense's own default list rather than extending it, so the defaults are
-- spelled out here and the Laravel-relevant extras appended. If an upgrade
-- bundles a new core stub it will not load until it is named here; the full set
-- intelephense ships is in
-- ~/.local/share/nvim/mason/packages/intelephense/node_modules/intelephense/lib/stub.
local STUB_DEFAULTS = [[
apache bcmath bz2 calendar com_dotnet Core ctype curl date dba dom enchant exif FFI fileinfo
filter fpm ftp gd gettext gmp hash iconv imap intl json ldap libxml mbstring meta mysqli oci8
odbc openssl pcntl pcre PDO pgsql Phar posix pspell readline Reflection session shmop SimpleXML
snmp soap sockets sodium SPL sqlite3 standard superglobals sysvmsg sysvsem sysvshm tidy
tokenizer xml xmlreader xmlrpc xmlwriter xsl zip zlib
]]

-- PHP 8.2+ core, plus what Laravel's cache/queue/session drivers and the test
-- tooling reach for.
local STUB_EXTRAS = { "random", "redis", "memcached", "apcu", "igbinary", "pcov", "xdebug" }

local function stubs()
	local list = {}
	for name in STUB_DEFAULTS:gmatch("%S+") do
		table.insert(list, name)
	end
	-- The one default with a space in its name, so it cannot come from the split.
	table.insert(list, "Zend OPcache")
	return vim.list_extend(list, STUB_EXTRAS)
end

return {
	-- composer.json roots a package; composer.lock and .git catch the rest.
	root_markers = { "composer.json", "composer.lock", ".git" },

	init_options = {
		licenceKey = licence_key(),
		-- Index and cache location. Keeping it under the state dir means
		-- `rm -rf ~/.local/state/nvim/intelephense` is a clean re-index.
		storagePath = vim.fn.stdpath("state") .. "/intelephense",
	},

	on_attach = function(client, bufnr)
		-- composer require/install changes vendor/ behind the server's back;
		-- this forces the workspace index to catch up without restarting it.
		vim.api.nvim_buf_create_user_command(bufnr, "IntelephenseIndex", function()
			client:exec_cmd({ command = "intelephense.index.workspace", arguments = {} })
			vim.notify("intelephense: re-indexing workspace", vim.log.levels.INFO)
		end, { desc = "Re-index the workspace (run after composer install)" })
	end,

	settings = {
		intelephense = {
			files = {
				-- Default is 1 MB, which silently skips generated files that
				-- Laravel projects do have (_ide_helper.php is ~800 KB and
				-- climbing, large migrations/seeders). config/bigfile.lua still
				-- guards the editor side, so this only affects indexing.
				maxSize = 5000000,
				-- Vendor code is indexed for symbols but never watched.
				exclude = {
					"**/.git/**",
					"**/node_modules/**",
					"**/bower_components/**",
					"**/vendor/**/{Tests,tests,Test,test}/**",
					"**/.phpunit.cache/**",
					"**/storage/framework/**",
					"**/bootstrap/cache/**",
					"**/public/build/**",
				},
			},

			stubs = stubs(),

			environment = {
				-- Matches the Homebrew php on PATH; bump when that moves.
				phpVersion = "8.5.0",
				includePaths = {
					-- barryvdh/laravel-ide-helper output, when the project has it.
					"_ide_helper.php",
					"_ide_helper_models.php",
				},
			},

			diagnostics = {
				enable = true,
				-- Blade templates and generated helper files produce undefined-symbol
				-- noise that is never actionable.
				undefinedSymbols = true,
				undefinedVariables = true,
				undefinedTypes = true,
				undefinedFunctions = true,
				undefinedConstants = true,
				undefinedClassConstants = true,
				undefinedMethods = true,
				undefinedProperties = true,
				unusedSymbols = true,
				unexpectedTokens = true,
				duplicateSymbols = true,
				argumentCount = true,
				typeErrors = true,
				deprecated = true,
				-- Off: implementation-detail noise on framework code you do not own.
				languageConstraints = false,
			},

			completion = {
				-- Insert `use` statements rather than fully-qualified names.
				insertUseDeclaration = true,
				fullyQualifyGlobalConstantsAndFunctions = false,
				triggerParameterHints = true,
				maxItems = 100,
			},

			format = {
				-- conform.nvim runs pint on save (plugins/coding/conform.lua) and
				-- only falls back to the LSP formatter, so this is the fallback's
				-- style. PSR-12 matches pint's default preset.
				braces = "psr12",
			},
		},
	},
}
