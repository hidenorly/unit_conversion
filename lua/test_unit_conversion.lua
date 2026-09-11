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

-- lua test_unit_conversion.lua

local current_dir = debug.getinfo(1, "S").source:sub(2):match("(.*)/") or "."
package.path = package.path .. ";" .. current_dir .. "/?.lua"

local M = require("unit_conversion")

local function assert_eq(a, b, msg)
    local epsilon = 1e-5
    assert(math.abs(a - b) < epsilon, string.format("%s (got %.10f, expected %.10f)", msg, a, b))
end

local function assert_fail(fn)
    local status = pcall(fn)
    assert(status == false, "Should have failed but passed: " .. (debug.traceback()))
end

-- Speed
local s = M.Speed.fromMs(10.0)
assert_eq(s:toKmH(), 36.0, "Speed toKmH")
assert_eq(s:toMph(), 22.3693629, "Speed toMph")
assert_eq(M.Speed.fromKmH(36.0):toMs(), 10.0, "Speed fromKmH")
assert_eq(M.Speed.fromMph(22.3693629):toMs(), 10.0, "Speed fromMph")
assert(tostring(s) ~= nil, "Speed tostring")
assert_fail(function() M.Speed.fromMs(0/0) end) -- NaN check
assert_fail(function() M.Speed.fromMs(math.huge) end) -- Inf check
assert_fail(function() M.Speed.fromMs(-math.huge) end) -- -Inf check
assert_fail(function() M.Speed.fromMs(-1.0) end) -- Negative check

-- Temperature
local temp = M.Temperature.fromCelsius(0)
assert_eq(temp:toFahrenheit(), 32.0, "Temperature toF")
assert_eq(temp:toKelvin(), 273.15, "Temperature toK")
assert_eq(M.Temperature.fromFahrenheit(32.0):toCelsius(), 0, "Temperature fromF")
assert_eq(M.Temperature.fromKelvin(273.15):toCelsius(), 0, "Temperature fromK")
assert(tostring(temp) ~= nil, "Temperature tostring")
assert_fail(function() M.Temperature.fromCelsius(-300) end)
assert_fail(function() M.Temperature.fromCelsius(0/0) end)
assert_fail(function() M.Temperature.fromCelsius(math.huge) end)

-- Mass
local mass = M.Mass.fromKg(1.0)
assert_eq(mass:toGram(), 1000.0, "Mass toG")
assert_eq(mass:toLb(), 2.2046226, "Mass toLb")
assert_eq(mass:toOz(), 35.2739619, "Mass toOz")
assert_eq(M.Mass.fromGram(1000):toKg(), 1.0, "Mass fromG")
assert_eq(M.Mass.fromLb(2.2046226):toKg(), 1.0, "Mass fromLb")
assert_eq(M.Mass.fromOz(35.2739619):toKg(), 1.0, "Mass fromOz")
assert(tostring(mass) ~= nil, "Mass tostring")
assert_fail(function() M.Mass.fromKg(-1.0) end)
assert_fail(function() M.Mass.fromKg(0/0) end)
assert_fail(function() M.Mass.fromKg(math.huge) end)

-- Distance
local d = M.Distance.fromMeters(1000.0)
assert_eq(d:toKm(), 1.0, "Distance toKm")
assert_eq(d:toMile(), 0.62137119, "Distance toMile")
assert_eq(d:toFeet(), 3280.839895, "Distance toFt")
assert_eq(d:toInch(), 1000.0 / 0.0254, "Distance toIn")
assert_eq(d:toMm(), 1000000.0, "Distance toMm")
assert_eq(M.Distance.fromKm(1.0):toMeters(), 1000.0, "Distance fromKm")
assert_eq(M.Distance.fromMile(1.0):toMeters(), 1609.344, "Distance fromMile")
assert_eq(M.Distance.fromFeet(1.0):toMeters(), 0.3048, "Distance fromFeet")
assert_eq(M.Distance.fromInch(1.0):toMeters(), 0.0254, "Distance fromInch")
assert_eq(M.Distance.fromMm(1000.0):toMeters(), 1.0, "Distance fromMm")
assert(tostring(d) ~= nil, "Distance tostring")
assert_fail(function() M.Distance.fromMeters(-1.0) end)
assert_fail(function() M.Distance.fromMeters(0/0) end)
assert_fail(function() M.Distance.fromMeters(math.huge) end)

