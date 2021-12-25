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
function SWT_CM:Cloak( ply, force )
	if not ply:IsValid() then
		return
	end

	local isCloaked = ply:GetNWBool("SWT_CM.IsCloaked", false)

	-- If force is available and not nil, overwrite isCloaked with the force value.
	if force then
		isCloaked = force
	end

	if not isCloaked then
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

-- Just an alias for SWT_CM:Cloak(ply)
--function Player:DoSWTCloak()
--	SWT_CM:Cloak( self )
--end

hook.Add("PlayerSpawn", "SWT_CM.ResetCloakOnRespawn", function(ply)
	SWT_CM:Cloak(ply, false)
	ply.OldDraw = ply.Draw

	function ply:Draw(flags)
		if not ply:IsCloaked() then
			ply.OldDraw(flags)
		end
	end
end)

-- TODO
-- Every GMod Damage 
--[[
SWT.DamageList = {
	0,
	1,
	2,
	4,
	8,
	16,
	32,
	64,
	128,
	256,
	1024,
	2048,
	4096,
	16384,
	65536,
	2097152,
	16777216,
	67108864,
	134217728,
	1073741824,
	536870912,
	2147483648
}
]]

hook.Add("EntityTakeDamage", "SWT_CM.UncloakOnDamage", function(ent, dmg)
	-- Check whether the damage is greater than 1 and "real". Damage random caused by bad maps are excluded by this method.
	if ent:IsPlayer() and dmg:GetDamage() >= 1 then
		if ent:IsCloaked() then
			-- For the moment deactivated; TODO
			--if table.HasValue(SWT.DamageList, dmg:GetDamageType()) then
				SWT_CM:Cloak(ent, false)
			--end
		end
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