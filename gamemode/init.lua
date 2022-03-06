-- Include and AddCSLua everything
include("shared.lua")
include("sh_translate.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_translate.lua")

MsgN("_-_-_-_- Flood Server Side -_-_-_-_")
MsgN("Loading Server Files")
for _, file in pairs (file.Find("flood/gamemode/server/*.lua", "LUA")) do
	MsgN("-> "..file)
	include("flood/gamemode/server/"..file) 
end

MsgN("Loading Shared Files")
for _, file in pairs (file.Find("flood/gamemode/shared/*.lua", "LUA")) do
	MsgN("-> "..file)
	AddCSLuaFile("flood/gamemode/shared/"..file)
end

MsgN("Loading Clientside Files")
for _, file in pairs (file.Find("flood/gamemode/client/*.lua", "LUA")) do
	MsgN("-> "..file)
	AddCSLuaFile("flood/gamemode/client/"..file)
end

MsgN("Loading Clientside VGUI Files")
for _, file in pairs (file.Find("flood/gamemode/client/vgui/*.lua", "LUA")) do
	MsgN("-> "..file)
	AddCSLuaFile("flood/gamemode/client/vgui/"..file)
end

MsgN("Loading Languages Files")
for _, file in pairs (file.Find("flood/gamemode/languages/*.lua", "LUA")) do
	MsgN("-> "..file)
end

-- Timer ConVars! Yay!
CreateConVar("flood_build_time", 300, FCVAR_NOTIFY, "Time allowed for building (def: 300)")
CreateConVar("flood_flood_time", 20, FCVAR_NOTIFY, "Time between build phase and fight phase (def: 20)")
CreateConVar("flood_fight_time", 360, FCVAR_NOTIFY, "Time allowed for fighting (def: 360)")
CreateConVar("flood_reset_time", 40, FCVAR_NOTIFY, "Time after fight phase to allow water to drain and other ending tasks (def: 40 - Dont recommend changing)")

-- Cash Convars
CreateConVar("flood_participation_cash", 40, FCVAR_NOTIFY, "Amount of cash given to a player every 5 seconds of being alive (def: 40)")
CreateConVar("flood_bonus_cash", 2000, FCVAR_NOTIFY, "Amount of cash given to the winner of a round (def: 2000)")

-- Water Hurt System
CreateConVar("flood_wh_enabled", 1, FCVAR_NOTIFY, "Does the water hurt players - 1=true 2=false (def: 1)")
CreateConVar("flood_wh_damage", 15, FCVAR_NOTIFY, "How much damage a player takes per cycle (def: 15)")

-- Prop Limits
CreateConVar("flood_max_player_props", 20, FCVAR_NOTIFY, "How many props a player can spawn (def: 20)")
CreateConVar("flood_max_donator_props", 30, FCVAR_NOTIFY, "How many props a donator can spawn (def: 30)")
CreateConVar("flood_max_admin_props", 40, FCVAR_NOTIFY, "How many props an admin can spawn (def: 40)")

-- Shooting underwater
CreateConVar("flood_arccw_shootunderwater", 1, FCVAR_NOTIFY, "Activate shooting underwater - 1=true 2=false (def: 1)")

function GM:Initialize()
	self.ShouldHaltGamemode = false
	self:InitializeRoundController()

	-- Dont allow the players to noclip
	RunConsoleCommand("sbox_noclip", "0")

	-- We have our own prop spawning system
	RunConsoleCommand("sbox_maxprops", "0")
end

function GM:InitPostEntity()
	self:CheckForWaterControllers()
	for k,v in pairs(ents.GetAll()) do 
		if v:GetClass() == "trigger_hurt" then 
			v:Remove() 
		end 
	end
end

function GM:Think()
	self:ForcePlayerSpawn()
	self:CheckForWinner()

	if self.ShouldHaltGamemode == true then
		hook.Remove("Think", "Flood_TimeController")
	end
end

function GM:CleanupMap()
	-- Refund what we can
	self:RefundAllProps()

	-- Cleanup the rest
	game.CleanUpMap()

	-- Call InitPostEntity
	self:InitPostEntity()
end

function GM:ShowHelp(ply)
	ply:ConCommand("flood_helpmenu")
end

function GM:EntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if GAMEMODE:GetGameState() ~= 2 and GAMEMODE:GetGameState() ~= 3 then
		return false
	else
		if not ent:IsPlayer() then
			if attacker:IsPlayer() then
				if attacker:GetActiveWeapon() ~= NULL then
					if attacker:GetActiveWeapon():GetClass() == "flood_arccw_waw_nambu" then
						ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 1)
					elseif attacker:GetActiveWeapon():GetClass() == "weapon_crowbar" then
						ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 20)
					elseif attacker:GetActiveWeapon():GetClass() == "weapon_stunstick" then
						if ent:GetNWInt("CurrentPropHealth") >= ent:GetNWInt("BasePropHealth") then
							ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("BasePropHealth"))
						elseif ent:GetNWInt("CurrentPropHealth") < ent:GetNWInt("BasePropHealth") then
							ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") + 80)
						end
					else
						for _, Weapon in pairs(Flood_Weapons) do
							if attacker:GetActiveWeapon():GetClass() == Weapon.Class then
								ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - tonumber(Weapon.Damage))
							end
						end
					end
				end
			else
				if attacker:GetClass() == "entityflame" then
					ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 0.5)
				else
					ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 1)
				end
			end
			
			if ent:GetNWInt("CurrentPropHealth") <= 0 and IsValid(ent) then
				ent:Remove()
			end
		end
	end
end

function ShouldTakeDamage(victim, attacker)
	if GAMEMODE:GetGameState() ~= 3 then
		return false
	else
		if attacker:IsPlayer() and victim:IsPlayer() then
			return false
		else
			if attacker:GetClass() ~= "prop_*" and attacker:GetClass() ~= "entityflame" then
				return true
			end
		end
	end
end
hook.Add("PlayerShouldTakeDamage", "Flood_PlayerShouldTakeDamge", ShouldTakeDamage)

function GM:KeyPress(ply, key)
 	if ply:Alive() ~= true then 
 		if key == IN_ATTACK then 
 			ply:CycleSpectator(1)
 		end 
 		if key == IN_ATTACK2 then 
 			ply:CycleSpectator(-1)
 		end 
 	end
end

function GM:PlayerSetHandsModel(ply, ent)
	local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
	local info = player_manager.TranslatePlayerHands(simplemodel)
	if (info) then
		ent:SetModel(info.model)
		ent:SetSkin(info.skin)
		ent:SetBodyGroups(info.body)
	end
end