--[[
    Author: Igromanru
    Date: 16.10.2024
    Mod Name: Instant Fishing
]]

------------------------------
-- Don't change code below --
------------------------------
ModName = "InfiniteLeyakContainment"
ModVersion = "1.0.0"
DebugMode = false
IsModEnabled = true

local function ModInfoAsPrefix()
    return "["..ModName.." v"..ModVersion.."] "
end

print(ModInfoAsPrefix().."Starting mod initialization")

local function IsContainmentCurrentlyActive(Context)
    local leyakContainment = Context:get() ---@type ADeployed_LeyakContainment_C

    if IsModEnabled and leyakContainment.ContainsLeyak then
        leyakContainment:ServerUpdateStabilityLevel(leyakContainment.MaxStability)
    end
end

local ClientRestartPreId, ClientRestartPostId = nil, nil
local HooksInitialized = false
local function InitModHooks()
    if not HooksInitialized then
        RegisterHook("/Game/Blueprints/DeployedObjects/Furniture/Deployed_LeyakContainment.Deployed_LeyakContainment_C:IsContainmentCurrentlyActive", IsContainmentCurrentlyActive)
        HooksInitialized = true
    end
    if ClientRestartPreId and ClientRestartPostId then
        UnregisterHook("/Script/Engine.PlayerController:ClientRestart", ClientRestartPreId, ClientRestartPostId)
    end
end

-- For hot reload
if DebugMode then
    InitModHooks()
end

ClientRestartPreId, ClientRestartPostId = RegisterHook("/Script/Engine.PlayerController:ClientRestart", function(Context, NewPawn)
    InitModHooks()
end)

print(ModInfoAsPrefix().."Mod loaded successfully")
