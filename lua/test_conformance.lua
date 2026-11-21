--[[
  Conformance test: run the shared golden vectors (test_vectors.json at
  the repository root) against the Lua implementation.

  Every language implementation runs the same vectors; a failure here
  means this implementation disagrees with the shared specification.
  Regenerate vectors with tools/generate_test_vectors.py.

  Lua has no standard JSON library, so a minimal JSON decoder for the
  vector file format (objects, arrays, strings, numbers, literals) is
  included below.
]]

local current_dir = debug.getinfo(1, "S").source:sub(2):match("(.*)/") or "."
package.path = package.path .. ";" .. current_dir .. "/?.lua"

local M = require("unit_conversion")

-- --- minimal JSON decoder ---------------------------------------------------
local function decode_json(text)
    local pos = 1
    local function skip_ws()
        while pos <= #text do
            local c = text:sub(pos, pos)
            if c == " " or c == "\t" or c == "\n" or c == "\r" then
                pos = pos + 1
            else
                break
            end
        end
    end
    local parse_value
    local function parse_string()
        pos = pos + 1 -- opening quote
        local parts = {}
        while pos <= #text do
            local c = text:sub(pos, pos)
            if c == '"' then
                pos = pos + 1
                return table.concat(parts)
            elseif c == "\\" then
                local esc = text:sub(pos + 1, pos + 1)
                local map = {['"'] = '"', ["\\"] = "\\", ["/"] = "/",
                             b = "\b", f = "\f", n = "\n", r = "\r", t = "\t"}
                if esc == "u" then
                    local hex = text:sub(pos + 2, pos + 5)
                    table.insert(parts, utf8.char(tonumber(hex, 16)))
                    pos = pos + 6
                else
                    table.insert(parts, map[esc] or esc)
                    pos = pos + 2
                end
            else
                table.insert(parts, c)
                pos = pos + 1
            end
        end
        error("unterminated string")
    end
    local function parse_number()
        local start = pos
        while pos <= #text and text:sub(pos, pos):match("[%d%.eE%+%-]") do
            pos = pos + 1
        end
        return tonumber(text:sub(start, pos - 1))
    end
    local function parse_array()
        pos = pos + 1
        local arr = {}
        skip_ws()
        if text:sub(pos, pos) == "]" then pos = pos + 1 return arr end
        while true do
            table.insert(arr, parse_value())
            skip_ws()
            local c = text:sub(pos, pos)
            pos = pos + 1
            if c == "]" then break end
        end
        return arr
    end
    local function parse_object()
        pos = pos + 1
        local obj = {}
        skip_ws()
        if text:sub(pos, pos) == "}" then pos = pos + 1 return obj end
        while true do
            skip_ws()
            local key = parse_string()
            skip_ws()
            pos = pos + 1 -- ':'
            obj[key] = parse_value()
            skip_ws()
            local c = text:sub(pos, pos)
            pos = pos + 1
            if c == "}" then break end
        end
        return obj
    end
    parse_value = function()
        skip_ws()
        local c = text:sub(pos, pos)
        if c == "{" then return parse_object()
        elseif c == "[" then return parse_array()
        elseif c == '"' then return parse_string()
        elseif text:sub(pos, pos + 3) == "true" then pos = pos + 4 return true
        elseif text:sub(pos, pos + 4) == "false" then pos = pos + 5 return false
        elseif text:sub(pos, pos + 3) == "null" then pos = pos + 4 return nil
        else return parse_number() end
    end
    return parse_value()
end

-- --- locate and load the vectors ---------------------------------------------
local function find_vectors()
    local env = os.getenv("UNIT_CONVERSION_TEST_VECTORS")
    if env then return env end
    local candidates = {
        "test_vectors.json",
        "../test_vectors.json",
        current_dir .. "/../test_vectors.json",
        current_dir .. "/test_vectors.json",
    }
    for _, cand in ipairs(candidates) do
        local fh = io.open(cand, "r")
        if fh then fh:close() return cand end
    end
    error("test_vectors.json not found")
end

local fh = assert(io.open(find_vectors(), "r"))
local doc = decode_json(fh:read("*a"))
fh:close()

local REL_TOL = doc.rel_tol or 1e-9
local ABS_TOL = doc.abs_tol or 1e-12

-- --- dispatch ------------------------------------------------------------------
local function Q(cls, from_fn, to_fn)
    return {from = function(v) return cls[from_fn](v) end,
            to = function(o) return o[to_fn](o) end}
end

