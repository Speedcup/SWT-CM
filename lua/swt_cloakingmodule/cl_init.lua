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
    SWT-CM - Client
--]]-------------------------------------------------------------------

surface.CreateFont( "SWT-HUD-01", {
	font = "Roboto",
	extended = true,
	size = ScreenScale(5),
	weight = 500,
	blursize = 0,
	scanlines = 2,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

surface.CreateFont( "SWT-HUD-02", {
	font = "Roboto",
	extended = true,
	size = ScreenScale(30),
	weight = 500,
	blursize = 0,
	scanlines = 2,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

local ply = nil
local plys = {}
--SWT.ESP = false

local classTable = {
	["player"] = {
		name = "Spieler",
		relation = "Unknown"
	},
	["npc_combine_s"] = {
		name = "Unknown",
		relation = "Enemy"
	},
	["npc_citizen"] = {
		name = "Unknown",
		relation = "Ally"
	},
}


function SWT_CM:ToggleHUD()
	if SWT_CM.ESP ~= true then
		surface.PlaySound("swt_cm/esp_activation.mp3")
	else
		surface.PlaySound("swt_cm/esp_deactivation.mp3")
	end

	SWT_CM.ESP = not SWT_CM.ESP
end

local function coordinates( ent )
	local min, max = ent:OBBMins(), ent:OBBMaxs()
	local corners = {
        Vector( min.x, min.y, min.z ),
        Vector( min.x, min.y, max.z ),
        Vector( min.x, max.y, min.z ),
        Vector( min.x, max.y, max.z ),
        Vector( max.x, min.y, min.z ),
        Vector( max.x, min.y, max.z ),
        Vector( max.x, max.y, min.z ),
        Vector( max.x, max.y, max.z )
	}

	local minX, minY, maxX, maxY = ScrW() * 2, ScrH() * 2, 0, 0
	for _, corner in pairs( corners ) do
    	local onScreen = ent:LocalToWorld( corner ):ToScreen()
        minX, minY = math.min( minX, onScreen.x ), math.min( minY, onScreen.y )
        maxX, maxY = math.max( maxX, onScreen.x ), math.max( maxY, onScreen.y )
	end
 
	return minX, minY, maxX, maxY
end

timer.Create("ReloadCloakedPlayers", 5, 0, function()
	plys = {}

	for k, v in pairs(player.GetHumans()) do
		if v:IsCloaked() then
			table.insert(plys,v)
		end
	end
end)

hook.Add("PrePlayerDraw", "SWT_CM.StopDrawingOfCloaked",function(ent)
	if ent:IsCloaked() then
		if SWT_CM.ESP == true then
			return false
		end

		local wep = ent:GetActiveWeapon()

		if IsValid(wep) then
			wep:SetNoDraw(true)
		end

		return true
	end
end)

hook.Add("PreDrawHalos", "DrawYourselfWhileCloaked",function()
	if SWT_CM.ESP then
		halo.Add(plys, Color(100, 100, 255), 2, 2, 1, false, false)
	end
end)

hook.Add("HUDPaint","DrawSWTVisorEffect",function() 
	local w, h = ScrW(),ScrH()
	ply = LocalPlayer()

	--Marking on the side of the screen when cloaked
	if LocalPlayer():IsCloaked() then
		surface.SetFont("SWT-HUD-02")
		local x,y = surface.GetTextSize("Cloaked!")

		draw.SimpleTextOutlined("Cloaked!", "SWT-HUD-02", w * 0.98 - x, h / 2 - y / 2, Color(255,40,40,230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	end
	
	--ESP + NPC/Player-Marker + DontDrawCloakedPeople
	for k,v in pairs( player.GetAll() ) do
       	--if v:GetNWBool("SWT.cloaked",false)==true and IsValid(v:GetActiveWeapon()) then v:GetActiveWeapon():SetNoDraw(true) end
       	if v ~= LocalPlayer() and SWT_CM.ESP and ply ~= nil then
    		local pos = v:GetPos()
    		local dist = ply:GetPos():Distance( pos )
    		local crosshair = ply:GetEyeTrace().HitPos:ToScreen()

	       	if dist < SWT_CM.Config.ESPDistance and dist > 35 and (crosshair.x - 30 < v:GetPos():ToScreen().x and crosshair.x + 30 > v:GetPos():ToScreen().x) then    		
	        	if v:IsPlayer() or v:IsNPC() then
    				local x1, y1, x2, y2 = coordinates(v)
    				if classTable[v:GetClass()].relation == "Enemy" then
					    surface.SetDrawColor(255,0,0)
					elseif classTable[v:GetClass()].relation == "Ally" then
						surface.SetDrawColor(0,255,0)
					elseif v:IsPlayer() and v:IsCloaked() then
						surface.SetDrawColor(50,50,230)
					else
						surface.SetDrawColor(170,170,170)
					end

					if (0 < x2 and x1 < ScrW()) and (0 < y2 and y1 < ScrH()) then 
				    	surface.DrawLine( x1, y1, x2, y1 )
				    	surface.DrawLine( x1, y1, x1, y2 )
				    	surface.DrawLine( x2, y2, x1, y2 )
				    	surface.DrawLine( x2, y2, x2, y1 )

				    	origx1,origx2,origy1,origy2 = x1,x2,y1,y2

						draw.SimpleTextOutlined("Type: "..classTable[v:GetClass()].name,"SWT-HUD-01",x2+4,y1,Color(250,250,250),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,Color(0,0,0,255)) y1=y1+14
	    	   			draw.SimpleTextOutlined("Relation: "..classTable[v:GetClass()].relation,"SWT-HUD-01",x2+4,y1,Color(250,250,250),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,Color(0,0,0,255)) y1=y1+14
				    	if v:Health() > 0 then
	    	   				if v:GetActiveWeapon() ~= NULL then draw.SimpleTextOutlined("Weapon: "..v:GetActiveWeapon():GetPrintName(),"SWT-HUD-01",x2+4,y1,Color(250,250,250),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,Color(0,0,0,255)) y1=y1+14 end
				    		y1 = origy1
							draw.SimpleTextOutlined("Status: Alive", "SWT-HUD-01",x1-4,y1,Color(250,250,250),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
							y1 = y1 + 14

							if SWT_CM.Config.ESPInformations["health"] then
	        					draw.SimpleTextOutlined("HP: "..v:Health(),"SWT-HUD-01",x1-4,y1,Color(250,250,250),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
								y1 = y1 + 14
							end
							
							if SWT_CM.Config.ESPInformations["armor"] then
								if v:IsPlayer() then
									draw.SimpleTextOutlined("AP: " .. v:Armor(), "SWT-HUD-01", x1 - 4, y1, Color(250,250,250), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
								end
							end
    					else
    						draw.SimpleTextOutlined("Status: Dead","SWT-HUD-01", x1-4, origy1, Color(250,250,250), TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,1,Color(255,0,0,255)) y1=y1+14
    					end
    				end
    			end
    		elseif dist < 2652 and dist > 35 then
    			if v:IsNPC() or v:Alive() then
    				local bone = v:LookupBone("ValveBiped.Bip01_Head1")
    				if (v:IsPlayer() or v:IsNPC()) and isnumber(bone)==true then pos = v:GetBonePosition(bone) end
    				local screenPos = pos:ToScreen()

    				if not v:IsCloaked() then
    					draw.RoundedBox(10,screenPos.x-5,screenPos.y-5,10,10,Color(255,40,40))
    					draw.SimpleTextOutlined("Unknown","SWT-HUD-01",screenPos.x+7,screenPos.y,Color(250,250,250),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(255,0,0,255))
    					draw.SimpleTextOutlined(math.Round(dist/52.521,0).." m","SWT-HUD-01",screenPos.x+7,screenPos.y+13,Color(250,250,250),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(255,0,0,255))
    				else
						draw.RoundedBox(10,screenPos.x-5,screenPos.y-5,10,10,Color(50,00,230))
    					draw.SimpleTextOutlined("Cloaked SWT - "..v:Nick(),"SWT-HUD-01",screenPos.x+7,screenPos.y,Color(250,250,250),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(255,0,0,255))
    					draw.SimpleTextOutlined(math.Round(dist/52.521,0).." m","SWT-HUD-01",screenPos.x+7,screenPos.y+13,Color(250,250,250),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,1,Color(255,0,0,255))    					
    				end
    			end
    		end
    	end
    end
end)

hook.Add("HUDPaintBackground","DrawSWTCloakEffect",function()
	if SWT_CM.ESP == true then
		draw.DrawColoredBlurRect(-1,-1, ScrW() + 2, ScrH() + 2, Color(0, 0, 0, 150), 3, 1, 0)
		if not LocalPlayer():Alive() then
			SWT_CM.ESP = false
		end
	end
end)

util.blur = Material("pp/blurscreen")
function draw.DrawColoredBlurRect(xpos, ypos, width, height, color, layers, density, outline)
    local x, y = 0, 0

    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial(util.blur)

    for i = 1, layers do
        util.blur:SetFloat('$blur', (i / layers) * density)
        util.blur:Recompute()

        render.UpdateScreenEffectTexture()

        render.SetScissorRect(xpos + 1, ypos + 1, xpos + (width + 1), ypos + (height + 1), true)
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        render.SetScissorRect(0, 0, 0, 0, false)
    end

    surface.SetDrawColor(color)
    surface.DrawRect(xpos, ypos, width, height)
end