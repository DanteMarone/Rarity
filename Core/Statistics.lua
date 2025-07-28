local _, addonTable = ...

local Statistics = {}

--- Calculate an estimate for an item's drop chance while considering other group members that are also eligible
-- Only modifies chances for SHARED Loot, i.e. those that are set to use a groupSize > 1
-- Note: Virtually all items are now PERSONAL loot by default, which means this no longer applies to them
-- Caveat: Rarity has no idea how many group members were actually present, so it uses a predefined estimate (stored in the groupSize field), but this is also used to categorize items according to their difficulty (...). This is why there is another field, equalOdds, which will override the groupSize calculation to effectively force Personal Loot everywhere
-- @param item A table containing the data (itemDB entry) that is to be used
-- @return The modified drop chance after accounting for shared loot, given as a percentage
-- @return The modified drop chance after accounting for shared loot, given as a fraction (1 in X)
function Statistics.GetRealDropPercentage(item)
	local dropChance = (1.00 / (item.chance or 100))
	local realDropChance = dropChance -- Default: Personal Loot -> group members don't matter
	local fractionalDropChance = ((item.chance or 0) * (item.groupSize or 1))

	local itemUsesSharedLoot = (
		item.method == BOSS -- Only applies to
		and item.groupSize ~= nil
		and item.groupSize > 1 -- Item uses Shared Loot
		and not item.equalOdds
	) -- Not overwritten by the Personal Loot toggle
	if itemUsesSharedLoot then
		realDropChance = dropChance / item.groupSize
	end

	return realDropChance, fractionalDropChance
end

--- Aggregates the number of attempts for each item across all characters and updates the database
function Statistics.UpdateAccountWideStatistics()
	local a = Rarity.db.profile.accountWideStatistics
	if not a then
		Rarity.db.profile.accountWideStatistics = {}
		a = Rarity.db.profile.accountWideStatistics
	end

	-- Resets the collected data (it will be repopulated from all characters again, below)
	wipe(a)

	-- Now, iterate over all character profiles and collect the attempts
	if RarityDB and RarityDB.profiles then
		for charName, charData in pairs(RarityDB.profiles) do
			if type(charData) == "table" and charData.profile and type(charData.profile.groups) == "table" then
				-- Rarity:Print("Found character: " .. charName)
				for groupName, groupData in pairs(charData.profile.groups) do
					if type(groupData) == "table" then
						for itemName, itemData in pairs(groupData) do
							if
								type(itemData) == "table" and type(itemData.attempts) == "number" and itemData.attempts > 0
							then
								if not a[itemName] then
									a[itemName] = {}
								end
								a[itemName][charName] = itemData.attempts
							end
						end
					end
				end
			end
		end
	end
end

Rarity.Statistics = Statistics
return Statistics
