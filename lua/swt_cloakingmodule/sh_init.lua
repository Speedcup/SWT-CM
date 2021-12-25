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
    SWT-CM - Shared
--]]-------------------------------------------------------------------

local Player = FindMetaTable("Player")

function SWT_CM:CloakThink(ply)
	if not (IsValid(ply) or ply:Alive() or SWT_CM.Config.EnableBatterySystem) then
		return false
	end

	local maxBattery = SWT_CM.Config.MaxBattery
	local battery = ply.CloakBattery or maxBattery

	if ply:IsCloaked() and battery > 0 then
		ply.CloakBattery = math.max(0, battery - SWT_CM.Config.BatteryLoose * FrameTime())
	elseif ply:IsCloaked() and battery < 1 then
		if SERVER then
			SWT_CM:Cloak( ply, false )
		end
	elseif not ply:IsCloaked() then
		ply.CloakBattery = math.min(maxBattery, battery + SWT_CM.Config.BatteryRegeneration * FrameTime())
	end
end

--[[
	Function: Player:IsCloaked() -> bool
	Meta: Player

	Returns whether the player is currently cloaked by the swt cloaking module or not.

	Returns:
		bool - isCloaked
]]
function Player:IsCloaked()
	return self:GetNWBool("SWT_CM.IsCloaked", false)
end

-- Disable footsteps while cloaked.
hook.Add( "PlayerFootstep", "SWT_CM.DisableFootstepsWhileCloaked", function(ply, pos, foot, sound, volume, filter)
	if SWT_CM.Config.DisableFootstepsWhileCloaked and ply:GetNWBool("SWT_CM.IsCloaked", false) then
		return true
	end
end)