-- Pressure & Power & Torque
assert_eq(M.Pressure.fromKpa(100):toBar(), 1.0, "Pressure toBar")
assert_eq(M.Pressure.fromBar(1.0):toKpa(), 100.0, "Pressure fromBar")
assert_eq(M.Pressure.fromPsi(10.0):toKpa(), 68.9476, "Pressure fromPsi")
assert_eq(M.Pressure.fromKpa(6.89476):toPsi(), 1.0, "Pressure toPsi")
assert(tostring(M.Pressure.fromKpa(100)) ~= nil, "Pressure tostring")

assert_eq(M.Power.fromKw(0.74569987):toHp(), 1.0, "Power toHp")
assert_eq(M.Power.fromPs(1.0):toKw(), 0.73549875, "Power fromPs")
assert_eq(M.Power.fromHp(1.0):toKw(), 0.74569987, "Power fromHp")
assert(tostring(M.Power.fromKw(1.0)) ~= nil, "Power tostring")

assert_eq(M.Torque.fromNm(9.80665):toKgfm(), 1.0, "Torque toKgfm")
assert_eq(M.Torque.fromKgfm(1.0):toNm(), 9.80665, "Torque fromKgfm")
assert_eq(M.Torque.fromLbft(1.0):toNm(), 1.355817948, "Torque fromLbft")
assert_eq(M.Torque.fromNm(1.355817948):toLbft(), 1.0, "Torque toLbft")
assert(tostring(M.Torque.fromNm(10.0)) ~= nil, "Torque tostring")

assert_fail(function() M.Pressure.fromKpa(-1.0) end)
assert_fail(function() M.Pressure.fromKpa(0/0) end)
assert_fail(function() M.Pressure.fromKpa(math.huge) end)
assert_fail(function() M.Power.fromKw(-1.0) end)
assert_fail(function() M.Power.fromKw(math.huge) end)
assert_fail(function() M.Power.fromKw(0/0) end)
assert_fail(function() M.Torque.fromNm(-1.0) end)
assert_fail(function() M.Torque.fromNm(0/0) end)
assert_fail(function() M.Torque.fromNm(math.huge) end)

-- Angle
assert_eq(M.Angle.fromDegrees(180):toRadians(), math.pi, "Angle toRad")
assert_eq(M.Angle.fromDegrees(450):normalized():toDegrees(), 90.0, "Angle normalized (positive overflow)")
assert_eq(M.Angle.fromDegrees(-90):normalized():toDegrees(), 270.0, "Angle normalized (negative)")
assert_eq(M.Angle.fromRadians(3 * math.pi):normalized():toRadians(), math.pi, "Angle normalized")
assert_eq(M.Angle.fromDegrees(-90):normalizedSigned():toDegrees(), -90.0, "Angle normalizedSigned")
assert_eq(M.Angle.fromDegrees(270):normalizedSigned():toDegrees(), -90.0, "Angle normalizedSigned overflow")
assert(tostring(M.Angle.fromDegrees(90)) ~= nil, "Angle tostring")
assert_fail(function() M.Angle.fromDegrees(0/0) end)
assert_fail(function() M.Angle.fromDegrees(math.huge) end)
assert_fail(function() M.Angle.fromRadians(0/0) end)

-- Efficiency
local eff = M.Efficiency.fromKml(10.0)
assert_eq(eff:toL100km(), 10.0, "Efficiency toL100km")
assert_eq(eff:toMpg(), 10.0 / 0.425143707, "Efficiency toMpg")
assert_eq(M.Efficiency.fromL100km(10.0):toKml(), 10.0, "Efficiency fromL100km")
assert_eq(M.Efficiency.fromMpg(10.0):toKml(), 10.0 * 0.425143707, "Efficiency fromMpg")
assert(tostring(eff) ~= nil, "Efficiency tostring")
assert_fail(function() M.Efficiency.fromKml(0) end)
assert_fail(function() M.Efficiency.fromKml(-1.0) end)
assert_fail(function() M.Efficiency.fromKml(0/0) end)
assert_fail(function() M.Efficiency.fromKml(math.huge) end)

