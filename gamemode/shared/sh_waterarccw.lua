----------------------------------------------
--Thanks to Nano_Rex ◥◣ム◢◤ for their help--|
----------------------------------------------

local ConVar = GetConVar("flood_arccw_shootunderwater"):GetFloat()

-- timer needed because weplist is loaded after the gamemod is loaded

timer.Simple(0.1,function()
	if Flood_Weapons then
		for k,tbl in pairs(Flood_Weapons) do
			local wep = weapons.GetStored(tbl.Class)
			if not wep then continue end
			if not string.find(wep.Base,"arccw") then continue end
			if ConVar >= 1 then 
				wep.CanFireUnderwater = 1
			end
		end
	end
end)