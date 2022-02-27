-- =================================
-- NADMOD PP - Prop Protection
-- By Nebual@nebtown.info 2012
-- Menus designed after SpaceTech's Simple Prop Protection
-- =================================
if !NADMOD then 
	NADMOD = {}
	NADMOD.PropOwners = {}
	NADMOD.PPConfig = {}
	NADMOD.Friends = {}
end

local Props = NADMOD.PropOwners
net.Receive("nadmod_propowners",function(len) 
	local num = net.ReadUInt(16)
	for k=1,num do
		local id,str = net.ReadUInt(16), net.ReadString()
		if str == "-" then Props[id] = nil 
		elseif str == "W" then Props[id] = "World"
		elseif str == "O" then Props[id] = "Ownerless"
		else Props[id] = str
		end
	end
end)

local font = "ChatFont"
function NADMOD.HUDPaint()
	local tr = LocalPlayer():GetEyeTrace()
	if !tr.HitNonWorld then return end
	local ent = tr.Entity
	if ent:IsValid() && !ent:IsPlayer() then
	    local color_snow = Color(255, 250, 250, 255)
		local color_blue = Color(50, 155, 220, 255)
		local text = translate.Get("HUD_Health") .. tr.Entity:GetNWInt("CurrentPropHealth")
		local text2 = translate.Get("NADMOD_Owner") .. (Props[ent:EntIndex()] or "N/A")
		surface.SetFont(font)
		local Width, Height = surface.GetTextSize(text)
		local w2,h2 = surface.GetTextSize(text2)
		local boxHeight = Height + h2 + 16
		local boxWidth = math.Max(Width,w2) + 25
		draw.RoundedBox(0, ScrW() - (boxWidth + 4), (ScrH()/2 - 200) - 16, boxWidth, boxHeight, color_blue)
		draw.SimpleText(text, font, ScrW() - (Width / 2) - 20, ScrH()/2 - 200, color_snow, 1, 1)
		draw.SimpleText(text2, font, ScrW() - (w2 / 2) - 20, ScrH()/2 - 200 + Height, color_snow, 1, 1)
	end
end

hook.Add("HUDPaint", "NADMOD.HUDPaint", NADMOD.HUDPaint)

function NADMOD.CleanCLRagdolls()
	for k,v in pairs(ents.FindByClass("class C_ClientRagdoll")) do v:SetNoDraw(true) end
	for k,v in pairs(ents.FindByClass("class C_BaseAnimating")) do v:SetNoDraw(true) end
end
net.Receive("nadmod_cleanclragdolls", NADMOD.CleanCLRagdolls)
concommand.Add("npp_cleanclragdolls",NADMOD.CleanCLRagdolls)

-- =============================
-- NADMOD PP CPanels
-- =============================
net.Receive("nadmod_ppconfig",function(len)
	NADMOD.PPConfig = net.ReadTable()
	for k,v in pairs(NADMOD.PPConfig) do
		local val = v
		if isbool(v) then val = v and "1" or "0" end
		
		CreateClientConVar("npp_"..k,val, false, false)
		RunConsoleCommand("npp_"..k,val)
	end
	NADMOD.AdminPanel(NADMOD.AdminCPanel, true)
end)

concommand.Add("npp_apply",function(ply,cmd,args)
	for k,v in pairs(NADMOD.PPConfig) do
		if isbool(v) then NADMOD.PPConfig[k] = GetConVar("npp_"..k):GetBool()
		elseif isnumber(v) then NADMOD.PPConfig[k] = GetConVarNumber("npp_"..k)
		else NADMOD.PPConfig[k] = GetConVarString("npp_"..k)
		end
	end
	net.Start("nadmod_ppconfig")
		net.WriteTable(NADMOD.PPConfig)
	net.SendToServer()
end)

