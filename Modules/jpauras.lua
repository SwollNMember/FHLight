--------------------------
-- LOCALIZATION
--------------------------

local L = MyLocalizationTable
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local GetSpellInfo = GetSpellInfo

--------------------------
-- BUFF DEBUFF
--------------------------
-- name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura("unit", index or "name"[, "rank"[, "filter"]])
-- name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("unit", index or ["name", "rank"][, "filter"])
-- name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("unit", index or ["name", "rank"][, "filter"])

--function jps.buffId(spellId,unit)
--	local spellname = nil
--	if type(spellId) == "number" then spellname = tostring(select(1,GetSpellInfo(spellId))) end
--	if unit == nil then unit = "player" end
--	for i = 1, 40 do
--		local auraName, _, _, count, _, duration, expirationTime, castBy, _, _, buffId = UnitBuff(unit, i)
--		if spellId == buffId and auraName == spellname then return true end
--		if not spellId then break end -- no more auras, terminate the loop 
--	end
--return false
--end

function jps.buffId(spellId,unit)
	local spellname = nil
	if type(spellId) == "number" then spellname = tostring(select(1,GetSpellInfo(spellId))) end
	if unit == nil then unit = "player" end
	local auraName, _, _, count, _, duration, expirationTime, castBy, _, _, buffId
	local i = 1
	auraName, _, _, count, _, duration, expirationTime, castBy, _, _, buffId = UnitBuff(unit, i)
	while auraName do
		if spellId == buffId and auraName == spellname then return true end
		i = i + 1
		auraName, _, _, count, _, duration, expirationTime, castBy, _, _, buffId = UnitBuff(unit, i)
	end
	return false
end

function jps.buff(spell,unit)
	local spellname = nil
	if type(spell) == "string" then spellname = spell end
	if type(spell) == "number" then spellname = tostring(select(1,GetSpellInfo(spell))) end
	if unit == nil then unit = "player" end
	if select(1,UnitBuff(unit,spellname)) then return true end
	return false
end

function jps.debuff(spell,unit)
	local spellname = nil
	if type(spell) == "string" then spellname = spell end
	if type(spell) == "number" then spellname = tostring(select(1,GetSpellInfo(spell))) end
	if unit == nil then unit = "target" end
	if select(1,UnitDebuff(unit,spellname)) then return true end
	return false
end

function jps.myDebuff(spell,unit)
	local spellname = nil
	if type(spell) == "string" then spellname = spell end
	if type(spell) == "number" then spellname = tostring(select(1,GetSpellInfo(spell))) end
	if unit == nil then unit = "target" end
	if select(1,UnitDebuff(unit,spellname)) and select(8,UnitDebuff(unit,spellname))=="player" then return true end
	return false
end

function jps.myBuffDuration(spell,unit)
	local spellname = nil
	if type(spell) == "string" then spellname = spell end
	if type(spell) == "number" then spellname = tostring(select(1,GetSpellInfo(spell))) end
	if unit == nil then unit = "player" end
	local _,_,_,_,_,_,duration,caster,_,_,_ = UnitBuff(unit,spellname)
	if caster ~= "player" then return 0 end
	if duration == nil then return 0 end
	duration = duration-GetTime() 
	if duration < 0 then return 0 end
	return duration
end

function jps.myDebuffDuration(spell,unit) 
	local spellname = nil
	if type(spell) == "string" then spellname = spell end
	if type(spell) == "number" then spellname = tostring(select(1,GetSpellInfo(spell))) end
	if unit == nil then unit = "target" end
	local _,_,_,_,_,_,duration,caster,_,_ = UnitDebuff(unit,spellname)
	if caster~="player" then return 0 end
	if duration==nil then return 0 end
	duration = duration-GetTime() 
	if duration < 0 then return 0 end
	return duration
end

function jps.buffDuration(spell,unit)
	local spellname = nil
	if type(spell) == "string" then spellname = spell end
	if type(spell) == "number" then spellname = tostring(select(1,GetSpellInfo(spell))) end
	if unit == nil then unit = "player" end
	local _,_,_,_,_,_,duration,caster,_,_,_ = UnitBuff(unit,spellname)
	if duration == nil then return 0 end
	duration = duration-GetTime() 
	if duration < 0 then return 0 end
	return duration
end

function jps.debuffDuration(spell,unit) 
	local spellname = nil
	if type(spell) == "string" then spellname = spell end
	if type(spell) == "number" then spellname = tostring(select(1,GetSpellInfo(spell))) end
	if unit == nil then unit = "target" end
	local _,_,_,_,_,_,duration,caster,_,_ = UnitDebuff(unit,spellname)
	if duration==nil then return 0 end
	duration = duration-GetTime() 
	if duration < 0 then return 0 end
	return duration
end

function jps.debuffStacks(spell,unit)
	local spellname = nil
	if type(spell) == "string" then spellname = spell end
	if type(spell) == "number" then spellname = tostring(select(1,GetSpellInfo(spell))) end
	if unit == nil then unit = "target" end
	local _,_,_,count, _,_,_,_,_,_ = UnitDebuff(unit,spellname)
	if count == nil then count = 0 end
	return count
end

function jps.buffStacks(spell,unit)
	local spellname = nil
	if type(spell) == "string" then spellname = spell end
	if type(spell) == "number" then spellname = tostring(select(1,GetSpellInfo(spell))) end
	if unit == nil then unit = "player" end
	local _, _, _, count, _, _, _, _, _ = UnitBuff(unit,spellname)
	if count == nil then count = 0 end
	return count
