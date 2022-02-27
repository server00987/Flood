-------------------------
--Scoreboard by DANFMN--|
-------------------------

local PANEL = {}

function PANEL:Init()

end

function PANEL:SetPlayer(ply)
    local xPad, yPad = FLOOD_SCOREBOARD.Padding.x, FLOOD_SCOREBOARD.Padding.y
    self.ply = ply
	self.avatar = self:Add("AvatarImage")
	self.avatar:Dock(LEFT)
	self.avatar:SetPlayer(ply, 64)
    self.avatar:DockMargin(xPad-5, yPad-5, xPad-5, yPad-5)
    self.avatar.OnSizeChanged = function(me,w,h)
        me:SetWide(me:GetTall())
    end
    self.contentPanel = self:Add("DPanel")
    self.contentPanel:Dock(FILL)
    self.contentPanel:DockMargin(xPad, yPad, xPad, yPad)
    self.contentPanel.Paint = function(me,w,h)
        local xPad, yPad = FLOOD_SCOREBOARD.Padding.x, FLOOD_SCOREBOARD.Padding.y
        local xPos = 0
        surface.SetFont("FLOOD_Scoreboard_18")
        for i = 1, #FLOOD_SCOREBOARD.PlayerInformation do
            local infoData = FLOOD_SCOREBOARD.PlayerInformation[i]
            local text = infoData.title .. " " .. infoData.getText(self.ply)
            local textW = surface.GetTextSize(text)
            draw.SimpleText(text, "FLOOD_Scoreboard_18", xPos, h - 2, Color(255,250,250,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            xPos = xPos + textW + xPad * 5
        end
    end
end 

function PANEL:OnSizeChanged(w,h)

end

function PANEL:Paint(w,h)
    local theme = FLOOD_SCOREBOARD.Theme
    surface.SetDrawColor(theme.panel)
    surface.DrawRect(0,0,w,h)
    surface.SetDrawColor(color_white)
    surface.DrawRect(0, h - 2, w, 2)
    if self.ply and IsValid(self.ply) then
        if self.ply:IsSuperAdmin() then
            surface.SetDrawColor(204,0,0,255)
        elseif self.ply:IsAdmin() then
            surface.SetDrawColor(0,100,0,255)
        else
            surface.SetDrawColor(50,155,220,255)
        end
        surface.SetMaterial(theme.gradient)
        surface.DrawTexturedRect(0,0,w,h)
    end 
end

vgui.Register("ScoreboardPlayer", PANEL, "DPanel")