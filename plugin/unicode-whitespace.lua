local unusual_spaces = {
	0x00a0,
	0x1680,
	0x2000,
	0x2001,
	0x2002,
	0x2003,
	0x2004,
	0x2005,
	0x2006,
	0x2007,
	0x2008,
	0x2009,
	0x200a,
	0x202f,
	0x205f,
	0x3000,
	0x2800,
	0x115f,
	0x3164,
	0xffa0,
}

local invisible_chars = {
	0x00ad,
	0x034f,
	0x061c,
	0x1160,
	0x180b,
	0x180c,
	0x180d,
	0x180e,
	0x200b,
	0x200c,
	0x200d,
	0x200e,
	0x200f,
	0x2028,
	0x2029,
	0x202a,
	0x202b,
	0x202c,
	0x202d,
	0x202e,
	0x2060,
	0x2061,
	0x2062,
	0x2063,
	0x2064,
	0x2066,
	0x2067,
	0x2068,
	0x2069,
	0xfeff,
}

for cp = 0xfe00, 0xfe0f do
	invisible_chars[#invisible_chars + 1] = cp
end

local invisible = {}
local target = {}
for _, cp in ipairs(unusual_spaces) do
	target[cp] = true
end
for _, cp in ipairs(invisible_chars) do
	target[cp] = true
	invisible[cp] = true
end

local combining = {
	[0x034f] = true,
	[0x180b] = true,
	[0x180c] = true,
	[0x180d] = true,
	[0x200c] = true,
	[0x200d] = true,
}

for cp = 0xfe00, 0xfe0f do
	combining[cp] = true
end

local ns = vim.api.nvim_create_namespace("unicode_whitespace")
local enabled = true
local attached = {}

local function define_hl()
	local err = vim.api.nvim_get_hl(0, { name = "Error", link = false })
	vim.api.nvim_set_hl(0, "UnicodeWhitespace", {
		fg = err.bg,
		bg = err.fg or "#ff5555",
	})
end

define_hl()

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("UnicodeWhitespaceHl", { clear = true }),
	callback = define_hl,
})

local byte, find = string.byte, string.find

local function decode(line, i)
	local b1 = byte(line, i)

	if b1 < 0xe0 then
		local b2 = byte(line, i + 1)
		if not b2 or b2 < 0x80 or b2 > 0xbf then
			return nil, 1
		end
		return (b1 - 0xc0) * 0x40 + (b2 - 0x80), 2
	elseif b1 < 0xf0 then
		local b2, b3 = byte(line, i + 1), byte(line, i + 2)
		if not b3 or b2 < 0x80 or b2 > 0xbf or b3 < 0x80 or b3 > 0xbf then
			return nil, 1
		end
		return (b1 - 0xe0) * 0x1000 + (b2 - 0x80) * 0x40 + (b3 - 0x80), 3
	else
		return nil, 4
	end
end

local function scan_range(bufnr, first, last)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, first, last)
	local lines = vim.api.nvim_buf_get_lines(bufnr, first, last, false)

	for n, line in ipairs(lines) do
		local row = first + n - 1
		local pos = 1

		while true do
			local i = find(line, "[\194-\239]", pos)

			if not i then
				break
			end

			local cp, len = decode(line, i)

			if cp and target[cp] then
				local opts = {
					end_col = i - 1 + len,
					hl_group = "UnicodeWhitespace",
					priority = 300,
					invalidate = true,
					undo_restore = false,
				}

				if invisible[cp] and not combining[cp] then
					opts.virt_text = { { "*", "UnicodeWhitespace" } }
					opts.virt_text_pos = "inline"
				end

				vim.api.nvim_buf_set_extmark(bufnr, ns, row, i - 1, opts)
				if combining[cp] then
					vim.api.nvim_buf_set_extmark(bufnr, ns, row, i - 1 + len, {
						virt_text = { { "*", "UnicodeWhitespace" } },
						virt_text_pos = "inline",
						priority = 300,
						undo_restore = false,
					})
				end
			end
			pos = i + len
		end
	end
end

local function rescan(bufnr, first, last)
	vim.schedule(function()
		if vim.api.nvim_buf_is_valid(bufnr) then
			scan_range(bufnr, first, last)
		end
	end)
end

local function setup_buf(bufnr)
	if attached[bufnr] or vim.bo[bufnr].buftype ~= "" then
		return
	end

	local ok = vim.api.nvim_buf_attach(bufnr, false, {
		on_lines = function(_, b, _, first, _, new_last)
			if enabled then
				rescan(b, first, new_last)
			end
		end,
		on_reload = function(_, b)
			if enabled then
				rescan(b, 0, -1)
			end
		end,
		on_detach = function(_, b)
			attached[b] = nil
		end,
	})

	if not ok then
		return
	end

	attached[bufnr] = true
	if enabled then
		scan_range(bufnr, 0, -1)
	end
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("UnicodeWhitespace", { clear = true }),
	callback = function(ev)
		setup_buf(ev.buf)
	end,
})

for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
	if vim.api.nvim_buf_is_loaded(bufnr) then
		setup_buf(bufnr)
	end
end

vim.keymap.set("n", "<leader>ws", function()
	enabled = not enabled
	for bufnr in pairs(attached) do
		if vim.api.nvim_buf_is_valid(bufnr) then
			if enabled then
				scan_range(bufnr, 0, -1)
			else
				vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
			end
		end
	end
	vim.notify("unicode whitespace highlight: " .. (enabled and "on" or "off"))
end, { noremap = true, silent = true, desc = "Toggle unicode whitespace highlight" })
