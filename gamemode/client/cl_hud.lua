surface.CreateFont( "Flood_HUD", {
	font = "Tahoma",
	size = 16,
	weight = 500,
	antialias = true
})

surface.CreateFont( "Flood_HUD_Large", {
	font = "Tahoma",
	size = 30,
	weight = 500,
	antialias = true
})

surface.CreateFont( "Flood_HUD_B", {
	font = "Tahoma",
	size = 18,
	weight = 600,
	antialias = true
})

surface.CreateFont( "Flood_HUD_C", {
	font = "Tahoma",
	size = 18,
	weight = 500,
	antialias = true
})

surface.CreateFont( "Flood_HUD_D", {
	font = "Tahoma",
	size = 30,
	weight = 1000,
	antialias = true
})

-- Hud Stuff
local color_blue = Color(50, 155, 220, 255)
local color_dark_blue = Color(40, 60, 80, 255)
local color_icon = Color(255, 255, 255, 255)
local color_light_grey = Color(60, 80, 100, 255)
local color_orange = Color(238, 118, 0, 255)
local color_snow = Color(255, 250, 250, 255)
local color_black = Color(0, 0, 0, 255)

-- Hud Positioning
local x = ScrW()
local y = ScrH()
local xPos = x * 0.0025
local yPos = y * 0.005
local Spacer = y * 0.006
local xSize = x * 0.2
local ySize = y * 0.04
local bWidth = Spacer + xSize + Spacer
local bHeight = Spacer + ySize + Spacer

-- Timer Stuff
local GameState = 0
local BuildTimer = -1
local FloodTimer = -1
local FightTimer = -1
local ResetTimer = -1

-- Hud Icon Material
local flood_icon_blood = Material("materials/hud_icon/blood.png")
local flood_icon_cash = Material("materials/hud_icon/cash.png")
local flood_icon_wait = Material("materials/hud_icon/wait.png")
local flood_icon_build = Material("materials/hud_icon/build.png")
local flood_icon_in = Material("materials/hud_icon/in.png")
local flood_icon_fight = Material("materials/hud_icon/fight.png")
local flood_icon_restart = Material("materials/hud_icon/restart.png")
local flood_icon_gun = Material("materials/hud_icon/gun.png")

local function draw_Picon(x, y, w, h, color, icon)
	surface.SetMaterial(icon)
	surface.SetDrawColor(color)
	surface.DrawTexturedRect(x, y, w, h)
end

net.Receive("RoundState", function(len)
	GameState = net.ReadFloat()
	BuildTimer = net.ReadFloat()
	floodTimer = net.ReadFloat()
	FightTimer = net.ReadFloat()
	ResetTimer = net.ReadFloat()
end)

