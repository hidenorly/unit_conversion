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
using Xunit;
using UnitConversion;

public class UnitConversionTests
{
    private const double Epsilon = 1e-5;

    // --- Speed Tests ---

    [Fact]
    public void TestSpeedConvertKmHToMph()
    {
        var speed = Speed.FromKmH(60.0);
        Assert.Equal(60.0, speed.ToKmH(), Epsilon);
        Assert.Equal(37.2823, speed.ToMph(), 0.001);
        Assert.Equal(60.0 / 3.6, speed.ToMs(), Epsilon);
    }

    [Fact]
    public void TestSpeedConvertMphToKmH()
    {
        var speed = Speed.FromMph(60.0);
        Assert.Equal(60.0, speed.ToMph(), Epsilon);
        Assert.Equal(96.5606, speed.ToKmH(), 0.001);
        Assert.Equal(60.0 * 0.44704, speed.ToMs(), Epsilon);
    }

    [Fact]
    public void TestSpeedZeroAndIdentity()
    {
        var speed = Speed.FromKmH(0.0);
        Assert.Equal(0.0, speed.ToMph(), Epsilon);
        Assert.Equal(0.0, speed.ToMs(), Epsilon);

        double original = 120.5;
        var s_orig = Speed.FromKmH(original);
        Assert.Equal(original, s_orig.ToKmH(), 0.000001);
    }

    // --- Temperature Tests ---

    [Fact]
    public void TestTemperatureConversions()
    {
        var t1 = Temperature.FromFahrenheit(32.0);
        Assert.Equal(32.0, t1.ToFahrenheit(), 0.001);
        Assert.Equal(0.0, t1.ToCelsius(), 0.001);

        var t2 = Temperature.FromCelsius(100.0);
        Assert.Equal(212.0, t2.ToFahrenheit(), 0.001);

        var t3 = Temperature.FromCelsius(0.0);
        Assert.Equal(0.0, t3.ToCelsius(), Epsilon);
        Assert.Equal(273.15, t3.ToKelvin(), Epsilon);

        var t4 = Temperature.FromKelvin(373.15);
        Assert.Equal(373.15, t4.ToKelvin(), Epsilon);
        Assert.Equal(100.0, t4.ToCelsius(), 0.001);
    }

    [Fact]
    public void TestTemperatureExceptions()
    {
        var ex1 = Record.Exception(() => Temperature.FromKelvin(0.0));
        Assert.Null(ex1);

        Assert.Throws<ArgumentException>(() => Temperature.FromCelsius(-273.16));
        Assert.Throws<ArgumentException>(() => Temperature.FromKelvin(-0.01));
        Assert.Throws<ArgumentException>(() => Temperature.FromCelsius(double.NaN));
    }

    // --- Mass Tests ---

    [Fact]
    public void TestMassConversions()
    {
        var m1 = Mass.FromGram(1000.0);
        Assert.Equal(1000.0, m1.ToGram(), 0.000001);
        Assert.Equal(1.0, m1.ToKg(), Epsilon);

        var m2 = Mass.FromLb(1.0);
        Assert.Equal(1.0, m2.ToLb(), 0.000001);
        Assert.Equal(0.453592, m2.ToKg(), 0.000001);

        var m3 = Mass.FromKg(1.0);
        Assert.Equal(1.0, m3.ToKg(), Epsilon);
        Assert.Equal(2.20462, m3.ToLb(), 0.00001);

        var m4 = Mass.FromLb(1.0);
        Assert.Equal(16.0, m4.ToOz(), 0.000001);

        var m5 = Mass.FromOz(16.0);
        Assert.Equal(16.0, m5.ToOz(), 0.000001);
        Assert.Equal(0.453592, m5.ToKg(), 0.000001);
    }

    [Fact]
    public void TestMassExceptions()
    {
        Assert.Throws<ArgumentException>(() => Mass.FromKg(-1.0));
        Assert.Throws<ArgumentException>(() => Mass.FromGram(double.NaN));
        Assert.Throws<ArgumentException>(() => Mass.FromLb(double.PositiveInfinity));

        var ex = Record.Exception(() => Mass.FromKg(0.0));
        Assert.Null(ex);
    }

    // --- Distance Tests ---

