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
    SWT-CM - Config
--]]-------------------------------------------------------------------

SWT_CM.Config = SWT_CM.Config or {}

-- Should footsteps be disabled while a player is cloaked?
SWT_CM.Config.DisableFootstepsWhileCloaked = true

-- Whether cloaked people can only hear other cloaked people.
SWT_CM.Config.OnlyCloakedCanHearCloaked = true

-- Default cooldown between client swep interactions. (Leftclick, Rightclick, Reload) - Just should prevent spamming.
SWT_CM.Config.DefaultSWEPCooldown = 1

-- The minimum distance to see player informations
SWT_CM.Config.ESPDistance = 500

-- Here you can enable/disable some information types, whether they should be shown or not.
SWT_CM.Config.ESPInformations = {
    ["health"] = true,
    ["armor"] = true,
}