/*
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
*/

namespace UnitConversion.Tests;

using System;
using System.IO;
using System.Text.Json;
using Xunit;
using UnitConversion;

// Conformance test: run the shared golden vectors (test_vectors.json at
// the repository root) against the C# implementation.
//
// Every language implementation runs the same vectors; a failure here
// means this implementation disagrees with the shared specification.
// Regenerate vectors with tools/generate_test_vectors.py.
public class ConformanceTest
{
    private static string FindVectors()
    {
        var env = Environment.GetEnvironmentVariable("UNIT_CONVERSION_TEST_VECTORS");
        if (!string.IsNullOrEmpty(env)) return env;
        var dir = new DirectoryInfo(
            Path.GetDirectoryName(typeof(ConformanceTest).Assembly.Location)!);
        for (int i = 0; i < 8 && dir != null; i++)
        {
            var cand = Path.Combine(dir.FullName, "test_vectors.json");
            if (File.Exists(cand)) return cand;
            dir = dir.Parent;
        }
        dir = new DirectoryInfo(Directory.GetCurrentDirectory());
        for (int i = 0; i < 8 && dir != null; i++)
        {
            var cand = Path.Combine(dir.FullName, "test_vectors.json");
            if (File.Exists(cand)) return cand;
            dir = dir.Parent;
        }
        throw new FileNotFoundException("test_vectors.json not found");
    }

    private static double ParseValue(JsonElement v)
    {
        if (v.ValueKind == JsonValueKind.String)
        {
            return v.GetString() switch
            {
                "NaN" => double.NaN,
                "Infinity" => double.PositiveInfinity,
                "-Infinity" => double.NegativeInfinity,
                var s => throw new InvalidOperationException($"bad value token {s}"),
            };
        }
        return v.GetDouble();
    }

    private static object Construct(JsonElement spec)
    {
        string quantity = spec.GetProperty("quantity").GetString()!;
        string unit = spec.GetProperty("unit").GetString()!;
        double v = ParseValue(spec.GetProperty("value"));
        return (quantity, unit) switch
        {
            ("Speed", "ms") => Speed.FromMs(v),
            ("Speed", "kmh") => Speed.FromKmH(v),
            ("Speed", "mph") => Speed.FromMph(v),
            ("Temperature", "celsius") => Temperature.FromCelsius(v),
            ("Temperature", "fahrenheit") => Temperature.FromFahrenheit(v),
            ("Temperature", "kelvin") => Temperature.FromKelvin(v),
            ("Mass", "kg") => Mass.FromKg(v),
            ("Mass", "gram") => Mass.FromGram(v),
            ("Mass", "lb") => Mass.FromLb(v),
            ("Mass", "oz") => Mass.FromOz(v),
            ("Distance", "meters") => Distance.FromMeters(v),
            ("Distance", "km") => Distance.FromKm(v),
            ("Distance", "mile") => Distance.FromMile(v),
            ("Distance", "feet") => Distance.FromFeet(v),
            ("Distance", "inch") => Distance.FromInch(v),
            ("Distance", "mm") => Distance.FromMm(v),
            ("Pressure", "kpa") => Pressure.FromKpa(v),
            ("Pressure", "bar") => Pressure.FromBar(v),
            ("Pressure", "psi") => Pressure.FromPsi(v),
            ("Power", "kw") => Power.FromKw(v),
            ("Power", "ps") => Power.FromPs(v),
            ("Power", "hp") => Power.FromHp(v),
            ("Torque", "nm") => Torque.FromNm(v),
            ("Torque", "kgfm") => Torque.FromKgfm(v),
            ("Torque", "lbft") => Torque.FromLbft(v),
            ("Angle", "radians") => Angle.FromRadians(v),
            ("Angle", "degrees") => Angle.FromDegrees(v),
            ("Efficiency", "kml") => Efficiency.FromKml(v),
            ("Efficiency", "l100km") => Efficiency.FromL100km(v),
            ("Efficiency", "mpg") => Efficiency.FromMpg(v),
            ("EvEfficiency", "km_per_kwh") => EvEfficiency.FromKmkWh(v),
            ("EvEfficiency", "wh_per_km") => EvEfficiency.FromWhkm(v),
            ("EvEfficiency", "kwh_per_100km") => EvEfficiency.FromKwh100km(v),
            ("EvEfficiency", "miles_per_kwh") => EvEfficiency.FromMpKwh(v),
            ("Volume", "liters") => Volume.FromLiters(v),
            ("Volume", "ml") => Volume.FromMl(v),
            ("Volume", "us_gallons") => Volume.FromUsGallons(v),
            ("Volume", "imp_gallons") => Volume.FromImpGallons(v),
            ("Time", "seconds") => Time.FromSeconds(v),
            ("Time", "minutes") => Time.FromMinutes(v),
            ("Time", "hours") => Time.FromHours(v),
            ("Acceleration", "ms2") => Acceleration.FromMs2(v),
            _ => throw new InvalidOperationException($"unknown quantity/unit {quantity}/{unit}"),
        };
    }