    [Fact]
    public void TestDistanceConversions()
    {
        var d1 = Distance.FromMeters(1.0);
        Assert.Equal(1.0, d1.ToMeters(), Epsilon);

        var d2 = Distance.FromKm(1.0);
        Assert.Equal(1.0, d2.ToKm(), Epsilon);
        Assert.Equal(1000.0, d2.ToMeters(), Epsilon);

        var d3 = Distance.FromMile(1.0);
        Assert.Equal(1.0, d3.ToMile(), Epsilon);
        Assert.Equal(1.609344, d3.ToKm(), 0.000001);

        var d4 = Distance.FromFeet(1.0);
        Assert.Equal(1.0, d4.ToFeet(), 0.000001);
        Assert.Equal(12.0, d4.ToInch(), 0.000001);

        var d5 = Distance.FromInch(12.0);
        Assert.Equal(12.0, d5.ToInch(), 0.000001);

        var d6 = Distance.FromMm(1000.0);
        Assert.Equal(1.0, d6.ToMeters(), 0.000001);

        Assert.Throws<ArgumentException>(() => Distance.FromMm(-1.0));
        Assert.Throws<ArgumentException>(() => Distance.FromMeters(double.NaN));
    }

    // --- Pressure Tests ---

    [Fact]
    public void TestPressureConversions()
    {
        var p1 = Pressure.FromBar(2.5);
        Assert.Equal(2.5, p1.ToBar(), Epsilon);
        Assert.Equal(250.0, p1.ToKpa(), 0.001);

        var p2 = Pressure.FromKpa(250.0);
        Assert.Equal(250.0, p2.ToKpa(), Epsilon);
        Assert.Equal(36.2594, p2.ToPsi(), 0.001);

        var p3 = Pressure.FromPsi(36.2594);
        Assert.Equal(36.2594, p3.ToPsi(), 0.001);
        Assert.Equal(250.0, p3.ToKpa(), 0.001);
    }

    [Fact]
    public void TestPressureExceptions()
    {
        Assert.Throws<ArgumentException>(() => Pressure.FromBar(-1.0));
        Assert.Throws<ArgumentException>(() => Pressure.FromKpa(double.NaN));
        Assert.Throws<ArgumentException>(() => Pressure.FromPsi(double.PositiveInfinity));

        var ex = Record.Exception(() => Pressure.FromKpa(0.0));
        Assert.Null(ex);
    }

    // --- Power Tests ---

    [Fact]
    public void TestPowerConversions()
    {
        var p1 = Power.FromKw(100.0);
        Assert.Equal(100.0, p1.ToKw(), 1e-9);
        Assert.Equal(135.962, p1.ToPs(), 0.001);
        Assert.Equal(134.102, p1.ToHp(), 0.001);

        var p2 = Power.FromPs(135.962);
        Assert.Equal(100.0, p2.ToKw(), 0.01);

        var p3 = Power.FromHp(134.102);
        Assert.Equal(100.0, p3.ToKw(), 0.01);
    }

    [Fact]
    public void TestPowerExceptions()
    {
        Assert.Throws<ArgumentException>(() => Power.FromKw(-1.0));
        Assert.Throws<ArgumentException>(() => Power.FromKw(double.NaN));
        Assert.Throws<ArgumentException>(() => Power.FromKw(double.PositiveInfinity));

        Assert.Throws<ArgumentException>(() => Power.FromPs(-1.0));
        Assert.Throws<ArgumentException>(() => Power.FromHp(-1.0));

        var ex = Record.Exception(() => Power.FromKw(0.0));
        Assert.Null(ex);
    }

    // --- Torque Tests ---

    [Fact]
    public void TestTorqueConversions()
    {
        var t1 = Torque.FromNm(10.0);
        Assert.Equal(10.0, t1.ToNm(), Epsilon);

        var t2 = Torque.FromKgfm(10.0);
        Assert.Equal(10.0, t2.ToKgfm(), 0.0001);
        Assert.Equal(98.0665, t2.ToNm(), 0.0001);

        var t3 = Torque.FromLbft(1.0);
        Assert.Equal(1.0, t3.ToLbft(), 0.0001);
    }