function FloodMainHUD()

	if BuildTimer and FloodTimer and FightTimer and ResetTimer then
		if GameState == 0 then
		    draw.RoundedBox(0, 10, ScrH() - 210, 260, 50, color_blue)
			draw.RoundedBox(0, 15, ScrH() - 205, 250, 40, color_dark_blue)
			
			draw_Picon(20, ScrH() - 201, 32, 32, color_icon, flood_icon_wait)
			draw.SimpleText(translate.Get("HUD_Waiting_for_players"), "Flood_HUD_C", 60, ScrH() - 195, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end
		
		if GameState == 1 then
            draw.RoundedBox(0, 10, ScrH() - 210, 260, 50, color_blue)
			draw.RoundedBox(0, 15, ScrH() - 205, 250, 40, color_dark_blue)
			
			draw_Picon(20, ScrH() - 201, 32, 32, color_icon, flood_icon_build)
			draw.SimpleText(translate.Get("HUD_Build_a_boat"), "Flood_HUD_C", 60, ScrH() - 195, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.SimpleText(BuildTimer, "Flood_HUD_C", 230, ScrH() - 195, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end

		if GameState == 2 then
            draw.RoundedBox(0, 10, ScrH() - 210, 260, 50, color_blue)
			draw.RoundedBox(0, 15, ScrH() - 205, 250, 40, color_dark_blue)
			
			draw_Picon(20, ScrH() - 201, 32, 32, color_icon, flood_icon_in)
			draw.SimpleText(translate.Get("HUD_Get_on_your_boat"), "Flood_HUD_C", 60, ScrH() - 195, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.SimpleText(floodTimer, "Flood_HUD_C", 230, ScrH() - 195, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end
		
		if GameState == 3 then
            draw.RoundedBox(0, 10, ScrH() - 210, 260, 50, color_blue)
			draw.RoundedBox(0, 15, ScrH() - 205, 250, 40, color_dark_blue)
			
			draw_Picon(20, ScrH() - 201, 32, 32, color_icon, flood_icon_fight)
			draw.SimpleText(translate.Get("HUD_Destroy_enemy_boats"), "Flood_HUD_C", 60, ScrH() - 195, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.SimpleText(FightTimer, "Flood_HUD_C", 230, ScrH() - 195, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end

		if GameState == 4 then
            draw.RoundedBox(0, 10, ScrH() - 210, 260, 50, color_blue)
			draw.RoundedBox(0, 15, ScrH() - 205, 250, 40, color_dark_blue)
			
			draw_Picon(20, ScrH() - 201, 32, 32, color_icon, flood_icon_restart)
			draw.SimpleText(translate.Get("HUD_Restarting_the_round"), "Flood_HUD_C", 60, ScrH() - 195, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.SimpleText(ResetTimer, "Flood_HUD_C", 230, ScrH() - 195, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end
	end

	-- Display Player's Health and Name
	local tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
	if tr.Entity:IsValid() and tr.Entity:IsPlayer() then
		draw.SimpleText(translate.Get("HUD_Name") .. tr.Entity:GetName(), "Flood_HUD_B", x * 0.5, y * 0.5 - 80, color_snow, 1, 1)
		draw.SimpleText(translate.Get("HUD_Health") .. tr.Entity:Health(), "Flood_HUD_B", x * 0.5, y * 0.5 - 60, color_snow, 1, 1)
	end

	-- Bottom left HUD Stuff
	if LocalPlayer():Alive() and IsValid(LocalPlayer()) then
	    -- Left Rounded Box
		draw.RoundedBox(20, 10, ScrH() - 154, 370, 20, color_blue)
		draw.RoundedBox(0, 10, ScrH() - 144, 370, 20, color_blue)
		draw.RoundedBox(20, 10, ScrH() - 30, 370, 20, color_dark_blue)
		draw.RoundedBox(0, 10, ScrH() - 124, 370, 100, color_dark_blue)
		
		-- Health
		local pHealth = LocalPlayer():Health()
		
		draw_Picon(120, ScrH() - 120, 32, 32, color_icon, flood_icon_blood)
	    draw.RoundedBox(8, 158, ScrH() - 118, 215, 25, color_light_grey)
		draw.RoundedBox(8, 162, ScrH() - 114, pHealth * 2.07, 18, Color(200, 10, 10, 255))
		draw.SimpleText(math.Max(pHealth, 0),"Flood_HUD_B", 203 * 1.3, ScrH() - 106, color_snow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
		-- Ammo
		if IsValid(LocalPlayer():GetActiveWeapon()) then
			if LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) > 0 or LocalPlayer():GetActiveWeapon():Clip1() > 0 then
				local wBulletCount = LocalPlayer():GetActiveWeapon():Clip1()
				local wBulletCount2 = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())

				-- Right Rounded Box
				draw.RoundedBox(20, ScrW() - 170, ScrH() - 104, 160, 20, color_blue)
				draw.RoundedBox(0, ScrW() - 170, ScrH() - 94, 160, 20, color_blue)
				draw.RoundedBox(20, ScrW() - 170, ScrH() - 30, 160, 20, color_dark_blue)
				draw.RoundedBox(0, ScrW() - 170, ScrH() - 84, 160, 60, color_dark_blue)

				draw.SimpleText(wBulletCount .. "/" .. wBulletCount2, "Flood_HUD_D", ScrW() - 125, ScrH() - 65, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			end
		end

		-- Cash
		local pCash = LocalPlayer():GetNWInt("flood_cash") or 0

        draw_Picon(120, ScrH() - 44, 32, 32, color_icon, flood_icon_cash)
		draw.RoundedBox(8, 158, ScrH() - 42, 215, 25, color_light_grey)
		draw.RoundedBox(8, 162, ScrH() - 38, 207, 18, Color(27, 147, 99, 255))
		draw.SimpleText(pCash, "Flood_HUD_B", 203 * 1.3, ScrH() - 30, color_snow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		-- Display Player's Name & Flood Version
		local pName = LocalPlayer():Nick()
		
		draw.SimpleText(pName, "Flood_HUD", 20, ScrH() - 146, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		draw.SimpleText(Flood_Version, "Flood_HUD", 370, ScrH() - 146, color_snow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
		
		-- Display Player's Avatar
		if !IsValid(Avatar) then
			Avatar = vgui.Create("AvatarImage")
			Avatar:ParentToHUD()
			Avatar:SetPlayer(LocalPlayer(), 92)
			Avatar:SetSize(92, 92)
			Avatar:SetPos(20, ScrH() - 113)
		end
		
		-- Display Player's Weapons Armed
		if IsValid(LocalPlayer():GetActiveWeapon()) then
			local wArmed = LocalPlayer():GetActiveWeapon( ):GetPrintName()

            draw_Picon(120, ScrH() - 82, 32, 32, color_icon, flood_icon_gun)
			draw.RoundedBox(8, 158, ScrH() - 80, 215, 25, color_light_grey)
		    draw.RoundedBox(8, 162, ScrH() - 76, 207, 18, color_orange)
			draw.SimpleText(wArmed, "Flood_HUD_B", 203 * 1.3, ScrH() - 68, color_snow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
		    draw_Picon(120, ScrH() - 82, 32, 32, color_icon, flood_icon_gun)
			draw.RoundedBox(8, 158, ScrH() - 80, 215, 25, color_light_grey)
			draw.SimpleText(translate.Get("HUD_Unarmed"),"Flood_HUD_B", 203 * 1.3, ScrH() - 68, color_snow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		draw.RoundedBox(20, 10, ScrH() - 154, 370, 20, color_blue)
		draw.RoundedBox(0, 10, ScrH() - 144, 370, 20, color_blue)
		draw.RoundedBox(20, 10, ScrH() - 30, 370, 20, color_dark_blue)
		draw.RoundedBox(0, 10, ScrH() - 124, 370, 100, color_dark_blue)
		
		-- Health
		draw_Picon(120, ScrH() - 120, 32, 32, color_icon, flood_icon_blood)
	    draw.RoundedBox(8, 158, ScrH() - 118, 215, 25, color_light_grey)
		draw.SimpleText(translate.Get("HUD_Youre_Dead"),"Flood_HUD_B", 203 * 1.3, ScrH() - 106, color_snow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
		-- Display Player's Unarmed
		draw_Picon(120, ScrH() - 82, 32, 32, color_icon, flood_icon_gun)
		draw.RoundedBox(8, 158, ScrH() - 80, 215, 25, color_light_grey)
		draw.SimpleText(translate.Get("HUD_Unarmed"),"Flood_HUD_B", 203 * 1.3, ScrH() - 68, color_snow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		-- Cash
		local pCash = LocalPlayer():GetNWInt("flood_cash") or 0

        draw_Picon(120, ScrH() - 44, 32, 32, color_icon, flood_icon_cash)
		draw.RoundedBox(8, 158, ScrH() - 42, 215, 25, color_light_grey)
		draw.RoundedBox(8, 162, ScrH() - 38, 207, 18, Color(27, 147, 99, 255))
		draw.SimpleText(pCash, "Flood_HUD_B", 203 * 1.3, ScrH() - 30, color_snow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		-- Display Player's Name & Flood Version
		local pName = LocalPlayer():Nick()
		
		draw.SimpleText(pName,"Flood_HUD", 20, ScrH() - 146, color_snow, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		draw.SimpleText(Flood_Version,"Flood_HUD", 370, ScrH() - 146, color_snow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
	end
end

hook.Add("HUDPaint", "FloodMainHUD", FloodMainHUD)

function hidehud(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do 
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud)

-- This code will turn off the player and health appearing when you look at them
hook.Add("HUDDrawTargetID", "HidePlayerInfo", function()
	return false
end)
