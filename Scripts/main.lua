--[[
    Author: Igromanru
    Date: 16.10.2024
    Mod Name: Infinite Leyak Containment
]]

------------------------------
-- Don't change code below --
------------------------------
ModName = "InfiniteLeyakContainment"
ModVersion = "1.0.3"
DebugMode = false
IsModEnabled = true

local function ModInfoAsPrefix()
    return "["..ModName.." v"..ModVersion.."] "
end

print(ModInfoAsPrefix().."Starting mod initialization\n")

local function IsContainmentCurrentlyActive(Context)
    local leyakContainment = Context:get() ---@type ADeployed_LeyakContainment_C

    if IsModEnabled and leyakContainment.ContainsLeyak then
        local stability = leyakContainment['Stability Level']
        local maxStability = leyakContainment.MaxStability
        local difference =  maxStability - stability
        if DebugMode then
            print(ModInfoAsPrefix().."[IsContainmentCurrentlyActive]:\n")
            print(ModInfoAsPrefix().."Stability Level: "..stability..'\n')
            print(ModInfoAsPrefix().."MaxStability: "..maxStability..'\n')
        end
        if difference > 0 then
            -- leyakContainment['Stability Level'] = leyakContainment.MaxStability
            -- leyakContainment['OnRep_Stability Level']()
            leyakContainment:ServerUpdateStabilityLevel(difference)
        end
        if DebugMode then
            print(ModInfoAsPrefix().."New Stability Level: "..leyakContainment['Stability Level']..'\n')
        end
    end

    return leyakContainment.ContainsLeyak == true
end

RegisterHook("/Game/Blueprints/DeployedObjects/Furniture/Deployed_LeyakContainment.Deployed_LeyakContainment_C:IsContainmentCurrentlyActive", IsContainmentCurrentlyActive)

print(ModInfoAsPrefix().."Mod loaded successfully\n")