end

-- check if a unit has at least one buff from a buff table (first param)
function jps.buffLooper(tableName, unit)
	for _, buffName in pairs(tableName) do
		if jps.buff(buffName, unit) then
			return true
		end
	end
	return false
end

function jps.bloodlusting()
	return jps.buff("bloodlust") or jps.buff("heroism") or jps.buff("time warp") or jps.buff("ancient hysteria") or jps.buff("Drums of Rage") -- drums coming with 5.4
end

-- all raid buffs + types
local raidBuffs = {
	["Power Word: Fortitude"] = "stamina",
	["Commanding Shout"] = "stamina",
	["Qiraji Fortitude"] = "stamina",
	["Dark Intent"] = "stamina",
	["Mark of the Wild"] = "stats",
	["Legacy of the Emperor"] = "stats",
	["Blessing of Kings"] = "stats",
	["Embrace of the Shale Spider"] = "stats",
	["Horn of Winter"] = "attackPower",
	["Trueshot Aura"] = "attackPower",
	["Battle Shout"] = "attackPower",
	["Unholy Aura"] = "haste",
	["Swiftblade's Cunning"] = "haste",
	["Unleashed Rage"] = "haste",
	["Cackling Howl"] = "haste",
	["Serpent's Swiftness"] = "haste",
	["Moonkin Aura"] = "spellHaste",
	["Elemental Oath"] = "spellHaste",
	["Mind Quickening"] = "spellHaste",
	["Energizing Spores"] = "spellHaste",
	["Arcane Brilliance"] = "crit",
	["Dalaran Brilliance"] = "crit",
	["Leader of the Pack"] = "crit",
	["Legacy of the White Tiger"] = "crit",
	["Fearless Roar"] = "crit",
	["Still Water"] = "crit",
	["Terrifying Roar"] = "crit",
	["Furious Howl"] = "crit",
	["Arcane Brilliance"] = "spellPower",
	["Dalaran Brilliance"] = "spellPower",
	["Burning Wrath"] = "spellPower",
	["Dark Intent"] = "spellPower",
	["Still Water"] = "spellPower",
	["Blessing of Might"] = "mastery",
	["Grace of Air"] = "mastery",
	["Roar of Courage"] = "mastery",
	["Spirit Beast Blessing"] = "mastery"
}


-- functions for raid buffs
jps.staminaBuffs = {"Power Word: Fortitude", "Commanding Shout", "Qiraji Fortitude", "Dark Intent"}
function jps.hasStaminaBuff(unit)
	return jps.buffLooper(jps.staminaBuffs, unit)
end

jps.statsBuffs = {"Mark of the Wild", "Legacy of the Emperor", "Blessing of Kings", "Embrace of the Shale Spider"}
function jps.hasStatsBuff(unit)
	return jps.buffLooper(jps.statsBuffs, unit)
end

jps.attackPowerBuffs = {"Horn of Winter", "Trueshot Aura", "Battle Shout"}
function jps.hasAttackPowerBuff(unit)
	return jps.buffLooper(jps.attackPowerBuffs, unit)
end

jps.hasteBuffs = {"Unholy Aura", "Swiftblade's Cunning", "Unleashed Rage","Cackling Howl","Serpent's Swiftness"}
function jps.hasHasteBuff(unit)
	return jps.buffLooper(jps.hasteBuffs, unit)
end

jps.spellHasteBuffs = {"Moonkin Aura", "Elemental Oath", "Mind Quickening","Energizing Spores"}
function jps.hasSpellHasteBuff(unit)
	return jps.buffLooper(jps.spellHasteBuffs, unit)
end

jps.critBuffs = {"Arcane Brilliance", "Dalaran Brilliance", "Leader of the Pack","Legacy of the White Tiger","Fearless Roar","Still Water","Terrifying Roar","Furious Howl"}
function jps.hasCritBuff(unit)
	return jps.buffLooper(jps.critBuffs, unit)
end

jps.spellPowerBuffs = {"Arcane Brilliance", "Dalaran Brilliance", "Burning Wrath", "Dark Intent", "Still Water"}
function jps.hasSpellPowerBuff(unit)
	return jps.buffLooper(jps.spellPowerBuffs, unit)
end

jps.masteryBuffs = {"Blessing of Might","Grace of Air","Roar of Courage","Spirit Beast Blessing"}
function jps.hasMasteryBuff(unit)
	return jps.buffLooper(jps.masteryBuffs, unit)
end

function jps.hasSpellPowerCritBuff(unit)
	return jps.hasCritBuff(unit) and jps.hasSpellPowerBuff(unit)
end

-- type of raid buffs to functions
jps.raidBuffFunctions = { 
	["stamina"] = jps.hasStaminaBuff,
	["stats"] = jps.hasStatsBuff,
	["attackPower"] = jps.hasAttackPowerBuff,
	["haste"] = jps.hasHasteBuff,
	["spellHaste"] = jps.hasSpellHasteBuff,
	["crit"] = jps.hasCritBuff,
	["spellPower"] = jps.hasSpellPowerBuff,
	["mastery"] = jps.hasMasteryBuff
}

-- checks wheter a unit have a similarbuff ( e.G. arcane brilliance = still water)
function jps.hasSimilarBuff(buffName, unit)
	local buffType = Ternary(raidBuffs[buffname] ~= nil, raidBuffs[buffname], nil)
	if buffType ~= nil then
		if jps.raidBuffFunctions[buffType] ~= nil then
			return pcall(jps.raidBuffFunctions[buffType], unit)
		end
	end
	return false
end