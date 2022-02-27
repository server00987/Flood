local PANEL = {}
function PANEL:Init()
	self.FloodWeaponIconList = {}
	self.FloodWeaponIconList_Collapse = {}

	self.TabList = vgui.Create("DPanelList", self)
	self.TabList:Dock(FILL)
	self.TabList:EnableVerticalScrollbar(true)

	if Flood_Default_Weapons == true then
	    if Flood_Default_WeaponCategories then
		    for k,v in pairs (Flood_Default_WeaponCategories) do
			    self.FloodWeaponIconList[k] = vgui.Create("DPanelList", self)
				self.FloodWeaponIconList[k]:SetAutoSize(true) 
				self.FloodWeaponIconList[k]:EnableHorizontal(true) 
				self.FloodWeaponIconList[k]:SetPadding(4) 
				self.FloodWeaponIconList[k]:SetVisible(true) 
				self.FloodWeaponIconList[k].OnMouseWheeled = nil
			
				self.FloodWeaponIconList_Collapse[k] = vgui.Create("DCollapsibleCategory", self)
				self.FloodWeaponIconList_Collapse[k]:SizeToContents()
				self.FloodWeaponIconList_Collapse[k]:SetLabel(v) 
				self.FloodWeaponIconList_Collapse[k]:SetVisible(true) 
				self.FloodWeaponIconList_Collapse[k]:SetContents(self.FloodWeaponIconList[k])
				self.FloodWeaponIconList_Collapse[k].Paint = function(self, w, h) 
					draw.RoundedBox(0, 0, 1, w, h, Color(255, 250, 250, 255)) 
					draw.RoundedBox(0, 0, 0, w, self.Header:GetTall(), Color(50, 155, 220, 255)) 
				end

				self.TabList:AddItem(self.FloodWeaponIconList_Collapse[k])
			end
		else
			LocalPlayer():ChatPrint(translate.Get("SHOP_ERROR4"))
		end

	    if Default_Weapons then
		    for k, v in pairs(Default_Weapons) do	
			    local ItemIcon = vgui.Create("SpawnIcon", self)
			    ItemIcon:SetModel(v.Model)
			    ItemIcon:SetSize(55,55)
			    ItemIcon.DoClick = function() 
				    RunConsoleCommand("FloodPurchaseWeapon", k)
				    surface.PlaySound("ui/buttonclick.wav")		
			    end

			    if v.Name and v.Price and v.Damage and v.Ammo then ItemIcon:SetToolTip(Format("%s", translate.Get("HUD_Name")..v.Name..translate.Get("SHOP_Price")..v.Price..translate.Get("SHOP_Damage")..v.Damage..translate.Get("SHOP_Ammo")..v.Ammo)) 
			    else ItemIcon:SetToolTip(Format("%s", translate.Get("SHOP_ERROR5"))) end

			    if v.Group then	self.FloodWeaponIconList[v.Group]:AddItem(ItemIcon) end
			    ItemIcon:InvalidateLayout(true) 
		    end
	    else
		    LocalPlayer():ChatPrint(translate.Get("SHOP_ERROR6"))
	    end
	else
	    if Flood_WeaponCategories then
		    for k,v in pairs (Flood_WeaponCategories) do
			    self.FloodWeaponIconList[k] = vgui.Create("DPanelList", self)
				self.FloodWeaponIconList[k]:SetAutoSize(true) 
				self.FloodWeaponIconList[k]:EnableHorizontal(true) 
				self.FloodWeaponIconList[k]:SetPadding(4) 
				self.FloodWeaponIconList[k]:SetVisible(true) 
				self.FloodWeaponIconList[k].OnMouseWheeled = nil
			
				self.FloodWeaponIconList_Collapse[k] = vgui.Create("DCollapsibleCategory", self)
				self.FloodWeaponIconList_Collapse[k]:SizeToContents()
				self.FloodWeaponIconList_Collapse[k]:SetLabel(v) 
				self.FloodWeaponIconList_Collapse[k]:SetVisible(true) 
				self.FloodWeaponIconList_Collapse[k]:SetContents(self.FloodWeaponIconList[k])
				self.FloodWeaponIconList_Collapse[k].Paint = function(self, w, h) 
					draw.RoundedBox(0, 0, 1, w, h, Color(255, 250, 250, 255)) 
					draw.RoundedBox(0, 0, 0, w, self.Header:GetTall(), Color(50, 155, 220, 255)) 
				end

				self.TabList:AddItem(self.FloodWeaponIconList_Collapse[k])
			end
		else
			LocalPlayer():ChatPrint(translate.Get("SHOP_ERROR4"))
		end

	    if Flood_Weapons then
		    for k, v in pairs(Flood_Weapons) do	
			    local ItemIcon = vgui.Create("SpawnIcon", self)
			    ItemIcon:SetModel(v.Model)
			    ItemIcon:SetSize(55,55)
			    ItemIcon.DoClick = function() 
				    RunConsoleCommand("FloodPurchaseWeapon", k)
				    surface.PlaySound("ui/buttonclick.wav")		
			    end

			    if v.Name and v.Price and v.Damage and v.Ammo then ItemIcon:SetToolTip(Format("%s", translate.Get("HUD_Name")..v.Name..translate.Get("SHOP_Price")..v.Price..translate.Get("SHOP_Damage")..v.Damage..translate.Get("SHOP_Ammo")..v.Ammo)) 
			    else ItemIcon:SetToolTip(Format("%s", translate.Get("SHOP_ERROR5"))) end

			    if v.Group then	self.FloodWeaponIconList[v.Group]:AddItem(ItemIcon) end
			    ItemIcon:InvalidateLayout(true) 
		    end
	    else
		    LocalPlayer():ChatPrint(translate.Get("SHOP_ERROR6"))
	    end
    end
end
vgui.Register("Flood_ShopMenu_Weapons", PANEL)