    [Fact]
    public void TestTorqueExceptions()
    {
        Assert.Throws<ArgumentException>(() => Torque.FromNm(-1.0));
        Assert.Throws<ArgumentException>(() => Torque.FromNm(double.NaN));
        Assert.Throws<ArgumentException>(() => Torque.FromNm(double.PositiveInfinity));
        
        var ex = Record.Exception(() => Torque.FromNm(0.0));
        Assert.Null(ex);
    }

    // --- Angle Tests ---

    [Fact]
    public void TestAngleConversions()
    {
        var a1 = Angle.FromDegrees(180.0);
        Assert.Equal(180.0, a1.ToDegrees(), 0.000001);
        Assert.Equal(Math.PI, a1.ToRadians(), 0.000001);

        var a2 = Angle.FromRadians(Math.PI / 2.0);
        Assert.Equal(Math.PI / 2.0, a2.ToRadians(), 0.000001);
        Assert.Equal(90.0, a2.ToDegrees(), 0.000001);
    }

    [Fact]
    public void TestAngleNormalization()
    {
        // Degrees normalization (0 to 360)
        var a1 = Angle.FromDegrees(450.0).NormalizeDegrees();
        Assert.Equal(90.0, a1.ToDegrees(), 0.000001);

        var a2 = Angle.FromDegrees(-90.0).NormalizeDegrees();
        Assert.Equal(270.0, a2.ToDegrees(), 0.000001);

        var a3 = Angle.FromDegrees(360.0).NormalizeDegrees();
        Assert.Equal(0.0, a3.ToDegrees(), 0.000001);

        // Radians normalization (0 to 2π)
        var r1 = Angle.FromRadians(Math.PI * 2.5).NormalizeRadians();
        Assert.Equal(Math.PI * 0.5, r1.ToRadians(), 0.000001);

        var r2 = Angle.FromRadians(-Math.PI * 0.5).NormalizeRadians();
        Assert.Equal(Math.PI * 1.5, r2.ToRadians(), 0.000001);
    }

    [Fact]
    public void TestAngleExceptions()
    {
        Assert.Throws<ArgumentException>(() => Angle.FromRadians(double.NaN));
        Assert.Throws<ArgumentException>(() => Angle.FromDegrees(double.PositiveInfinity));

        var ex = Record.Exception(() => Angle.FromDegrees(0.0));
        Assert.Null(ex);
    }

    // --- Efficiency Tests ---

    [Fact]
    public void TestEfficiencyConversions()
    {
        var e1 = Efficiency.FromL100km(10.0);
        Assert.Equal(10.0, e1.ToL100km(), Epsilon);
        Assert.Equal(10.0, e1.ToKml(), Epsilon);

        var e2 = Efficiency.FromMpg(23.5215);
        Assert.Equal(23.5215, e2.ToMpg(), 0.001);
        Assert.Equal(10.0, e2.ToKml(), 0.001);

        var e3 = Efficiency.FromKml(10.0);
        Assert.Equal(10.0, e3.ToKml(), Epsilon);
        Assert.Equal(10.0, e3.ToL100km(), Epsilon);
        Assert.Equal(23.5215, e3.ToMpg(), 0.001);
    }

    [Fact]
    public void TestEfficiencyExceptions()
    {
        Assert.Throws<ArgumentException>(() => Efficiency.FromKml(0.0));
        Assert.Throws<ArgumentException>(() => Efficiency.FromKml(-1.0));
        Assert.Throws<ArgumentException>(() => Efficiency.FromL100km(-5.0));
        Assert.Throws<ArgumentException>(() => Efficiency.FromKml(double.NaN));
        Assert.Throws<ArgumentException>(() => Efficiency.FromKml(double.PositiveInfinity));
    }

    // --- EvEfficiency Tests ---