function NADMOD.AdminPanel(Panel, runByNetReceive)
	if Panel then
		if !NADMOD.AdminCPanel then NADMOD.AdminCPanel = Panel end
	end
	if not runByNetReceive then 
		RunConsoleCommand("npp_refreshconfig")
		timer.Create("NADMOD.AdminPanelCheckFail",0.75,1,function()
			Panel:ClearControls()
			Panel:Help(translate.Get("NADMOD_ISADMIN"))
		end)
		return
	end
	
	timer.Remove("NADMOD.AdminPanelCheckFail")
	Panel:ClearControls()
	Panel:SetName(translate.Get("NADMOD_NADMOD_PP_Admin_Panel"))
	
	Panel:CheckBox(	translate.Get("NADMOD_Main_PP_Power_Switch"), "npp_toggle")
	Panel:CheckBox(	translate.Get("NADMOD_Admins_can_touch_anything"), "npp_adminall")
	Panel:CheckBox(	translate.Get("NADMOD_Use_Protection"), "npp_use")
	
	local txt = Panel:Help(translate.Get("NADMOD_Autoclean_Disconnected_Players"))
	txt:SetAutoStretchVertical(false)
	txt:SetContentAlignment( TEXT_ALIGN_CENTER )
	Panel:CheckBox(	translate.Get("NADMOD_Autoclean_Admins"), "npp_autocdpadmins")
	Panel:NumSlider(translate.Get("NADMOD_Autoclean_Timer"), "npp_autocdp", 0, 1200, 0 )
	Panel:Button(translate.Get("NADMOD_Apply_Settings"), "npp_apply") 
	
	local txt = Panel:Help(translate.Get("NADMOD_Cleanup_Panel"))
	txt:SetContentAlignment( TEXT_ALIGN_CENTER )
	txt:SetFont("DermaDefaultBold")
	txt:SetAutoStretchVertical(false)
	
	local counts = {}
	for k,v in pairs(NADMOD.PropOwners) do 
		counts[v] = (counts[v] or 0) + 1 
	end
	local dccount = 0
	for k,v in pairs(counts) do
		if k != "World" and k != "Ownerless" then dccount = dccount + v end
	end
	for k, ply in pairs(player.GetAll()) do
		if IsValid(ply) then
			Panel:Button( ply:Nick().." ("..(counts[ply:Nick()] or 0)..")", "nadmod_cleanupprops", ply:EntIndex() ) 
			dccount = dccount - (counts[ply:Nick()] or 0)
		end
	end
	
	Panel:Help(""):SetAutoStretchVertical(false) -- Spacer
	Panel:Button(translate.Get("NADMOD_Cleanup_Disconnected_Players_Props")..dccount..")", "nadmod_cdp")
	Panel:Button(translate.Get("NADMOD_Cleanup_All_NPCs"), 			"nadmod_cleanclass", "npc_*")
	Panel:Button(translate.Get("NADMOD_Cleanup_All_Ragdolls"), 		"nadmod_cleanclass", "prop_ragdol*")
	Panel:Button(translate.Get("NADMOD_Cleanup_Clientside_Ragdolls"), "nadmod_cleanclragdolls")
end

net.Receive("nadmod_ppfriends",function(len)
	NADMOD.Friends = net.ReadTable()
	for _,tar in pairs(player.GetAll()) do
		CreateClientConVar("npp_friend_"..tar:UniqueID(),NADMOD.Friends[tar:SteamID()] and "1" or "0", false, false)
		RunConsoleCommand("npp_friend_"..tar:UniqueID(),NADMOD.Friends[tar:SteamID()] and "1" or "0")
	end
end)

concommand.Add("npp_applyfriends",function(ply,cmd,args)
	for _,tar in pairs(player.GetAll()) do
		NADMOD.Friends[tar:SteamID()] = GetConVar("npp_friend_"..tar:UniqueID()):GetBool()
	end
	net.Start("nadmod_ppfriends")
		net.WriteTable(NADMOD.Friends)
	net.SendToServer()
end)

function NADMOD.ClientPanel(Panel)
	RunConsoleCommand("npp_refreshfriends")
	Panel:ClearControls()
	if !NADMOD.ClientCPanel then NADMOD.ClientCPanel = Panel end
	Panel:SetName(translate.Get("NADMOD_Client_Panel"))
	
	Panel:Button(translate.Get("NADMOD_Cleanup_Props"), "nadmod_cleanupprops")
	Panel:Button(translate.Get("NADMOD_Clear_Clientside_Ragdolls"), "nadmod_cleanclragdolls")
	
	local txt = Panel:Help(translate.Get("NADMOD_Friends_Panel"))
	txt:SetContentAlignment( TEXT_ALIGN_CENTER )
	txt:SetFont("DermaDefaultBold")
	txt:SetAutoStretchVertical(false)
	
	local Players = player.GetAll()
	if(table.Count(Players) == 1) then
		Panel:Help(translate.Get("NADMOD_No_Other_Players_Are_Online"))
	else
		for _, tar in pairs(Players) do
			if(IsValid(tar) and tar != LocalPlayer()) then
				Panel:CheckBox(tar:Nick(), "npp_friend_"..tar:UniqueID())
			end
		end
		Panel:Button(translate.Get("NADMOD_Apply_Friends"), "npp_applyfriends")
	end
end

function NADMOD.SpawnMenuOpen()
	if NADMOD.AdminCPanel then
		NADMOD.AdminPanel(NADMOD.AdminCPanel)
	end
	if NADMOD.ClientCPanel then
		NADMOD.ClientPanel(NADMOD.ClientCPanel)
	end
end
hook.Add("SpawnMenuOpen", "NADMOD.SpawnMenuOpen", NADMOD.SpawnMenuOpen)

function NADMOD.PopulateToolMenu()
	spawnmenu.AddToolMenuOption("Utilities", "NADMOD Prop Protection", "Admin", "Admin", "", "", NADMOD.AdminPanel)
	spawnmenu.AddToolMenuOption("Utilities", "NADMOD Prop Protection", "Client", "Client", "", "", NADMOD.ClientPanel)
end
hook.Add("PopulateToolMenu", "NADMOD.PopulateToolMenu", NADMOD.PopulateToolMenu)

net.Receive("nadmod_notify", function(len)
	local text = net.ReadString()
	GAMEMODE:AddNotify(text, NOTIFY_GENERIC, 5)
	surface.PlaySound("ambient/water/drip"..math.random(1, 4)..".wav")
	print(text)
end)