local MetaPlayer = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")
local Donators = { "vip", "donator" }

function MetaPlayer:IsDonator()
	for _,v in pairs(Donators) do
		if self:IsUserGroup(v) then
			return true
		end
	end
	
	return false
end

-- Player Scores
function MetaPlayer:GetScore()
	return self:GetNWInt("flood_score") or 0
end

function MetaPlayer:SetScore(score)
	self:SetNWInt("flood_score", score)
end

-- Player Color
function EntityMeta:GetPlayerColor()
	return self:GetNWVector("playerColor") or Vector()
end

function EntityMeta:SetPlayerColor(vec)
	self:SetNWVector("playerColor", vec)
end

-- Can Respawn
function MetaPlayer:CanRespawn()
	return self:GetNWBool("flood_canrespawn")
end

function MetaPlayer:SetCanRespawn(bool)
	self:SetNWBool("flood_canrespawn", bool)
end

-- Currency 
function MetaPlayer:AddCash(amount)
	if amount then
		self:SetNetworkedInt("flood_cash", self:GetNetworkedInt("flood_cash") + tonumber(amount))
		self:Save()
	else
		print("Flood: "..translate.Get("Meta_ERROR"))
		return
	end
end

function MetaPlayer:SubCash(amount)
	if amount then 
		self:SetNetworkedInt("flood_cash", self:GetNetworkedInt("flood_cash") - tonumber(amount))
		self:Save()
	else
		print("Flood: "..translate.Get("Meta_ERROR2"))
		return
	end
end

function MetaPlayer:SetCash(amount)
	self:SetNetworkedInt("flood_cash", tonumber(amount))
end

function MetaPlayer:GetCash()
	return tonumber(self:GetNetworkedInt("flood_cash"))
end

function MetaPlayer:CanAfford(price)
	if tonumber(self:GetNetworkedInt("flood_cash")) >= tonumber(price) then
		return true
	else
		return false
	end
end

-- Save Data
function MetaPlayer:Save()
	if not file.IsDir("new_flood_data","DATA") then 
		file.CreateDir("new_flood_data")
	end

	if not self.Weapons then
		self.Weapons = { }
		table.insert(self.Weapons, "flood_arccw_waw_nambu")
		table.insert(self.Weapons, "weapon_crowbar")
	end

	local data = { 
		name =  string.gsub(self:Nick(), "\"", " ") or "bob",
		cash = self:GetNWInt("flood_cash"),
		weapons = string.Implode("|", self.Weapons)
	}
	
	file.Write("new_flood_data/"..self:UniqueID()..".txt", util.TableToKeyValues(data))
end