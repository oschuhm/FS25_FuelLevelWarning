--
-- register
--
-- # Author: LS-Farmers.de 
-- # date: 19.11.2024
--

if g_specializationManager:getSpecializationByName('fuelLevelWarning') == nil then
    g_specializationManager:addSpecialization('fuelLevelWarning', 'fuelLevelWarning', Utils.getFilename('fuelLevelWarning.lua', g_currentModDirectory), nil)
end

for vehicleTypeName, vehicleType in pairs(g_vehicleTypeManager.types) do 
    if vehicleType ~= nil and SpecializationUtil.hasSpecialization(Drivable, vehicleType.specializations) and not SpecializationUtil.hasSpecialization(Locomotive, vehicleType.specializations) then
        g_vehicleTypeManager:addSpecialization(vehicleTypeName, 'fuelLevelWarning')
		print ("  added fuelLevelWarning to " .. vehicleTypeName)
	else
		print ("  skipped fuelLevelWarning for " .. vehicleTypeName)
    end
end