    private static double Read(object o, string unit)
    {
        return (o, unit) switch
        {
            (Speed x, "ms") => x.ToMs(),
            (Speed x, "kmh") => x.ToKmH(),
            (Speed x, "mph") => x.ToMph(),
            (Temperature x, "celsius") => x.ToCelsius(),
            (Temperature x, "fahrenheit") => x.ToFahrenheit(),
            (Temperature x, "kelvin") => x.ToKelvin(),
            (Mass x, "kg") => x.ToKg(),
            (Mass x, "gram") => x.ToGram(),
            (Mass x, "lb") => x.ToLb(),
            (Mass x, "oz") => x.ToOz(),
            (Distance x, "meters") => x.ToMeters(),
            (Distance x, "km") => x.ToKm(),
            (Distance x, "mile") => x.ToMile(),
            (Distance x, "feet") => x.ToFeet(),
            (Distance x, "inch") => x.ToInch(),
            (Distance x, "mm") => x.ToMm(),
            (Pressure x, "kpa") => x.ToKpa(),
            (Pressure x, "bar") => x.ToBar(),
            (Pressure x, "psi") => x.ToPsi(),
            (Power x, "kw") => x.ToKw(),
            (Power x, "ps") => x.ToPs(),
            (Power x, "hp") => x.ToHp(),
            (Torque x, "nm") => x.ToNm(),
            (Torque x, "kgfm") => x.ToKgfm(),
            (Torque x, "lbft") => x.ToLbft(),
            (Angle x, "radians") => x.ToRadians(),
            (Angle x, "degrees") => x.ToDegrees(),
            (Efficiency x, "kml") => x.ToKml(),
            (Efficiency x, "l100km") => x.ToL100km(),
            (Efficiency x, "mpg") => x.ToMpg(),
            (EvEfficiency x, "km_per_kwh") => x.ToKmkWh(),
            (EvEfficiency x, "wh_per_km") => x.ToWhkm(),
            (EvEfficiency x, "kwh_per_100km") => x.ToKwh100km(),
            (EvEfficiency x, "miles_per_kwh") => x.ToMpKwh(),
            (Volume x, "liters") => x.ToLiters(),
            (Volume x, "ml") => x.ToMl(),
            (Volume x, "us_gallons") => x.ToUsGallons(),
            (Volume x, "imp_gallons") => x.ToImpGallons(),
            (Time x, "seconds") => x.ToSeconds(),
            (Time x, "minutes") => x.ToMinutes(),
            (Time x, "hours") => x.ToHours(),
            (Acceleration x, "ms2") => x.ToMs2(),
            (double x, _) => x,
            _ => throw new InvalidOperationException($"read: mismatched unit {unit}"),
        };
    }

    private static object ApplyOp(JsonElement c)
    {
        string op = c.GetProperty("op").GetString()!;
        object lhs = Construct(c.GetProperty("lhs"));
        if (op == "mul_scalar" || op == "div_scalar")
        {
            double s = ParseValue(c.GetProperty("rhs"));
            return lhs switch
            {
                Speed x => op == "mul_scalar" ? x * s : x / s,
                Distance x => op == "mul_scalar" ? x * s : x / s,
                Efficiency x => op == "mul_scalar" ? x * s : x / s,
                _ => throw new InvalidOperationException("scalar op unsupported"),
            };
        }
        object rhs = Construct(c.GetProperty("rhs"));
        return (op, lhs, rhs) switch
        {
            ("add", Speed a, Speed b) => a + b,
            ("sub", Speed a, Speed b) => a - b,
            ("add", Mass a, Mass b) => a + b,
            ("sub", Mass a, Mass b) => a - b,
            ("add", Time a, Time b) => a + b,
            ("sub", Time a, Time b) => a - b,
            ("add", Angle a, Angle b) => a + b,
            ("sub", Angle a, Angle b) => a - b,
            ("add", Temperature a, Temperature b) => a + b,
            ("sub", Temperature a, Temperature b) => a - b,
            ("add", Acceleration a, Acceleration b) => a + b,
            ("sub", Acceleration a, Acceleration b) => a - b,
            ("add", Distance a, Distance b) => a + b,
            ("sub", Distance a, Distance b) => a - b,
            ("mul", Speed a, Time b) => a * b,
            ("mul", Time a, Speed b) => a * b,
            ("mul", Acceleration a, Time b) => a * b,
            ("div", Distance a, Time b) => a / b,
            ("div", Speed a, Time b) => a / b,
            ("div", Distance a, Speed b) => a / b,
            ("div", Speed a, Acceleration b) => a / b,
            ("div", Distance a, Distance b) => a / b,
            ("div", Speed a, Speed b) => a / b,
            ("div", Time a, Time b) => a / b,
            ("div", Volume a, Volume b) => a / b,
            ("div", Acceleration a, Acceleration b) => a / b,
            ("div", Efficiency a, Efficiency b) => a / b,
            ("div", EvEfficiency a, EvEfficiency b) => a / b,
            _ => throw new InvalidOperationException($"unsupported op combination: {op}"),
        };
    }

