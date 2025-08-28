-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "ayu_dark",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

	-- VSCode-like breakpoint sign: white center on red circle (approx)
	-- Use a white glyph on a red background to emulate VS Code's red circle with white center.
	vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ffffff", bg = "#ff0000", bold = true })
	-- Subtle line highlight when a breakpoint is set
	vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#330000" })
	-- Define the sign shown in the gutter (white dot on red bg)
	vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint" })

	-- VSCode-like 'stopped' arrow: yellow arrow and line highlight
	vim.api.nvim_set_hl(0, "DapStopped", { fg = "#000000", bg = "#ffff00", bold = true })
	vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#ffff00" })
	vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStopped" })

return M
