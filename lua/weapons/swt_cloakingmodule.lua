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
    SWT-CM - Weapon
--]]-------------------------------------------------------------------

AddCSLuaFile()

SWEP.PrintName = "SWT Cloaking Module"
SWEP.Category = "[SW:RP] Speedcup & Schmockwurst"

SWEP.Author = "Speedcup & Schmockwurst"
SWEP.Purpose = "You can now cloak yourself! Like a real SWT! HOW COOL?!"
SWEP.Instructions = "LeftClick: Cloak / Uncloak\nRightClick: Scan a Player/NPC!\nReload: Toggle Hud"

SWEP.HoldType = "passive"

SWEP.Slot = 2
SWEP.SlotPos = 100

SWEP.Spawnable = true

SWEP.ViewModel = ""
SWEP.WorldModel = "models/Items/combine_rifle_ammo01.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 0

function SWEP:Initialize()
	if SERVER then
		SWT_CM:Cloak(self:GetOwner(), false)
		self:SetHoldType( "normal" )
	end
end

SWEP.PrimaryCooldown = 0
function SWEP:PrimaryAttack()
	if self.PrimaryCooldown < CurTime() then
		local cloaked = self:GetOwner():IsCloaked()

		if SERVER then
			local ply = self:GetOwner()
			SWT_CM:Cloak(ply)
		end

		self.PrimaryCooldown = CurTime() + SWT_CM.Config.DefaultSWEPCooldown
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then
		local trace = LocalPlayer():GetEyeTrace()
		local ent = trace.Entity

		if IsValid(ent) and LocalPlayer():GetPos():Distance(ent:GetPos()) <= SWT_CM.Config.ESPDistance then	--and ent:IsPlayer()
			LocalPlayer():AddToRelations(ent)
		end

		self:SetNextSecondaryFire(CurTime() + SWT_CM.Config.DefaultSWEPCooldown)
	end
end

SWEP.ReloadCooldown = 0
function SWEP:Reload()
	if self.ReloadCooldown < CurTime() then
		if CLIENT then
			SWT_CM:ToggleHUD()
		end

		self.ReloadCooldown = CurTime() + SWT_CM.Config.DefaultSWEPCooldown
	end
end