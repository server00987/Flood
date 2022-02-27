-------------------------
--Scoreboard by DANFMN--|
-------------------------

FLOOD_SCOREBOARD = {
    Ranks = {
        ["user"] = translate.Get("Scoreboard_User"),
        ["admin"] = translate.Get("Scoreboard_Admin"),
        ["superadmin"] = translate.Get("Scoreboard_SuperAdmin"),
        ["founder"] = translate.Get("Scoreboard_Founder"),
        ["owner"] = translate.Get("Scoreboard_Owner"),
        ["vip"] = translate.Get("Scoreboard_VIP"),
        ["donator"] = translate.Get("Scoreboard_Donator"),
    },
    Theme = {
        frame = Color(0,0,0,200),
        panel = Color(40,60,80,200),
        theme = Color(50,155,220),
        gradient = Material("materials/hud_icon/grad.png"),
    },
    Padding = {
        x = ScrW() * .005,
        y = ScrH() * .01
    },
    PlayerInformation = {
        {title = translate.Get("Scoreboard_Name"), getText = function(ply) return ply:Name() end},
        {title = translate.Get("Scoreboard_Rank"), getText = function(ply) local rank = ply:GetUserGroup() rank = FLOOD_SCOREBOARD.Ranks[rank] or rank return rank end},
        {title = translate.Get("Scoreboard_Cash"), getText = function(ply) return ply:GetNWInt("flood_cash") end},
        {title = translate.Get("Scoreboard_Deaths"), getText = function(ply) return ply:Deaths() end},
        {title = translate.Get("Scoreboard_Ping"), getText = function(ply) return ply:Ping() end},
    },
}

local fontSizes = {
    18,
    24,
    36,
}

for i = 1, #fontSizes do
    local size = fontSizes[i]
    surface.CreateFont("FLOOD_Scoreboard_" .. size,{
        font = "Roboto",
        extended = false,
        size = size,
        weight = 500,
    })
    
end

function FLOOD_SCOREBOARD.Open()

    local scrw, scrh = ScrW(), ScrH()
    if IsValid(FLOOD_SCOREBOARD.Menu) then 
        FLOOD_SCOREBOARD.Menu:Remove()
    end
    FLOOD_SCOREBOARD.Menu = vgui.Create("ScoreboardFrame")
    FLOOD_SCOREBOARD.Menu:SetSize(scrw * .6, scrh * .8)
    FLOOD_SCOREBOARD.Menu:Center()
    FLOOD_SCOREBOARD.Menu:MakePopup()
    FLOOD_SCOREBOARD.Menu:Show()
end

function FLOOD_SCOREBOARD.Hide()
    if not IsValid(FLOOD_SCOREBOARD.Menu) then return end
    FLOOD_SCOREBOARD.Menu:Hide()
end
--SCOREBOARD.BlurMenu( me, 16, 16, 255 )

hook.Add("ScoreboardShow", "FLOODScoreboard_Open", function()
    FLOOD_SCOREBOARD.Open()
    return true
end)

hook.Add("ScoreboardHide", "FLOODScoreboard_Close", function()
    FLOOD_SCOREBOARD.Hide()
    return true
end)