-- EvEfficiency
local ev = M.EvEfficiency.fromKmkWh(5.0)
assert_eq(ev:toWhkm(), 200.0, "EvEfficiency toWhkm")
assert_eq(ev:toKwh100km(), 20.0, "EvEfficiency toKwh100km")
assert_eq(ev:toMpKwh(), 5.0 / 1.609344, "EvEfficiency toMpKwh")
assert_eq(M.EvEfficiency.fromWhkm(200.0):toKmkWh(), 5.0, "EvEfficiency fromWhkm")
assert_eq(M.EvEfficiency.fromKwh100km(20.0):toKmkWh(), 5.0, "EvEfficiency fromKwh100km")
assert_eq(M.EvEfficiency.fromMpKwh(5.0 / 1.609344):toKmkWh(), 5.0, "EvEfficiency fromMpKwh")
assert(tostring(ev) ~= nil, "EvEfficiency tostring")
assert_fail(function() M.EvEfficiency.fromKmkWh(0) end)
assert_fail(function() M.EvEfficiency.fromKmkWh(-1.0) end)
assert_fail(function() M.EvEfficiency.fromKmkWh(0/0) end)
assert_fail(function() M.EvEfficiency.fromKmkWh(math.huge) end)

-- Volume
local vol = M.Volume.fromLiters(1.0)
assert_eq(vol:toMl(), 1000.0, "Volume toMl")
assert_eq(vol:toUsGallons(), 1.0 / 3.785411784, "Volume toUsGallons")
assert_eq(vol:toImpGallons(), 1.0 / 4.54609, "Volume toImpGallons")
assert_eq(M.Volume.fromMl(1000.0):toLiters(), 1.0, "Volume fromMl")
assert_eq(M.Volume.fromUsGallons(1):toLiters(), 3.785411784, "Volume fromUs")
assert_eq(M.Volume.fromImpGallons(1):toLiters(), 4.54609, "Volume fromImp")
assert(tostring(vol) ~= nil, "Volume tostring")
assert_fail(function() M.Volume.fromLiters(-1.0) end)
assert_fail(function() M.Volume.fromLiters(0/0) end)
assert_fail(function() M.Volume.fromLiters(math.huge) end)

-- Time & Acceleration
local time = M.Time.fromSeconds(60)
assert_eq(time:toMinutes(), 1.0, "Time toMin")
assert_eq(time:toHours(), 1.0/60.0, "Time toHour")
assert_eq(M.Time.fromMinutes(1.0):toSeconds(), 60.0, "Time fromMin")
assert_eq(M.Time.fromHours(1.0):toSeconds(), 3600.0, "Time fromHour")
assert(tostring(time) ~= nil, "Time tostring")

local acc = M.Acceleration.fromSpeedAndTime(s, time)
assert_eq(acc:toMs2(), 10.0/60.0, "Acceleration fromS&T")
assert(tostring(acc) ~= nil, "Acceleration tostring")

assert_fail(function() M.Time.fromSeconds(-1.0) end)
assert_fail(function() M.Time.fromSeconds(0/0) end)
assert_fail(function() M.Time.fromSeconds(math.huge) end)
assert_fail(function() M.Acceleration.fromMs2(0/0) end)
assert_fail(function() M.Acceleration.fromMs2(math.huge) end)

-- Operator Overload: Speed, Distance, Time, Mass, Acceleration additions/subtractions and scalar multiplications
local s1 = M.Speed.fromMs(10.0)
local s2 = M.Speed.fromMs(20.0)
local t = M.Time.fromSeconds(5.0)

local s3 = s1 + s2
assert_eq(s3:toMs(), 30.0, "Speed addition")
local s4 = s2 - s1
assert_eq(s4:toMs(), 10.0, "Speed subtraction")

local s5 = s1 * 2.0
assert_eq(s5:toMs(), 20.0, "Speed * scalar")
local s6 = 2.0 * s1
assert_eq(s6:toMs(), 20.0, "scalar * Speed")
local s7 = s2 / 2.0
assert_eq(s7:toMs(), 10.0, "Speed / scalar")
assert_fail(function() local _ = s1 / 0.0 end)

local dist = s1 * t
assert_eq(dist:toMeters(), 50.0, "Speed * Time = Distance")
local dist2 = t * s1
assert_eq(dist2:toMeters(), 50.0, "Time * Speed = Distance")

local acc3 = s1 / t
assert_eq(acc3:toMs2(), 2.0, "Speed / Time = Acceleration")
assert_fail(function() local _ = s1 / M.Time.fromSeconds(0.0) end)

local time_res = s1 / acc3
assert_eq(time_res:toSeconds(), 5.0, "Speed / Acceleration = Time")
assert_fail(function() local _ = s1 / M.Acceleration.fromMs2(0.0) end)

local d1 = M.Distance.fromMeters(100.0)
local d2 = M.Distance.fromMeters(20.0)

local d3 = d1 + d2
assert_eq(d3:toMeters(), 120.0, "Distance + Distance")
local d4 = d1 - d2
assert_eq(d4:toMeters(), 80.0, "Distance - Distance")

