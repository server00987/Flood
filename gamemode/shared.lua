DeriveGamemode("sandbox")

GM.Name 	= "Flood"
GM.Author 	= "Mythikos, Freezebug & Pathfinder_FUFU"
GM.Version  = "1.0.0"
GM.Email 	= "n/a"
GM.Website 	= "n/a"

Flood_Version = "Beta 1.1.7"

-- Include Shared files
for _, file in pairs (file.Find("flood/gamemode/shared/*.lua", "LUA")) do
   include("flood/gamemode/shared/"..file); 
end

TEAM_PLAYER = 2

team.SetUp(TEAM_PLAYER, "Player", Color(16, 153, 156))

-- Format coloring because garry likes vectors for playermodels
function GM:FormatColor(col)
	col = Color(col.r * 255, col.g * 255, col.b * 255)
	return col
end