    [Fact]
    public void TestEvEfficiencyConversions()
    {
        var e1 = EvEfficiency.FromKmkWh(6.0);
        Assert.Equal(6.0, e1.ToKmkWh(), Epsilon);
        Assert.Equal(166.666, e1.ToWhkm(), 0.001);
        Assert.Equal(16.666, e1.ToKwh100km(), 0.001);
        Assert.Equal(3.728, e1.ToMpKwh(), 0.001);

        var e2 = EvEfficiency.FromWhkm(200.0);
        Assert.Equal(200.0, e2.ToWhkm(), 0.001);
        Assert.Equal(5.0, e2.ToKmkWh(), 0.01);
        Assert.Equal(20.0, e2.ToKwh100km(), 0.01);

        var e3 = EvEfficiency.FromKwh100km(20.0);
        Assert.Equal(20.0, e3.ToKwh100km(), 0.1);
        Assert.Equal(5.0, e3.ToKmkWh(), Epsilon);

        var e4 = EvEfficiency.FromMpKwh(1.0);
        Assert.Equal(1.0, e4.ToMpKwh(), 0.1);
        Assert.Equal(1.609344, e4.ToKmkWh(), 0.000001);
    }

    [Fact]
    public void TestEvEfficiencyExceptions()
    {
        Assert.Throws<ArgumentException>(() => EvEfficiency.FromKmkWh(0.0));
        Assert.Throws<ArgumentException>(() => EvEfficiency.FromWhkm(-1.0));
        Assert.Throws<ArgumentException>(() => EvEfficiency.FromKmkWh(double.NaN));
    }

    // --- Volume Tests ---

    [Fact]
    public void TestVolumeConversions()
    {
        var v1 = Volume.FromLiters(1.0);
        Assert.Equal(1.0, v1.ToLiters(), Epsilon);
        Assert.Equal(1000.0, v1.ToMl(), Epsilon);
        Assert.Equal(0.264172, v1.ToUsGallons(), 0.000001);
        Assert.Equal(0.219969, v1.ToImpGallons(), 0.000001);

        var v2 = Volume.FromMl(500.0);
        Assert.Equal(500.0, v2.ToMl(), Epsilon);
        Assert.Equal(0.5, v2.ToLiters(), Epsilon);

        var v3 = Volume.FromUsGallons(10.0);
        Assert.Equal(10.0, v3.ToUsGallons(), 0.0001);
        Assert.Equal(37.8541, v3.ToLiters(), 0.0001);

        var v4 = Volume.FromImpGallons(10.0);
        Assert.Equal(10.0, v4.ToImpGallons(), 1e-9);
        Assert.Equal(45.4609, v4.ToLiters(), 0.0001);
    }

    [Fact]
    public void TestVolumeExceptions()
    {
        Assert.Throws<ArgumentException>(() => Volume.FromLiters(-1.0));
        Assert.Throws<ArgumentException>(() => Volume.FromMl(double.NaN));
        Assert.Throws<ArgumentException>(() => Volume.FromUsGallons(double.PositiveInfinity));

        var ex = Record.Exception(() => Volume.FromLiters(0.0));
        Assert.Null(ex);
    }

    // --- Time Tests ---

    [Fact]
    public void TestTimeConversions()
    {
        var t1 = Time.FromSeconds(60.0);
        Assert.Equal(60.0, t1.ToSeconds(), 1e-9);
        Assert.Equal(1.0, t1.ToMinutes(), 1e-9);
        Assert.Equal(1.0 / 60.0, t1.ToHours(), 1e-9);

        var t2 = Time.FromMinutes(1.0);
        Assert.Equal(60.0, t2.ToSeconds(), 1e-9);

        var t3 = Time.FromHours(1.0 / 60.0);
        Assert.Equal(60.0, t3.ToSeconds(), 1e-9);

        Record.Exception(() => Time.FromSeconds(0.0));
        Record.Exception(() => Time.FromMinutes(0.0));
        Record.Exception(() => Time.FromHours(0.0));
    }

    [Fact]
    public void TestTimeExceptions()
    {
        Assert.Throws<ArgumentException>(() => Time.FromSeconds(double.NaN));
        Assert.Throws<ArgumentException>(() => Time.FromSeconds(-1.0));
        Assert.Throws<ArgumentException>(() => Time.FromSeconds(double.PositiveInfinity));
    }

    // --- Acceleration & Operators Tests ---

    [Fact]
    public void TestAccelerationAndOperators()
    {
        var a = Acceleration.FromMs2(9.8);
        var s = a * Time.FromSeconds(2.0);
        Assert.Equal(19.6, s.ToMs(), 1e-9);

        Record.Exception(() => Acceleration.FromMs2(0.0));
        Assert.Throws<ArgumentException>(() => Acceleration.FromMs2(double.NaN));
        Assert.Throws<ArgumentException>(() => a * Time.FromSeconds(-1.0));
    }

