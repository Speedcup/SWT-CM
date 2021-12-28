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
    SWT-CM - Server
--]]-------------------------------------------------------------------

local Player = FindMetaTable("Player")
--[[
	Function: SWT_CM:CanCloak( ply: user )

	Checks if a player can cloak.

	Returns:
		bool - canCloak
]]
function SWT_CM:CanCloak( ply )
	if not IsValid(ply) or ply:IsBot() then
		return false
	end

	-- Players should not be able to cloak themselves, when its disabled in water.
	if SWT_CM.Config.DisableCloakInWater then
		if ply:WaterLevel() >= 1 then
			return false
		end
	end

	if SWT_CM.Config.EnableBatterySystem then
		local battery = ply.CloakBattery or SWT_CM.Config.MaxBattery
		if battery < SWT_CM.Config.MinimumBattery then
			return false
		end
	end
	
	return true
end

function SWT_CM:Cloak( ply, force )
	if not IsValid(ply) or ply:IsBot() then
		return false
	end
	
	local isCloaked = ply:GetNWBool("SWT_CM.IsCloaked", false)

	-- If force is available and not nil, overwrite isCloaked with the force value.
	if force then
		isCloaked = force
	end

	if not isCloaked then
		-- Skip cancloak when its forced.
		if force == nil then
			if not SWT_CM:CanCloak(ply) then
				return
			end
		end

		ply.OldDraw = ply.Draw

		ply:RemoveAllDecals()
		ply:SetNoTarget(true)
		ply:DrawShadow(false)
		ply:SetNWBool("SWT_CM.IsCloaked", true)

		ply:SendLua([[surface.PlaySound("swt_cm/cloak_activation.mp3")]])
	else
		ply:SetNoTarget(false)
		ply:DrawShadow(true)
		ply:SetNWBool("SWT_CM.IsCloaked", false)

		ply:SendLua([[surface.PlaySound("swt_cm/cloak_deactivation.mp3")]])
	end
end

hook.Add("Think", "SWT_CM.BatterySystem", function()
	if SWT_CM.Config.EnableBatterySystem then
		for _, ply in pairs(player.GetHumans()) do
			if ply:HasWeapon("swt_cloakingmodule") then
				SWT_CM:CloakThink(ply)
			end
		end
	end
end)

hook.Add("PlayerSpawn", "SWT_CM.ResetCloakOnRespawn", function(ply)
	if ply:IsBot() then return end

	if ply:IsCloaked() then
		SWT_CM:Cloak(ply, false)
		ply.OldDraw = ply.Draw

		function ply:Draw(flags)
			if not ply:IsCloaked() then
				ply.OldDraw(flags)
			end
		end
	end
end)

hook.Add("EntityTakeDamage", "SWT_CM.UncloakOnDamage", function(ent, dmg)
	-- Check whether the damage is greater than 1 and "real". Damage random caused by bad maps are excluded by this method.
	if ent:IsPlayer() and ent:IsCloaked() and dmg:GetDamage() >= 1 then
		SWT_CM:Cloak(ent, false)
	end
end)

hook.Add("PlayerCanHearPlayersVoice", "SWT_CM.OnlyCloakedCanHearCloaked", function(rec, send)
	if SWT_CM.Config.OnlyCloakedCanHearCloaked then
		if send:IsCloaked() and rec:IsCloaked() then
			return true, true
		elseif send:IsCloaked() and not rec:IsCloaked() then
			return false
		end
	end
end)

-- InWater Check
hook.Add("Think", "SWT_CM.DisableWhileInWater", function()
	if SWT_CM.Config.DisableCloakInWater then
		for k, ply in pairs(player.GetHumans()) do
			if ply:IsCloaked() and ply:WaterLevel() == 1 then -- WaterLevel => https://wiki.facepunch.com/gmod/Entity:WaterLevel => 1 = Slightly submerged (at least to the feet) // should be enough? If too less, change it the way you want.
				SWT_CM:Cloak(ply, false)
			end
		end
	end
end)