    private static void AssertClose(double actual, double expected, double relTol,
                                    double absTol, string label)
    {
        double tol = absTol + relTol * Math.Abs(expected);
        if (!double.IsFinite(actual) || Math.Abs(actual - expected) > tol)
        {
            throw new InvalidOperationException(
                $"{label}: got {actual:R}, expected {expected:R} (tol {tol:G})");
        }
    }

    private static bool Throws(Action f)
    {
        try { f(); return false; }
        catch (Exception) { return true; }
    }

    // Runs all vectors; returns the number of cases checked and throws
    // on the first mismatch. Kept separate from the [Fact] so it can
    // also be invoked directly (e.g. from a console harness).
    public static int RunAll()
    {
        using var doc = JsonDocument.Parse(File.ReadAllText(FindVectors()));
        var root = doc.RootElement;
        double relTol = root.TryGetProperty("rel_tol", out var rt) ? rt.GetDouble() : 1e-9;
        double absTol = root.TryGetProperty("abs_tol", out var at) ? at.GetDouble() : 1e-12;
        int checkedCount = 0;
        foreach (var c in root.GetProperty("cases").EnumerateArray())
        {
            string kind = c.GetProperty("kind").GetString()!;
            string label = $"case {checkedCount}: {c.GetRawText()}";
            switch (kind)
            {
                case "convert":
                {
                    var spec = JsonDocument.Parse(
                        "{\"quantity\":\"" + c.GetProperty("quantity").GetString() +
                        "\",\"unit\":\"" + c.GetProperty("from").GetString() +
                        "\",\"value\":" + c.GetProperty("value").GetRawText() + "}").RootElement;
                    object obj = Construct(spec);
                    double actual = Read(obj, c.GetProperty("to").GetString()!);
                    AssertClose(actual, c.GetProperty("expected").GetDouble(),
                                relTol, absTol, label);
                    break;
                }
                case "error":
                {
                    var spec = JsonDocument.Parse(
                        "{\"quantity\":\"" + c.GetProperty("quantity").GetString() +
                        "\",\"unit\":\"" + c.GetProperty("from").GetString() +
                        "\",\"value\":" + c.GetProperty("value").GetRawText() + "}").RootElement;
                    if (!Throws(() => Construct(spec)))
                    {
                        throw new InvalidOperationException(
                            $"{label}: expected an error but construction succeeded");
                    }
                    break;
                }
                case "op":
                {
                    if (c.TryGetProperty("error", out _))
                    {
                        if (!Throws(() => ApplyOp(c)))
                        {
                            throw new InvalidOperationException(
                                $"{label}: expected an error but the op succeeded");
                        }
                    }
                    else
                    {
                        object result = ApplyOp(c);
                        double actual = c.GetProperty("expected_quantity").GetString() == "scalar"
                            ? Read(result, "")
                            : Read(result, c.GetProperty("expected_unit").GetString()!);
                        AssertClose(actual, c.GetProperty("expected").GetDouble(),
                                    relTol, absTol, label);
                    }
                    break;
                }
                default:
                    throw new InvalidOperationException($"unknown kind {kind}");
            }
            checkedCount++;
        }
        return checkedCount;
    }

    [Fact]
    public void GoldenVectors()
    {
        int n = RunAll();
        Assert.True(n > 0);
    }
}
