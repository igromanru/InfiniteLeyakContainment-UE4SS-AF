--[[
    Author: Igromanru
    Date: 16.10.2024
    Mod Name: Infinite Leyak Containment
]]

------------------------------
-- Don't change code below --
------------------------------
ModName = "InfiniteLeyakContainment"
ModVersion = "1.1.2"
DebugMode = true
IsModEnabled = true

local UEHelpers = require("UEHelpers")

local function ModInfoAsPrefix()
    return "["..ModName.." v"..ModVersion.."] "
end

local FoodGreyeb = UEHelpers.FindFName("food_greyeb")

print(ModInfoAsPrefix().."Starting mod initialization\n")

---@param LeyakContainment ADeployed_LeyakContainment_C
local function CheckAndFixActiveLeyakContainmentID(LeyakContainment)
    if not LeyakContainment or not LeyakContainment:IsValid() then return end

    local gameState = UEHelpers.GetGameStateBase() ---@cast gameState AAbiotic_Survival_GameState_C
    if gameState:IsValid() and gameState.ActiveLeyakContainmentID then
        local leyakContainmentID = LeyakContainment.SpawnedAssetID:ToString()
        local activeLeyakContainmentID = gameState.ActiveLeyakContainmentID:ToString()
        if LeyakContainment.ContainsLeyak == true and activeLeyakContainmentID == "" then
            gameState['Set Leyak Containment ID'](leyakContainmentID)
        elseif activeLeyakContainmentID == leyakContainmentID and not LeyakContainment.ContainsLeyak then
            LeyakContainment:TrapLeyak(0.5)
        end
    end
end

local function NewDayUpdate(Context)
    local leyakContainment = Context:get() ---@type ADeployed_LeyakContainment_C

    CheckAndFixActiveLeyakContainmentID(leyakContainment)
    if IsModEnabled and leyakContainment.ContainsLeyak then
        local stability = leyakContainment['Stability Level']
        local maxStability = leyakContainment.MaxStability
        local difference =  maxStability - stability
        if DebugMode then
            print(ModInfoAsPrefix().."[IsContainmentCurrentlyActive]:\n")
            print(ModInfoAsPrefix().."Stability Level: "..stability..'\n')
            print(ModInfoAsPrefix().."MaxStability: "..maxStability..'\n')
            print(ModInfoAsPrefix().."Difference: "..difference..'\n')
        end
        if difference > 0 then
            -- leyakContainment['Stability Level'] = leyakContainment.MaxStability
            -- leyakContainment['OnRep_Stability Level']()
            leyakContainment:ServerUpdateStabilityLevel(difference, FoodGreyeb)
        end
        if DebugMode then
            print(ModInfoAsPrefix().."New Stability Level: "..leyakContainment['Stability Level']..'\n')
        end
    end
end

ExecuteInGameThread(function()
    print(ModInfoAsPrefix().."Initializing hooks\n")
    LoadAsset("/Game/Blueprints/DeployedObjects/Furniture/Deployed_LeyakContainment.Deployed_LeyakContainment_C")
    RegisterHook("/Game/Blueprints/DeployedObjects/Furniture/Deployed_LeyakContainment.Deployed_LeyakContainment_C:NewDayUpdate", NewDayUpdate)
    print(ModInfoAsPrefix().."Hooks initialized\n")
end)

print(ModInfoAsPrefix().."Mod loaded successfully\n")
