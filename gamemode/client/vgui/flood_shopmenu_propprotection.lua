local PANEL = {}
function PANEL:Init()
	self.TabList = vgui.Create("DPanelList", self)
	self.TabList:Dock(FILL)
	self.TabList:EnableVerticalScrollbar(true)

	self:Update()
end

function PANEL:ClientPanel()
	local cp = vgui.Create("ControlPanel")
	cp:SetName(translate.Get("SHOP_Client_settings"))
	cp:FillViaFunction(NADMOD.ClientPanel)
	cp.Paint = function(self, w, h) 
		draw.RoundedBox(0, 0, 1, w, h, Color(255, 250, 250, 255)) 
		draw.RoundedBox(0, 0, 0, w, self.Header:GetTall(), Color(50, 155, 220, 255))
	end
	self.TabList:AddItem(cp)
end

function PANEL:AdminPanel()
	local cp = vgui.Create("ControlPanel")
	cp:SetName(translate.Get("SHOP_Admin_settings"))
	cp:FillViaFunction(NADMOD.AdminPanel)
	cp:SetDrawBackground(true)
	cp.Paint = function(self,w,h) 
		draw.RoundedBox(0, 0, 1, w, h, Color(255, 250, 250, 255)) 
		draw.RoundedBox(0, 0, 0, w, self.Header:GetTall(), Color(50, 155, 220, 255))
	end	
	self.TabList:AddItem(cp)
end

function PANEL:Update()
	if(NADMOD.ClientCPanel) then
		NADMOD.ClientPanel(NADMOD.ClientCPanel)
	else
		self:ClientPanel()
	end
	if(NADMOD.AdminCPanel) then
		if LocalPlayer():IsAdmin() then
			NADMOD.AdminPanel(NADMOD.AdminCPanel)
		else
			NADMOD.AdminCPanel:Remove()
			NADMOD.AdminCPanel = nil
		end
	elseif LocalPlayer():IsAdmin() then
		self:AdminPanel()
	end

	timer.Simple(15, function() self:Update() end)
end
vgui.Register("Flood_ShopMenu_PropProtection", PANEL)