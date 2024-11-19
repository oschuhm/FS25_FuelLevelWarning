--
-- FuelLevel Warning for LS 25
--
-- # Author:  	LS-Farmers.de
-- # date: 		19.11.2024
--

fuelLevelWarning = {}
fuelLevelWarning.MOD_NAME = g_currentModName

FuelBeepSound5 = createSample("FuelBeepSound5")
local file = g_currentModDirectory.."sounds/FuelBeepSound5.wav"
loadSample(FuelBeepSound5, file, false)

function fuelLevelWarning.prerequisitesPresent(specializations)
  return true
end

function fuelLevelWarning.registerEventListeners(vehicleType)
  SpecializationUtil.registerEventListener(vehicleType, "onUpdate", fuelLevelWarning)
  SpecializationUtil.registerEventListener(vehicleType, "onLoad", fuelLevelWarning)
end

function fuelLevelWarning:onLoad(savegame)
	self.beepFuelActive = false
	self.fuelwarnvolume = 1
	self.lastPercentageWarned = 0
	
	self.fuelFillTypeDiesel = self:getConsumerFillUnitIndex(FillType.DIESEL)
	self.fuelFillTypeElectricCharge = self:getConsumerFillUnitIndex(FillType.ELECTRICCHARGE)
	self.fuelFillTypeMethane = self:getConsumerFillUnitIndex(FillType.METHANE)
	
	if self.fuelFillTypeDiesel ~= nil then
		self.fuelFillType = self.fuelFillTypeDiesel
	elseif self.fuelFillTypeElectricCharge ~= nil then
		self.fuelFillType = self.fuelFillTypeElectricCharge
	elseif self.fuelFillTypeMethane ~= nil then
		self.fuelFillType = self.fuelFillTypeMethane
	else
		self.fuelFillType = nil
	end
	
end

function fuelLevelWarning:onUpdate(dt)
	if self:getIsActive() and self:getIsEntered() and self:getIsMotorStarted() ~= false then

        local fuelFillType = self.fuelFillType

		if fuelFillType ~= nil then 
			local fillLevel = self:getFillUnitFillLevel(fuelFillType)
			local capacity = self:getFillUnitCapacity(fuelFillType)
			local fuelLevelPercentage = fillLevel / capacity * 100
			local warnFrequency = 0
			
			 --print ("DEBUG: Actual Fuel Level: " .. fillLevel)
			 --print ("DEBUG: Actual Fuel Capacity: " .. capacity)
			 --print ("DEBUG: Actual Fuel Level Percentage: " .. fuelLevelPercentage)
			 --print ("DEBUG: dt: " .. dt)
			 --print ("DEBUG: beepFuelActive: " .. tostring(self.beepFuelActive))
			 
			self.currentFuelPercentage = math.floor(fuelLevelPercentage+0.5)
			
			if self.currentFuelPercentage ~= self.lastPercentageWarned and self.beepFuelActive then
					--print ("DEBUG: Deactivate 5sec BEEP - Percentage Changed - Revalidate")
					--print ("DEBUG: self.currentFuelPercentage: "..self.currentFuelPercentage)
					--print ("DEBUG: self.lastPercentageWarned: "..self.lastPercentageWarned)
					stopSample(FuelBeepSound5,0,0)
					self.beepFuelActive = false
			end			
			 
			if fuelLevelPercentage <= 5 then
				if self.beepFuelActive == false then
				  --print ("DEBUG: Activate 5sec BEEP - Permanent Loop")
				  playSample(FuelBeepSound5 ,0,self.fuelwarnvolume ,1 ,0 ,0)
				  self.lastPercentageWarned = math.floor(fuelLevelPercentage+0.5)
				  self.beepFuelActive = true
				end
			elseif fuelLevelPercentage <= 15 then
				if self.beepFuelActive == false then
				  --print ("DEBUG: Activate 5sec BEEP - Play Twice")
				  playSample(FuelBeepSound5 ,2,self.fuelwarnvolume ,1 ,0 ,0)
				  self.lastPercentageWarned = math.floor(fuelLevelPercentage+0.5)
				  self.beepFuelActive = true
				end
			elseif fuelLevelPercentage <= 20 then
				if self.beepFuelActive == false then
				  --print ("DEBUG: Activate 5sec BEEP - Play Once")
				  playSample(FuelBeepSound5 ,1,self.fuelwarnvolume ,1 ,0 ,0)
				  self.lastPercentageWarned = math.floor(fuelLevelPercentage+0.5)
				  self.beepFuelActive = true
				end
			else
				if self.beepFuelActive == true then
					--print ("DEBUG: Deactivate 5sec BEEP")
					stopSample(FuelBeepSound5,0,0)
					self.beepFuelActive = false
				end
			end
		end
	else
		if self.beepFuelActive == true then
			--print ("DEBUG: Deactivate 5sec BEEP - no active vehicle")
			stopSample(FuelBeepSound5,0,0)
			self.beepFuelActive = false
		end
	end
end

