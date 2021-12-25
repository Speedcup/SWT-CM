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

-- Whether the cloak should be deactivated in water. (Could cause performance issues, because we have to check the status of a player every second.)
SWT_CM.Config.DisableCloakInWater = true

-- Default cooldown between client swep interactions. (Leftclick, Rightclick, Reload) - Just should prevent spamming.
SWT_CM.Config.DefaultSWEPCooldown = 1

-- The minimum distance to see player informations
SWT_CM.Config.ESPDistance = 500

-- Here you can enable/disable some information types, whether they should be shown or not.
SWT_CM.Config.ESPInformations = {
    ["health"] = true,
    ["armor"] = true,
}

-- A system that prevents player from using infinite cloak.
SWT_CM.Config.EnableBatterySystem = true

-- The Max Battery, here you could set a different value for each player. (For example Donator = 200?, normal players = 100, thats why i used a function.)
SWT_CM.Config.MaxBattery = 100

-- Battery Loose in seconds
SWT_CM.Config.BatteryLoose = 20

-- Battery Regeneration in seconds
SWT_CM.Config.BatteryRegeneration = 2

-- Minimum Battery to cloke / use holo
SWT_CM.Config.MinimumBattery = (SWT_CM.Config.MaxBattery / 10)