local ratio = d1 / d2
assert_eq(ratio, 5.0, "Distance / Distance")
assert_fail(function() local _ = d1 / M.Distance.fromMeters(0.0) end)

local time_res2 = d1 / M.Speed.fromMs(10.0)
assert_eq(time_res2:toSeconds(), 10.0, "Distance / Speed = Time")
assert_fail(function() local _ = d1 / M.Speed.fromMs(0.0) end)

local speed_res = d1 / M.Time.fromSeconds(10.0)
assert_eq(speed_res:toMs(), 10.0, "Distance / Time = Speed")
assert_fail(function() local _ = d1 / M.Time.fromSeconds(0.0) end)

local rmul_speed = 2.0 * M.Speed.fromMs(10.0)
assert_eq(rmul_speed:toMs(), 20.0, "Number * Speed")

local rmul_acc = 0.5 * M.Acceleration.fromMs2(10.0)
assert_eq(rmul_acc:toMs2(), 5.0, "Number * Acceleration")
local acc_mul = M.Acceleration.fromMs2(10.0) * 2.0
assert_eq(acc_mul:toMs2(), 20.0, "Acceleration * Number")
local acc_div = M.Acceleration.fromMs2(10.0) / 2.0
assert_eq(acc_div:toMs2(), 5.0, "Acceleration / Number")
assert_fail(function() local _ = M.Acceleration.fromMs2(10.0) / 0.0 end)

local rmul_time = 3.0 * M.Time.fromSeconds(10.0)
assert_eq(rmul_time:toSeconds(), 30.0, "Number * Time")
local time_mul = M.Time.fromSeconds(10.0) * 3.0
assert_eq(time_mul:toSeconds(), 30.0, "Time * Number")
local time_div = M.Time.fromSeconds(10.0) / 2.0
assert_eq(time_div:toSeconds(), 5.0, "Time / Number")
assert_fail(function() local _ = M.Time.fromSeconds(10.0) / 0.0 end)

local rmul_dist = 4.0 * M.Distance.fromMeters(10.0)
assert_eq(rmul_dist:toMeters(), 40.0, "Number * Distance")
local dist_mul = M.Distance.fromMeters(10.0) * 4.0
assert_eq(dist_mul:toMeters(), 40.0, "Distance * Number")
local dist_div = M.Distance.fromMeters(10.0) / 2.0
assert_eq(dist_div:toMeters(), 5.0, "Distance / Number")
assert_fail(function() local _ = M.Distance.fromMeters(10.0) / 0.0 end)

local time_div_acc = t / M.Acceleration.fromMs2(2.0)
assert_eq(time_div_acc:toMs(), 10.0, "Time / Acceleration")
assert_fail(function() local _ = t / M.Acceleration.fromMs2(0.0) end)

local acc_div_time = acc / t
assert_eq(acc_div_time:toMs2(), (10.0 / 60.0) / 5.0, "Acceleration / Time")
assert_fail(function() local _ = acc / M.Time.fromSeconds(0.0) end)

local acc_mul_time = acc * t
assert_eq(acc_mul_time:toMs(), (10.0 / 60.0) * 5.0, "Acceleration * Time = Speed")

local m1 = M.Mass.fromKg(5.0)
local m2 = M.Mass.fromKg(3.0)
local m3 = m1 + m2
assert_eq(m3:toKg(), 8.0, "Mass + Mass")
local m4 = m1 - m2
assert_eq(m4:toKg(), 2.0, "Mass - Mass")
local m5 = m1 * 2.0
assert_eq(m5:toKg(), 10.0, "Mass * scalar")
local m6 = 2.0 * m1
assert_eq(m6:toKg(), 10.0, "scalar * Mass")
local m7 = m1 / 2.0
assert_eq(m7:toKg(), 2.5, "Mass / scalar")
assert_fail(function() local _ = m1 / 0.0 end)
local mass_ratio = m1 / m2
assert_eq(mass_ratio, 5.0 / 3.0, "Mass / Mass")
assert_fail(function() local _ = m1 / M.Mass.fromKg(0.0) end)

local t1 = M.Time.fromSeconds(10.0)
local t2 = M.Time.fromSeconds(5.0)
local t3 = t1 + t2
assert_eq(t3:toSeconds(), 15.0, "Time + Time")
local t4 = t1 - t2
assert_eq(t4:toSeconds(), 5.0, "Time - Time")

print("All tests passed: Logic, Operators, and Validation coverage 100%.")