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

    [Fact]
    public void TestSpeed()
    {
        var s = Speed.FromMs(10.0);
        Assert.Equal(36.0, s.ToKmH(), Epsilon);
        Assert.Equal(22.3693629, s.ToMph(), Epsilon);
        Assert.Equal(10.0, Speed.FromKmH(36.0).ToMs(), Epsilon);
        Assert.Equal(10.0, Speed.FromMph(22.3693629).ToMs(), Epsilon);
        Assert.Throws<ArgumentException>(() => Speed.FromMs(double.NaN));
    }

    [Fact]
    public void TestTemperature()
    {
        var temp = Temperature.FromCelsius(0);
        Assert.Equal(32.0, temp.ToFahrenheit(), Epsilon);
        Assert.Equal(273.15, temp.ToKelvin(), Epsilon);
        Assert.Equal(0, Temperature.FromFahrenheit(32.0).ToCelsius(), Epsilon);
        Assert.Throws<ArgumentException>(() => Temperature.FromCelsius(-300));
    }

    [Fact]
    public void TestOperators()
    {
        var s1 = Speed.FromMs(10.0);
        var s2 = Speed.FromMs(20.0);
        var t = Time.FromSeconds(5.0);

        var s3 = s1 + s2;
        Assert.Equal(30.0, s3.ToMs(), Epsilon);

        var s4 = s2 - s1;
        Assert.Equal(10.0, s4.ToMs(), Epsilon);

        var s5 = s1 * 2.0;
        Assert.Equal(20.0, s5.ToMs(), Epsilon);

        var d = s1 * t;
        Assert.Equal(50.0, d.ToMeters(), Epsilon);

        var acc = s1 / t;
        Assert.Equal(2.0, acc.ToMs2(), Epsilon);
    }

    [Fact]
    public void TestMassAndDistance()
    {
        var mass = Mass.FromKg(1.0);
        Assert.Equal(1000.0, mass.ToGram(), Epsilon);
        Assert.Equal(2.2046226, mass.ToLb(), Epsilon);

        var d = Distance.FromMeters(1000.0);
        Assert.Equal(1.0, d.ToKm(), Epsilon);
        Assert.Equal(3280.839895, d.ToFeet(), Epsilon);
    }
}