    [Fact]
    public void TestDerivedFromDeltaSpeed()
    {
        var v1 = Speed.FromMs(20.0);
        var v2 = Speed.FromMs(0.0);
        var t = Time.FromSeconds(5.0);
        var a = (v1 - v2) / t;
        Assert.Equal(4.0, a.ToMs2(), 1e-9);

        Assert.Throws<ArgumentException>(() => (v1 - v2) / Time.FromSeconds(0.0));
    }

    [Fact]
    public void TestPhysicsOps()
    {
        var speed = Speed.FromKmH(100.0);
        var time = Time.FromSeconds(9.5);
        var accel = Acceleration.FromSpeedAndTime(speed, time);
        Assert.Equal(2.9239, accel.ToMs2(), 1e-4);

        var d = Speed.FromMs(10.0) * Time.FromSeconds(5.0);
        Assert.Equal(50.0, d.ToMeters(), 1e-9);

        Assert.Throws<ArgumentException>(() => Speed.FromMs(10.0) * Time.FromSeconds(-1.0));

        var v = Speed.FromMs(10.0);
        var v_delta = Acceleration.FromMs2(2.0) * Time.FromSeconds(5.0);
        var v2 = v + v_delta;
        Assert.Equal(20.0, v2.ToMs(), 1e-9);

        // Additional operators support verification tests
        var t_calc = Speed.FromMs(20.0) / Acceleration.FromMs2(2.0);
        Assert.Equal(10.0, t_calc.ToSeconds(), 1e-9);

        var d1 = Distance.FromMeters(100.0);
        var d2 = Distance.FromMeters(50.0);
        var d_sum = d1 + d2;
        Assert.Equal(150.0, d_sum.ToMeters(), 1e-9);

        var d_sub = d1 - d2;
        Assert.Equal(50.0, d_sub.ToMeters(), 1e-9);

        var d_mul = Distance.FromMeters(10.0) * 2.0;
        Assert.Equal(20.0, d_mul.ToMeters(), 1e-9);

        var d_mul_left = 2.0 * Distance.FromMeters(10.0);
        Assert.Equal(20.0, d_mul_left.ToMeters(), 1e-9);

        var speed_calc = Distance.FromMeters(100.0) / Time.FromSeconds(10.0);
        Assert.Equal(10.0, speed_calc.ToMs(), 1e-9);

        var time_calc = Distance.FromMeters(100.0) / Speed.FromMs(10.0);
        Assert.Equal(10.0, time_calc.ToSeconds(), 1e-9);

        var ratio = Distance.FromMeters(100.0) / Distance.FromMeters(25.0);
        Assert.Equal(4.0, ratio, 1e-9);

        var t_sum = Time.FromSeconds(10.0) + Time.FromSeconds(20.0);
        Assert.Equal(30.0, t_sum.ToSeconds(), 1e-9);

        var t_sub = Time.FromSeconds(20.0) - Time.FromSeconds(10.0);
        Assert.Equal(10.0, t_sub.ToSeconds(), 1e-9);

        var t_mul = Time.FromSeconds(10.0) * 2.0;
        Assert.Equal(20.0, t_mul.ToSeconds(), 1e-9);

        var t_mul_left = 2.0 * Time.FromSeconds(10.0);
        Assert.Equal(20.0, t_mul_left.ToSeconds(), 1e-9);
    }

    [Fact]
    public void TestScalarMultiplication()
    {
        var v = Speed.FromMs(10.0) * 0.5;
        Assert.Equal(5.0, v.ToMs(), 1e-9);

        var v_scalar_left = 2.0 * Speed.FromMs(10.0);
        Assert.Equal(20.0, v_scalar_left.ToMs(), 1e-9);

        var a = Acceleration.FromMs2(9.8) * 0.5;
        Assert.Equal(4.9, a.ToMs2(), 1e-9);

        var a_scalar_left = 2.0 * Acceleration.FromMs2(9.8);
        Assert.Equal(19.6, a_scalar_left.ToMs2(), 1e-9);
    }
}