local DISPATCH = {
    Speed = {ms = Q(M.Speed, "fromMs", "toMs"), kmh = Q(M.Speed, "fromKmH", "toKmH"),
             mph = Q(M.Speed, "fromMph", "toMph")},
    Temperature = {celsius = Q(M.Temperature, "fromCelsius", "toCelsius"),
                   fahrenheit = Q(M.Temperature, "fromFahrenheit", "toFahrenheit"),
                   kelvin = Q(M.Temperature, "fromKelvin", "toKelvin")},
    Mass = {kg = Q(M.Mass, "fromKg", "toKg"), gram = Q(M.Mass, "fromGram", "toGram"),
            lb = Q(M.Mass, "fromLb", "toLb"), oz = Q(M.Mass, "fromOz", "toOz")},
    Distance = {meters = Q(M.Distance, "fromMeters", "toMeters"), km = Q(M.Distance, "fromKm", "toKm"),
                mile = Q(M.Distance, "fromMile", "toMile"), feet = Q(M.Distance, "fromFeet", "toFeet"),
                inch = Q(M.Distance, "fromInch", "toInch"), mm = Q(M.Distance, "fromMm", "toMm")},
    Pressure = {kpa = Q(M.Pressure, "fromKpa", "toKpa"), bar = Q(M.Pressure, "fromBar", "toBar"),
                psi = Q(M.Pressure, "fromPsi", "toPsi")},
    Power = {kw = Q(M.Power, "fromKw", "toKw"), ps = Q(M.Power, "fromPs", "toPs"),
             hp = Q(M.Power, "fromHp", "toHp")},
    Torque = {nm = Q(M.Torque, "fromNm", "toNm"), kgfm = Q(M.Torque, "fromKgfm", "toKgfm"),
              lbft = Q(M.Torque, "fromLbft", "toLbft")},
    Angle = {radians = Q(M.Angle, "fromRadians", "toRadians"),
             degrees = Q(M.Angle, "fromDegrees", "toDegrees")},
    Efficiency = {kml = Q(M.Efficiency, "fromKml", "toKml"),
                  l100km = Q(M.Efficiency, "fromL100km", "toL100km"),
                  mpg = Q(M.Efficiency, "fromMpg", "toMpg")},
    EvEfficiency = {km_per_kwh = Q(M.EvEfficiency, "fromKmkWh", "toKmkWh"),
                    wh_per_km = Q(M.EvEfficiency, "fromWhkm", "toWhkm"),
                    kwh_per_100km = Q(M.EvEfficiency, "fromKwh100km", "toKwh100km"),
                    miles_per_kwh = Q(M.EvEfficiency, "fromMpKwh", "toMpKwh")},
    Volume = {liters = Q(M.Volume, "fromLiters", "toLiters"), ml = Q(M.Volume, "fromMl", "toMl"),
              us_gallons = Q(M.Volume, "fromUsGallons", "toUsGallons"),
              imp_gallons = Q(M.Volume, "fromImpGallons", "toImpGallons")},
    Time = {seconds = Q(M.Time, "fromSeconds", "toSeconds"),
            minutes = Q(M.Time, "fromMinutes", "toMinutes"),
            hours = Q(M.Time, "fromHours", "toHours")},
    Acceleration = {ms2 = Q(M.Acceleration, "fromMs2", "toMs2")},
}

local function parse_value(v)
    if v == "NaN" then return 0 / 0 end
    if v == "Infinity" then return math.huge end
    if v == "-Infinity" then return -math.huge end
    return v
end

local function construct(spec)
    return DISPATCH[spec.quantity][spec.unit].from(parse_value(spec.value))
end

local function read_value(obj, quantity, unit)
    return DISPATCH[quantity][unit].to(obj)
end

local function apply_op(c)
    local lhs = construct(c.lhs)
    local rhs
    if c.op == "mul_scalar" or c.op == "div_scalar" then
        rhs = parse_value(c.rhs)
    else
        rhs = construct(c.rhs)
    end
    if c.op == "add" then return lhs + rhs
    elseif c.op == "sub" then return lhs - rhs
    elseif c.op == "mul" or c.op == "mul_scalar" then return lhs * rhs
    elseif c.op == "div" or c.op == "div_scalar" then return lhs / rhs end
    error("unknown op " .. c.op)
end

-- --- run -----------------------------------------------------------------------
local failures = 0
local function check_close(actual, expected, label)
    local tol = ABS_TOL + REL_TOL * math.abs(expected)
    if not (actual == actual and actual ~= math.huge and actual ~= -math.huge
            and math.abs(actual - expected) <= tol) then
        failures = failures + 1
        print(string.format("FAIL %s: got %s, expected %s (tol %g)",
                            label, tostring(actual), tostring(expected), tol))
    end
end

for i, c in ipairs(doc.cases) do
    local label = string.format("case %d (%s)", i - 1, c.kind)
    if c.kind == "convert" then
        local ok, obj = pcall(construct, {quantity = c.quantity, unit = c["from"], value = c.value})
        if not ok then
            failures = failures + 1
            print("FAIL " .. label .. ": construction raised: " .. tostring(obj))
        else
            check_close(read_value(obj, c.quantity, c.to), c.expected, label)
        end
    elseif c.kind == "error" then
        local ok = pcall(construct, {quantity = c.quantity, unit = c["from"], value = c.value})
        if ok then
            failures = failures + 1
            print("FAIL " .. label .. ": expected error " .. tostring(c.error) .. " but succeeded")
        end
    elseif c.kind == "op" then
        if c.error ~= nil then
            local ok = pcall(apply_op, c)
            if ok then
                failures = failures + 1
                print("FAIL " .. label .. ": expected error " .. tostring(c.error) .. " but succeeded")
            end
        else
            local ok, result = pcall(apply_op, c)
            if not ok then
                failures = failures + 1
                print("FAIL " .. label .. ": op raised: " .. tostring(result))
            elseif c.expected_quantity == "scalar" then
                check_close(result, c.expected, label)
            else
                check_close(read_value(result, c.expected_quantity, c.expected_unit),
                            c.expected, label)
            end
        end
    end
end

if failures > 0 then
    print(string.format("Conformance: %d failure(s) out of %d cases", failures, #doc.cases))
    os.exit(1)
end
print(string.format("Conformance: all %d cases passed", #doc.cases))
