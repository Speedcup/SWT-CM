--[[
	=================================================
	███████╗██╗    ██╗████████╗    ██████╗███╗   ███╗
	██╔════╝██║    ██║╚══██╔══╝   ██╔════╝████╗ ████║
	███████╗██║ █╗ ██║   ██║█████╗██║     ██╔████╔██║
	╚════██║██║███╗██║   ██║╚════╝██║     ██║╚██╔╝██║
	███████║╚███╔███╔╝   ██║      ╚██████╗██║ ╚═╝ ██║
	╚══════╝ ╚══╝╚══╝    ╚═╝       ╚═════╝╚═╝     ╚═╝
	=================================================
	-> Shadow-Trooper Cloaking Module

	_______________________________
	Created by
		- Speedcup (https://steamcommunity.com/id/speedcup/ - 76561198261053079)
		- Schmockwurst (https://steamcommunity.com/id/schmockwurst/ - 76561198197583550)
]]

--[[-------------------------------------------------------------------
    SWT-CM - Autorun Loader
--]]-------------------------------------------------------------------

SWT_CM = SWT_CM or {}

-- Just for debugging purposes, a debugmode. Defaultly disabled for your convenience.
SWT_CM.DebugMode = SWT_CM.DebugMode or true

--[[
	Function: SWT_CM:Print(text: string, type: string) -> None

	Just a function to print something to console.
]]
function SWT_CM:Print(text, type)
	-- Set default values, when a param wasnt set.
	text = text or ""
	type = type or "debug"

	if type == "info" then
		MsgC(Color(50, 200, 200), "[SWT-Cloaking] " .. text .. "\n")
	elseif type == "error" then
		MsgC(Color(255, 0, 0), "[SWT-Cloaking] " .. text .. "\n")
	elseif type == "success" then
		MsgC(Color(0, 255, 0), "[SWT-Cloaking] " .. text .. "\n")
	elseif (type == "debug" and SWT_CM.DebugMode) then
		MsgC(Color(255, 0, 0), "[SWT-Cloaking] " .. text .. "\n")
	end
end

function SWT_CM:Load(time)
	time = time or SysTime()

	local folder = "swt_cloakingmodule"

	if SERVER then
		AddCSLuaFile(folder .. "/" .. "sh_config.lua")
		AddCSLuaFile(folder .. "/" .. "sh_init.lua")
		AddCSLuaFile(folder .. "/" .. "cl_init.lua")

		include(folder .. "/" .. "sh_config.lua")
		include(folder .. "/" .. "sh_init.lua")
		include(folder .. "/" .. "sv_init.lua")
	end

	if CLIENT then
		include(folder .. "/" .. "sh_config.lua")
		include(folder .. "/" .. "sh_init.lua")
		include(folder .. "/" .. "cl_init.lua")
	end

	SWT_CM:Print("Loaded! [" ..math.Round(SysTime() - time, 4) .. "s]")
	hook.Run("SWT_CM.Loaded")
end

local start_time = SysTime()
SWT_CM:Print("Start Loading of SWT-Cloaking Module! [" ..math.Round(SysTime() - start_time, 4) .. "s]")
SWT_CM:Load(start_time)