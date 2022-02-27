-------------------------
--Scoreboard by DANFMN--|
-------------------------

local PANEL = {}

function PANEL:Init()
    self:SetDraggable(false)
    self:SetTitle("")
    self:DockPadding(0,0,0,0)
    self:ShowCloseButton(false)
    self:CreateTitle()
    self:CreateBody()
    self:PopulatePlayers()
end

function PANEL:CreateTitle()
    self.titleBar = self:Add("DPanel")
    self.titleBar:Dock(TOP)
    self.titleBar.Paint = function(me,w,h)
        draw.SimpleTextOutlined(GetGlobalString("ServerName"), "FLOOD_Scoreboard_36", w * .02, h * .5, Color(255,250,250,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(50,155,220,255))
        draw.SimpleTextOutlined(translate.Get("Scoreboard_Players")..player.GetCount().."/"..game.MaxPlayers(), "FLOOD_Scoreboard_24", w * .85, h * .6, Color(255,250,250,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1, Color(50,155,220,255))
    end
end 

function PANEL:CreateBody()
    self.scroll = self:Add("DScrollPanel")
    self.scroll:Dock(FILL)
    local yPad = FLOOD_SCOREBOARD.Padding.y
    self.scroll:DockMargin(0,0,0,yPad)
    local theme = FLOOD_SCOREBOARD.Theme
    local barClr = theme.panel
    local bar = self.scroll:GetVBar()

    local buttH = 0
    function bar.btnUp:Paint(w, h)
        buttH = h
    end

    function bar:Paint( w, h )
        draw.RoundedBox(8, w / 2 - w / 2, buttH, w / 2, h - buttH * 2, barClr)
    end

    function bar.btnDown:Paint(w, h)

    end
    function bar.btnGrip:Paint(w, h)
        draw.RoundedBox(8, w / 2 - w / 2, 0, w / 2, h , theme.theme)
    end

end


function PANEL:PopulatePlayers()
    self.playerPanels = {}
    local sortedPlayers = player.GetAll()
    table.sort(sortedPlayers, function(a,b)
        return a:Team() > b:Team()
    end)
    local xPad, yPad = FLOOD_SCOREBOARD.Padding.x, FLOOD_SCOREBOARD.Padding.y
    for k,ply in pairs(sortedPlayers) do
        local playerPanel = self.scroll:Add("ScoreboardPlayer")
        playerPanel:Dock(TOP)
        playerPanel:SetPlayer(ply)
        playerPanel:DockMargin(xPad, yPad, xPad, 0)
        self.playerPanels[playerPanel] = true
    end

end

function PANEL:OnSizeChanged(w,h)
    if self.titleBar then
        self.titleBar:SetTall(h * .1)
    end 
    if self.subTitle then
        self.subTitle:SetTall(h * .025)
    end 
    if self.playerPanels then
        for panel,v in pairs(self.playerPanels) do
            if not IsValid(panel) then
                self.playerPanels[panel] = nil
            end
            panel:SetTall(h * .05)
        end
    end 
    if self.subTitleLabels then
        for label,v in pairs(self.subTitleLabels) do
            label:SetWide(w / table.Count(self.subTitleLabels))
        end
    end 
end

local blur = Material("pp/blurscreen")
function PANEL:BlurMenu(layers, density, alpha)
    -- Its a scientifically proven fact that blur improves a script
    local x, y = self:LocalToScreen(0, 0)

    surface.SetDrawColor(0,0,0,0)
    surface.SetMaterial(blur)

    for i = 1, 5 do
        blur:SetFloat("$blur", (i / 4) * 4)
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
    end
end

function PANEL:Paint(w,h)
    local theme = FLOOD_SCOREBOARD.Theme
    self:BlurMenu(16,16,255)
    surface.SetDrawColor(0,0,0,0)
    surface.DrawRect(0,0,w,h)
end

vgui.Register("ScoreboardFrame", PANEL, "DFrame")