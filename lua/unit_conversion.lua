--[[
  Copyright (C) 2026 hidenorly

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]

local M = {}

local function check(v, name)
    if v ~= v or v == math.huge or v == -math.huge then error(name .. " must be finite") end
    return v
end

local function create_class(name)
    local cls = {__type = name}
    cls.__index = cls
    return cls
end

-- Speed
M.Speed = create_class("Speed")
function M.Speed.fromMs(v) return setmetatable({val = check(v, "Speed")}, M.Speed) end
function M.Speed.fromKmH(v) return M.Speed.fromMs(v / 3.6) end
function M.Speed.fromMph(v) return M.Speed.fromMs(v * 0.44704) end
function M.Speed:toMs() return self.val end
function M.Speed:toKmH() return self.val * 3.6 end
function M.Speed:toMph() return self.val / 0.44704 end

-- Temperature
M.Temperature = create_class("Temperature")
function M.Temperature.fromCelsius(v) if v < -273.15 then error("Low") end return setmetatable({val = check(v, "T")}, M.Temperature) end
function M.Temperature.fromFahrenheit(v) return M.Temperature.fromCelsius((v - 32.0) / 1.8) end
function M.Temperature.fromKelvin(v) return M.Temperature.fromCelsius(v - 273.15) end
function M.Temperature:toCelsius() return self.val end
function M.Temperature:toFahrenheit() return self.val * 1.8 + 32.0 end
function M.Temperature:toKelvin() return self.val + 273.15 end

-- Mass
M.Mass = create_class("Mass")
function M.Mass.fromKg(v) return setmetatable({val = v}, M.Mass) end
function M.Mass.fromGram(v) return M.Mass.fromKg(v * 0.001) end
function M.Mass.fromLb(v) return M.Mass.fromKg(v * 0.45359237) end
function M.Mass.fromOz(v) return M.Mass.fromKg(v * 0.0283495231) end
function M.Mass:toKg() return self.val end
function M.Mass:toGram() return self.val / 0.001 end
function M.Mass:toLb() return self.val / 0.45359237 end
function M.Mass:toOz() return self.val / 0.0283495231 end


-- Distance
M.Distance = create_class("Distance")
function M.Distance.fromMeters(v) return setmetatable({val = check(v, "D")}, M.Distance) end
function M.Distance.fromKm(v) return M.Distance.fromMeters(v * 1000.0) end
function M.Distance.fromMile(v) return M.Distance.fromMeters(v * 1609.344) end
function M.Distance.fromFeet(v) return M.Distance.fromMeters(v * 0.3048) end
function M.Distance.fromInch(v) return M.Distance.fromMeters(v * 0.0254) end
function M.Distance.fromMm(v) return M.Distance.fromMeters(v * 0.001) end
function M.Distance:toMeters() return self.val end
function M.Distance:toKm() return self.val / 1000.0 end
function M.Distance:toMile() return self.val / 1609.344 end
function M.Distance:toFeet() return self.val / 0.3048 end
function M.Distance:toInch() return self.val / 0.0254 end
function M.Distance:toMm() return self.val / 0.001 end

-- Pressure
M.Pressure = create_class("Pressure")
function M.Pressure.fromKpa(v) return setmetatable({val = v}, M.Pressure) end
function M.Pressure.fromBar(v) return M.Pressure.fromKpa(v * 100.0) end
function M.Pressure.fromPsi(v) return M.Pressure.fromKpa(v * 6.89476) end
function M.Pressure:toKpa() return self.val end
function M.Pressure:toBar() return self.val / 100.0 end
function M.Pressure:toPsi() return self.val / 6.89476 end

-- Power
M.Power = create_class("Power")
function M.Power.fromKw(v) return setmetatable({val = check(v, "P")}, M.Power) end
function M.Power.fromPs(v) return M.Power.fromKw(v * 0.73549875) end
function M.Power.fromHp(v) return M.Power.fromKw(v * 0.74569987) end
function M.Power:toKw() return self.val end
function M.Power:toPs() return self.val / 0.73549875 end
function M.Power:toHp() return self.val / 0.74569987 end

-- Torque
M.Torque = create_class("Torque")
function M.Torque.fromNm(v) return setmetatable({val = check(v, "Tq")}, M.Torque) end
function M.Torque.fromKgfm(v) return M.Torque.fromNm(v * 9.80665) end
function M.Torque.fromLbft(v) return M.Torque.fromNm(v * 1.355817948) end
function M.Torque:toNm() return self.val end
function M.Torque:toKgfm() return self.val / 9.80665 end
function M.Torque:toLbft() return self.val / 1.355817948 end

-- Angle
M.Angle = create_class("Angle")
function M.Angle.fromRadians(v) return setmetatable({val = v}, M.Angle) end
function M.Angle.fromDegrees(v) return M.Angle.fromRadians(v * (math.pi / 180.0)) end
function M.Angle:toRadians() return self.val end
function M.Angle:toDegrees() return self.val / (math.pi / 180.0) end

-- Efficiency
M.Efficiency = create_class("Efficiency")
function M.Efficiency.fromKml(v) if v <= 0 then error("Positive") end return setmetatable({val = v}, M.Efficiency) end
function M.Efficiency.fromL100km(v) return M.Efficiency.fromKml(100.0 / v) end
function M.Efficiency.fromMpg(v) return M.Efficiency.fromKml(v * 0.425143707) end
function M.Efficiency:toKml() return self.val end
function M.Efficiency:toL100km() return 100.0 / self.val end
function M.Efficiency:toMpg() return self.val / 0.425143707 end

-- EvEfficiency
M.EvEfficiency = create_class("EvEfficiency")
function M.EvEfficiency.fromKmkWh(v) if v <= 0 then error("Positive") end return setmetatable({val = v}, M.EvEfficiency) end
function M.EvEfficiency.fromWhkm(v) return M.EvEfficiency.fromKmkWh(1000.0 / v) end
function M.EvEfficiency.fromKwh100km(v) return M.EvEfficiency.fromKmkWh(100.0 / v) end
function M.EvEfficiency.fromMpKwh(v) return M.EvEfficiency.fromKmkWh(v * 1.609344) end
function M.EvEfficiency:toKmkWh() return self.val end
function M.EvEfficiency:toWhkm() return 1000.0 / self.val end
function M.EvEfficiency:toKwh100km() return 100.0 / self.val end
function M.EvEfficiency:toMpKwh() return self.val / 1.609344 end

-- Volume
M.Volume = create_class("Volume")
function M.Volume.fromLiters(v) return setmetatable({val = v}, M.Volume) end
function M.Volume.fromMl(v) return M.Volume.fromLiters(v / 1000.0) end
function M.Volume.fromUsGallons(v) return M.Volume.fromLiters(v * 3.785411784) end
function M.Volume.fromImpGallons(v) return M.Volume.fromLiters(v * 4.54609) end
function M.Volume:toLiters() return self.val end
function M.Volume:toMl() return self.val * 1000.0 end
function M.Volume:toUsGallons() return self.val / 3.785411784 end
function M.Volume:toImpGallons() return self.val / 4.54609 end

-- Time
M.Time = create_class("Time")
function M.Time.fromSeconds(v) if v < 0 then error("Time") end return setmetatable({val = v}, M.Time) end
function M.Time.fromMinutes(v) return M.Time.fromSeconds(v * 60.0) end
function M.Time.fromHours(v) return M.Time.fromSeconds(v * 3600.0) end
function M.Time:toSeconds() return self.val end
function M.Time:toMinutes() return self.val / 60.0 end
function M.Time:toHours() return self.val / 3600.0 end

-- Acceleration
M.Acceleration = create_class("Acceleration")
function M.Acceleration.fromMs2(v) return setmetatable({val = check(v, "A")}, M.Acceleration) end
function M.Acceleration.fromSpeedAndTime(s, t) return M.Acceleration.fromMs2(s:toMs() / t:toSeconds()) end
function M.Acceleration:toMs2() return self.val end

return M
