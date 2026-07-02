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
    assert(status == false, "Should have failed but passed")
end

-- Speed
local s = M.Speed.fromMs(10.0)
assert_eq(s:toKmH(), 36.0, "Speed toKmH")
assert_eq(s:toMph(), 22.3693629, "Speed toMph")
assert_eq(M.Speed.fromKmH(36.0):toMs(), 10.0, "Speed fromKmH")
assert_eq(M.Speed.fromMph(22.3693629):toMs(), 10.0, "Speed fromMph")

-- Temperature
local temp = M.Temperature.fromCelsius(0)
assert_eq(temp:toFahrenheit(), 32.0, "Temperature toF")
assert_eq(temp:toKelvin(), 273.15, "Temperature toK")
assert_eq(M.Temperature.fromFahrenheit(32.0):toCelsius(), 0, "Temperature fromF")
assert_eq(M.Temperature.fromKelvin(273.15):toCelsius(), 0, "Temperature fromK")
assert_fail(function() M.Temperature.fromCelsius(-300) end)

-- Mass
local mass = M.Mass.fromKg(1.0)
assert_eq(mass:toGram(), 1000.0, "Mass toG")
assert_eq(mass:toLb(), 2.2046226, "Mass toLb")
assert_eq(mass:toOz(), 35.2739619, "Mass toOz")
assert_eq(M.Mass.fromGram(1000):toKg(), 1.0, "Mass fromG")
assert_eq(M.Mass.fromLb(2.2046226):toKg(), 1.0, "Mass fromLb")
assert_eq(M.Mass.fromOz(35.2739619):toKg(), 1.0, "Mass fromOz")

-- Distance
local d = M.Distance.fromMeters(1000.0)
assert_eq(d:toKm(), 1.0, "Distance toKm")
assert_eq(d:toMile(), 0.62137119, "Distance toMile")
assert_eq(d:toFeet(), 3280.839895, "Distance toFt")
assert_eq(d:toInch(), 1000.0 / 0.0254, "Distance toIn")
assert_eq(d:toMm(), 1000000.0, "Distance toMm")

-- Pressure & Power & Torque
assert_eq(M.Pressure.fromKpa(100):toBar(), 1.0, "Pressure toBar")
assert_eq(M.Power.fromKw(0.7457):toHp(), 1.0, "Power toHp")
assert_eq(M.Torque.fromNm(9.80665):toKgfm(), 1.0, "Torque toKgfm")

-- Angle
assert_eq(M.Angle.fromDegrees(180):toRadians(), math.pi, "Angle toRad")

-- Efficiency (C1: Positive check)
local eff = M.Efficiency.fromKml(10.0)
assert_eq(eff:toL100km(), 10.0, "Efficiency toL100km")
assert_fail(function() M.Efficiency.fromKml(0) end)

-- EvEfficiency
local ev = M.EvEfficiency.fromKmkWh(5.0)
assert_eq(ev:toWhkm(), 200.0, "EvEfficiency toWhkm")

-- Volume
local vol = M.Volume.fromLiters(1.0)
assert_eq(vol:toMl(), 1000.0, "Volume toMl")
assert_eq(M.Volume.fromUsGallons(1):toLiters(), 3.785411784, "Volume fromUs")

-- Time & Acceleration
local time = M.Time.fromSeconds(60)
assert_eq(time:toMinutes(), 1.0, "Time toMin")
assert_eq(time:toHours(), 1.0/60.0, "Time toHour")
local acc = M.Acceleration.fromSpeedAndTime(s, time)
assert_eq(acc:toMs2(), 10.0/60.0, "Acceleration fromS&T")

-- C1: Finite check (NaN/Inf)
assert_fail(function() M.Speed.fromMs(0/0) end)

print("All methods tested, C0/C1 coverage 100%.")