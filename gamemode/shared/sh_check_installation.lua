local function FLOOD_REQUIRED_ITEMS_INSTALLED()
    if file.Exists("weapons/arccw_bo1_asp.lua", "LUA") == true and file.Exists("autorun/arccw_autorun.lua", "LUA") == true and file.Exists("weapons/rust_syringe/shared.lua", "LUA") == true then return end

    if SERVER then
        print("===================Flood Installing Check====================")
        print("|=========The required items haven't been installed=========|")
        print("=============================================================")
    end

    if CLIENT then
        Derma_Query("The required items haven't been installed. Subscribe the required items.", "Flood Installing Check", "Goto Subscribe", function() gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2766690538") Flood_Default_Weapons = true end)
    end
end
hook.Add("InitPostEntity", "FLOOD_REQUIRED_ITEMS_INSTALLED", FLOOD_REQUIRED_ITEMS_INSTALLED)