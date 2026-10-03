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

#include <iostream>
#include <sstream>
#include <limits>
#include <gtest/gtest.h>
#include "unit_conversion.hpp"

// clang++ test_unit_conversion.cpp -I/usr/local/include -L/usr/local/lib -lgtest_main -lgtest


int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}


// --- test case for Speed

// test for conversion from Km/h to Mph
TEST(SpeedTest, ConvertKmHToMph) {
    auto speed = Speed::fromKmH(60.0);
    // 60 km/h is approx. 37.2823 mph
    EXPECT_NEAR(speed.toKmH(), 60.0, 0.001);
    EXPECT_NEAR(speed.toMph(), 37.2823, 0.001);
    EXPECT_NEAR(speed.toMs(), 60.0/3.6, 0.001);
}

// test for conversion from Mph to Km/h
TEST(SpeedTest, ConvertMphToKmH) {
    auto speed = Speed::fromMph(60.0);
    EXPECT_NEAR(speed.toMph(), 60.0, 0.001);
    // 60 mph is approx. 96.5606 km/h
    EXPECT_NEAR(speed.toKmH(), 96.5606, 0.001);
    EXPECT_NEAR(speed.toMs(), 60.0*0.44704, 0.001);
}

// test for conversion to m/s
TEST(SpeedTest, ConvertKmtToMS) {
    auto speed = Speed::fromKmH(0.0);
    EXPECT_DOUBLE_EQ(speed.toMph(), 0.0);
    EXPECT_DOUBLE_EQ(speed.toMs(), 0.0);
}

// test for zero
TEST(SpeedTest, ZeroValue) {
    auto speed = Speed::fromKmH(0.0);
    EXPECT_DOUBLE_EQ(speed.toMph(), 0.0);
    EXPECT_DOUBLE_EQ(speed.toMs(), 0.0);
}

// test for identicality
TEST(SpeedTest, Identity) {
    double original = 120.5;
    auto speed = Speed::fromKmH(original);
    EXPECT_NEAR(speed.toKmH(), original, 0.000001);
}

// test for comparison operators
TEST(SpeedTest, Comparison) {
    auto s1 = Speed::fromKmH(50.0);
    auto s2 = Speed::fromKmH(50.0);
    auto s3 = Speed::fromKmH(100.0);

    EXPECT_TRUE(s1 == s2);
    EXPECT_FALSE(s1 != s2);
    EXPECT_TRUE(s1 != s3);
    EXPECT_TRUE(s1 < s3);
    EXPECT_TRUE(s1 <= s2);
    EXPECT_TRUE(s1 <= s3);
    EXPECT_TRUE(s3 > s1);
    EXPECT_TRUE(s2 >= s1);
    EXPECT_TRUE(s3 >= s1);
}

// test for ostream operator
TEST(SpeedTest, OstreamOperator) {
    auto speed = Speed::fromMs(10.0);
    std::ostringstream oss;
    oss << speed;
    EXPECT_EQ(oss.str(), "10 m/s");
}

// test for validation, exceptions and extreme values in Speed
TEST(SpeedTest, InvalidAndExtreme) {
    EXPECT_THROW(Speed::fromKmH(-1.0), std::invalid_argument);
    EXPECT_THROW(Speed::fromMph(-1.0), std::invalid_argument);
    EXPECT_THROW(Speed::fromMs(-1.0), std::invalid_argument);

    EXPECT_THROW(Speed::fromKmH(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Speed::fromKmH(std::numeric_limits<double>::infinity()), std::invalid_argument);

    EXPECT_NO_THROW(Speed::fromKmH(0.0));

    // Extreme high value test
    double huge_val = 1e12;
    auto huge_speed = Speed::fromKmH(huge_val);
    EXPECT_NEAR(huge_speed.toKmH(), huge_val, 1e-3);
}


// --- test case for Temperature

TEST(TemperatureTest, FahrenheitToCelsius) {
    auto t = Temperature::fromFahrenheit(32.0);
    EXPECT_NEAR(t.toFahrenheit(), 32.0, 0.001);
    EXPECT_NEAR(t.toCelsius(), 0.0, 0.001);
}

TEST(TemperatureTest, CelsiusToFahrenheit) {
    auto t = Temperature::fromCelsius(100.0);
    EXPECT_NEAR(t.toFahrenheit(), 212.0, 0.001);
}

TEST(TemperatureTest, CelsiusToKelvin) {
    auto t = Temperature::fromCelsius(0.0);
    EXPECT_DOUBLE_EQ(t.toCelsius(), 0.0);
    EXPECT_DOUBLE_EQ(t.toKelvin(), 273.15);
}

TEST(TemperatureTest, KelvinToCelsius) {
    auto t = Temperature::fromKelvin(373.15);
    EXPECT_DOUBLE_EQ(t.toKelvin(), 373.15);
    EXPECT_NEAR(t.toCelsius(), 100.0, 0.001);
}

TEST(TemperatureTest, Comparison) {
    auto t1 = Temperature::fromCelsius(20.0);
    auto t2 = Temperature::fromCelsius(20.0);
    auto t3 = Temperature::fromCelsius(30.0);

    EXPECT_TRUE(t1 == t2);
    EXPECT_TRUE(t1 != t3);
    EXPECT_TRUE(t1 < t3);
    EXPECT_TRUE(t1 <= t2);
    EXPECT_TRUE(t3 > t1);
    EXPECT_TRUE(t2 >= t1);
}

TEST(TemperatureTest, Invalid) {
    EXPECT_NO_THROW(Temperature::fromKelvin(0.0));
    EXPECT_THROW(Temperature::fromCelsius(-273.16), std::invalid_argument);
    EXPECT_THROW(Temperature::fromKelvin(-0.01), std::invalid_argument);
    EXPECT_THROW(Temperature::fromCelsius(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Temperature::fromCelsius(std::numeric_limits<double>::infinity()), std::invalid_argument);
    EXPECT_THROW(Temperature::fromFahrenheit(-500.0), std::invalid_argument);
}

TEST(TemperatureTest, OstreamOperator) {
    auto t = Temperature::fromCelsius(25.0);
    std::ostringstream oss;
    oss << t;
    EXPECT_EQ(oss.str(), "25 °C");
}


// --- test case for Weight

TEST(MassTest, GramToKg) {
    auto m = Mass::fromGram(1000.0);
    EXPECT_NEAR(m.toGram(), 1000.0, 0.000001);
    EXPECT_DOUBLE_EQ(m.toKg(), 1.0);
}

TEST(MassTest, LbToKg) {
    auto m = Mass::fromLb(1.0);
    EXPECT_NEAR(m.toLb(), 1.0, 0.000001);
    EXPECT_NEAR(m.toKg(), 0.453592, 0.000001);
}

TEST(MassTest, KgToLb) {
    auto m = Mass::fromKg(1.0);
    EXPECT_DOUBLE_EQ(m.toKg(), 1.0);
    EXPECT_NEAR(m.toLb(), 2.20462, 0.00001);
}

TEST(MassTest, LbToOz) {
    auto m = Mass::fromLb(1.0);
    EXPECT_NEAR(m.toOz(), 16.0, 0.000001);
}

TEST(MassTest, OzToOz) {
    auto m4 = Mass::fromOz(16.0);
    EXPECT_NEAR(m4.toOz(), 16.0, 0.000001);
    EXPECT_NEAR(m4.toKg(), 0.453592, 0.000001);
}

TEST(MassTest, Comparison) {
    auto m1 = Mass::fromKg(10.0);
    auto m2 = Mass::fromKg(10.0);
    auto m3 = Mass::fromKg(20.0);

    EXPECT_TRUE(m1 == m2);
    EXPECT_TRUE(m1 != m3);
    EXPECT_TRUE(m1 < m3);
    EXPECT_TRUE(m3 > m1);
}

TEST(MassTest, InvalidAndExtreme) {
    EXPECT_THROW(Mass::fromKg(-1.0), std::invalid_argument);
    EXPECT_THROW(Mass::fromGram(-100.0), std::invalid_argument);
    EXPECT_THROW(Mass::fromLb(-1.0), std::invalid_argument);
    EXPECT_THROW(Mass::fromOz(-1.0), std::invalid_argument);

    EXPECT_THROW(Mass::fromKg(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Mass::fromKg(std::numeric_limits<double>::infinity()), std::invalid_argument);

    EXPECT_NO_THROW(Mass::fromKg(0.0));

    // Extreme value test
    double massive = 1e15;
    auto m_extreme = Mass::fromKg(massive);
    EXPECT_DOUBLE_EQ(m_extreme.toKg(), massive);
}

TEST(MassTest, OstreamOperator) {
    auto m = Mass::fromKg(5.5);
    std::ostringstream oss;
    oss << m;
    EXPECT_EQ(oss.str(), "5.5 kg");
}


// --- test case for distance

TEST(DistanceTest, MetersToMeters) {
    auto d = Distance::fromMeters(1.0);
    EXPECT_DOUBLE_EQ(d.toMeters(), 1.0);
}

TEST(DistanceTest, KmToMeters) {
    auto d = Distance::fromKm(1.0);
    EXPECT_DOUBLE_EQ(d.toKm(), 1.0);
    EXPECT_DOUBLE_EQ(d.toMeters(), 1000.0);
}

TEST(DistanceTest, MileToKm) {
    auto d = Distance::fromMile(1.0);
    EXPECT_DOUBLE_EQ(d.toMile(), 1.0);
    EXPECT_NEAR(d.toKm(), 1.609344, 0.000001);
}

TEST(DistanceTest, FootToInch) {
    auto d = Distance::fromFeet(1.0);
    EXPECT_NEAR(d.toFeet(), 1.0, 0.000001);
    EXPECT_NEAR(d.toInch(), 12.0, 0.000001);
}


TEST(DistanceTest, InchToInch) {
    auto d = Distance::fromInch(12.0);
    EXPECT_NEAR(d.toInch(), 12.0, 0.000001);
}

TEST(DistanceTest, Comparison) {
    auto d1 = Distance::fromMeters(100.0);
    auto d2 = Distance::fromMeters(100.0);
    auto d3 = Distance::fromMeters(200.0);

    EXPECT_TRUE(d1 == d2);
    EXPECT_TRUE(d1 != d3);
    EXPECT_TRUE(d1 < d3);
    EXPECT_TRUE(d3 > d1);
}

TEST(DistanceTest, MmAndInvalid) {
    auto d = Distance::fromMm(1000.0);
    EXPECT_NEAR(d.toMeters(), 1.0, 0.000001);

    EXPECT_THROW(Distance::fromMm(-1.0), std::invalid_argument);
    EXPECT_THROW(Distance::fromMeters(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Distance::fromKm(std::numeric_limits<double>::infinity()), std::invalid_argument);
}

TEST(DistanceTest, OstreamOperator) {
    auto d = Distance::fromMeters(100.0);
    std::ostringstream oss;
    oss << d;
    EXPECT_EQ(oss.str(), "100 m");
}


// --- test case for pressure

TEST(PressureTest, BarToKpa) {
    auto p = Pressure::fromBar(2.5);
    EXPECT_DOUBLE_EQ(p.toBar(), 2.5);
    EXPECT_NEAR(p.toKpa(), 250.0, 0.001);
}

TEST(PressureTest, KpaToPsi) {
    auto p = Pressure::fromKpa(250.0);
    EXPECT_DOUBLE_EQ(p.toKpa(), 250.0);
    EXPECT_NEAR(p.toPsi(), 36.2594, 0.001);
}

TEST(PressureTest, PsiToPsi) {
    auto p = Pressure::fromPsi(36.2594);
    EXPECT_NEAR(p.toPsi(), 36.2594, 0.001);
    EXPECT_NEAR(p.toKpa(), 250.0, 0.001);
}

TEST(PressureTest, Comparison) {
    auto p1 = Pressure::fromKpa(100.0);
    auto p2 = Pressure::fromKpa(100.0);
    auto p3 = Pressure::fromKpa(200.0);

    EXPECT_TRUE(p1 == p2);
    EXPECT_TRUE(p1 != p3);
    EXPECT_TRUE(p1 < p3);
}

TEST(PressureTest, Invalid) {
    EXPECT_THROW(Pressure::fromKpa(-1.0), std::invalid_argument);
    EXPECT_THROW(Pressure::fromBar(-0.1), std::invalid_argument);
    EXPECT_THROW(Pressure::fromPsi(-1.0), std::invalid_argument);

    EXPECT_THROW(Pressure::fromKpa(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Pressure::fromKpa(std::numeric_limits<double>::infinity()), std::invalid_argument);

    EXPECT_NO_THROW(Pressure::fromKpa(0.0));
}

TEST(PressureTest, OstreamOperator) {
    auto p = Pressure::fromKpa(101.3);
    std::ostringstream oss;
    oss << p;
    EXPECT_EQ(oss.str(), "101.3 kPa");
}


// --- test case for power

TEST(PowerTest, KwPsHpToAll) {
    auto p1 = Power::fromKw(100.0);
    EXPECT_NEAR(p1.toKw(), 100.0, 1e-9);
    EXPECT_NEAR(p1.toPs(), 135.962, 0.001);
    EXPECT_NEAR(p1.toHp(), 134.102, 0.001);

    auto p2 = Power::fromPs(135.962);
    EXPECT_NEAR(p2.toKw(), 100.0, 0.01);

    auto p3 = Power::fromHp(134.102);
    EXPECT_NEAR(p3.toKw(), 100.0, 0.01);
}

TEST(PowerTest, Comparison) {
    auto pow1 = Power::fromKw(50.0);
    auto pow2 = Power::fromKw(50.0);
    auto pow3 = Power::fromKw(80.0);

    EXPECT_TRUE(pow1 == pow2);
    EXPECT_TRUE(pow1 != pow3);
    EXPECT_TRUE(pow1 < pow3);
}

TEST(PowerTest, invalid) {
    EXPECT_THROW(Power::fromKw(-1.0), std::invalid_argument);
    EXPECT_THROW(Power::fromKw(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Power::fromKw(std::numeric_limits<double>::infinity()), std::invalid_argument);

    EXPECT_THROW(Power::fromPs(-1.0), std::invalid_argument);
    EXPECT_THROW(Power::fromPs(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Power::fromPs(std::numeric_limits<double>::infinity()), std::invalid_argument);

    EXPECT_THROW(Power::fromHp(-1.0), std::invalid_argument);
    EXPECT_THROW(Power::fromHp(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Power::fromHp(std::numeric_limits<double>::infinity()), std::invalid_argument);

    EXPECT_NO_THROW(Power::fromKw(0.0));
}

TEST(PowerTest, OstreamOperator) {
    auto p = Power::fromKw(75.0);
    std::ostringstream oss;
    oss << p;
    EXPECT_EQ(oss.str(), "75 kW");
}


// --- test case for torque

TEST(TorqueTest, NmToNm) {
    auto t = Torque::fromNm(10.0);
    EXPECT_DOUBLE_EQ(t.toNm(), 10.0);
}

TEST(TorqueTest, KgfmToNm) {
    auto t = Torque::fromKgfm(10.0);
    EXPECT_NEAR(t.toKgfm(), 10.0, 0.0001);
    EXPECT_NEAR(t.toNm(), 98.0665, 0.0001);
}

TEST(TorqueTest, LbftToLbft) {
    auto t = Torque::fromLbft(1.0);
    EXPECT_NEAR(t.toLbft(), 1.0, 0.0001);
}

TEST(TorqueTest, Comparison) {
    auto t1 = Torque::fromNm(100.0);
    auto t2 = Torque::fromNm(100.0);
    auto t3 = Torque::fromNm(150.0);

    EXPECT_TRUE(t1 == t2);
    EXPECT_TRUE(t1 != t3);
    EXPECT_TRUE(t1 < t3);
}

TEST(TorqueTest, invalid) {
    EXPECT_THROW(Torque::fromNm(-1.0), std::invalid_argument);
    EXPECT_THROW(Torque::fromNm(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Torque::fromNm(std::numeric_limits<double>::infinity()), std::invalid_argument);

    EXPECT_THROW(Torque::fromKgfm(-1.0), std::invalid_argument);
    EXPECT_THROW(Torque::fromKgfm(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Torque::fromKgfm(std::numeric_limits<double>::infinity()), std::invalid_argument);

    EXPECT_THROW(Torque::fromLbft(-1.0), std::invalid_argument);
    EXPECT_THROW(Torque::fromLbft(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Torque::fromLbft(std::numeric_limits<double>::infinity()), std::invalid_argument);

    EXPECT_NO_THROW(Torque::fromNm(0.0));
}

TEST(TorqueTest, OstreamOperator) {
    auto t = Torque::fromNm(250.0);
    std::ostringstream oss;
    oss << t;
    EXPECT_EQ(oss.str(), "250 Nm");
}


// -- test case for Angle

TEST(AngleTest, DegreesToRadians) {
    auto a = Angle::fromDegrees(180.0);
    EXPECT_NEAR(a.toDegrees(), 180.0, 0.000001);
    EXPECT_NEAR(a.toRadians(), 3.1415926535, 0.000001);
}

TEST(AngleTest, RadiansToDegrees) {
    auto a = Angle::fromRadians(1.5707963268);
    EXPECT_NEAR(a.toRadians(), 1.5707963268, 0.000001);
    EXPECT_NEAR(a.toDegrees(), 90.0, 0.000001);
}

TEST(AngleTest, ValidationAndNormalization) {
    EXPECT_THROW(Angle::fromRadians(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Angle::fromDegrees(std::numeric_limits<double>::infinity()), std::invalid_argument);

    auto a1 = Angle::fromDegrees(370.0).normalized();
    EXPECT_NEAR(a1.toDegrees(), 10.0, 0.0001);

    auto a2 = Angle::fromDegrees(-90.0).normalized();
    EXPECT_NEAR(a2.toDegrees(), 270.0, 0.0001);

    auto a3 = Angle::fromDegrees(270.0).normalizedSigned();
    EXPECT_NEAR(a3.toDegrees(), -90.0, 0.0001);
}

TEST(AngleTest, Comparison) {
    auto a1 = Angle::fromDegrees(45.0);
    auto a2 = Angle::fromDegrees(45.0);
    auto a3 = Angle::fromDegrees(90.0);

    EXPECT_TRUE(a1 == a2);
    EXPECT_TRUE(a1 != a3);
    EXPECT_TRUE(a1 < a3);
}

TEST(AngleTest, OstreamOperator) {
    auto a = Angle::fromRadians(1.0);
    std::ostringstream oss;
    oss << a;
    EXPECT_EQ(oss.str(), "1 rad");
}


// -- test case for Efficiency

TEST(EfficiencyTest, L100kmToKml) {
    auto e = Efficiency::fromL100km(10.0);
    EXPECT_DOUBLE_EQ(e.toL100km(), 10.0);
    EXPECT_DOUBLE_EQ(e.toKml(), 10.0);
}

TEST(EfficiencyTest, MpgToKml) {
    auto e = Efficiency::fromMpg(23.5215);
    EXPECT_NEAR(e.toMpg(), 23.5215, 0.001);
    EXPECT_NEAR(e.toKml(), 10.0, 0.001);
}

TEST(EfficiencyTest, KmlToL100andMPG) {
    auto e = Efficiency::fromKml(10.0);
    EXPECT_DOUBLE_EQ(e.toKml(), 10.0);
    EXPECT_DOUBLE_EQ(e.toL100km(), 10.0);
    EXPECT_NEAR(e.toMpg(), 23.5215, 0.001);
}

TEST(EfficiencyTest, Comparison) {
    auto e1 = Efficiency::fromKml(12.0);
    auto e2 = Efficiency::fromKml(12.0);
    auto e3 = Efficiency::fromKml(15.0);

    EXPECT_TRUE(e1 == e2);
    EXPECT_TRUE(e1 != e3);
    EXPECT_TRUE(e1 < e3);
}

TEST(EfficiencyTest, EfficiencyFactoryException) {
    EXPECT_THROW(Efficiency::fromKml(0.0), std::invalid_argument);
    EXPECT_THROW(Efficiency::fromKml(-1.0), std::invalid_argument);
    EXPECT_THROW(Efficiency::fromL100km(-5.0), std::invalid_argument);

    EXPECT_THROW(Efficiency::fromKml(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Efficiency::fromL100km(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Efficiency::fromMpg(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Efficiency::fromKml(std::numeric_limits<double>::infinity()), std::invalid_argument);
    EXPECT_THROW(Efficiency::fromL100km(std::numeric_limits<double>::infinity()), std::invalid_argument);
    EXPECT_THROW(Efficiency::fromMpg(std::numeric_limits<double>::infinity()), std::invalid_argument);
}

TEST(EfficiencyTest, OstreamOperator) {
    auto e = Efficiency::fromKml(15.0);
    std::ostringstream oss;
    oss << e;
    EXPECT_EQ(oss.str(), "15 km/L");
}


// --- test case for EvEfficiency

TEST(EvEfficiencyTest, fromKmkWh) {
    auto e = EvEfficiency::fromKmkWh(6.0);
    EXPECT_DOUBLE_EQ(e.toKmkWh(), 6.0);
    EXPECT_NEAR(e.toWhkm(), 166.666, 0.001);
    EXPECT_NEAR(e.toKwh100km(), 16.666, 0.001);
    EXPECT_NEAR(e.toMpKwh(), 3.728, 0.001);
}

TEST(EvEfficiencyTest, fromWhkm) {
    auto e = EvEfficiency::fromWhkm(200.0);
    EXPECT_NEAR(e.toWhkm(), 200.0, 0.001);
    EXPECT_NEAR(e.toKmkWh(), 5.0, 0.01);
    EXPECT_NEAR(e.toKwh100km(), 20.0, 0.01);
    EXPECT_NEAR(e.toMpKwh(), 3.11, 0.01);
}

TEST(EvEfficiencyTest, fromKwh100km) {
    auto e = EvEfficiency::fromKwh100km(20.0);
    EXPECT_NEAR(e.toKwh100km(), 20.0, 0.1);
    EXPECT_DOUBLE_EQ(e.toKmkWh(), 5.0);
    EXPECT_NEAR(e.toWhkm(), 200.0, 0.001);
    EXPECT_NEAR(e.toMpKwh(), 3.11, 0.01);
}

TEST(EvEfficiencyTest, fromMpKwh) {
    auto e = EvEfficiency::fromMpKwh(1.0);
    EXPECT_NEAR(e.toMpKwh(), 1.0, 0.1);
    EXPECT_NEAR(e.toKmkWh(), 1.609344, 0.000001);
}

TEST(EvEfficiencyTest, Comparison) {
    auto e1 = EvEfficiency::fromKmkWh(5.0);
    auto e2 = EvEfficiency::fromKmkWh(5.0);
    auto e3 = EvEfficiency::fromKmkWh(7.0);

    EXPECT_TRUE(e1 == e2);
    EXPECT_TRUE(e1 != e3);
    EXPECT_TRUE(e1 < e3);
}

TEST(EvEfficiencyTest, invalid) {
    EXPECT_THROW(EvEfficiency::fromKmkWh(0.0), std::invalid_argument);
    EXPECT_THROW(EvEfficiency::fromWhkm(-1.0), std::invalid_argument);
    EXPECT_THROW(EvEfficiency::fromWhkm(0.0), std::invalid_argument);

    EXPECT_THROW(EvEfficiency::fromKmkWh(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(EvEfficiency::fromKmkWh(std::numeric_limits<double>::infinity()), std::invalid_argument);
}

TEST(EvEfficiencyTest, OstreamOperator) {
    auto e = EvEfficiency::fromKmkWh(6.5);
    std::ostringstream oss;
    oss << e;
    EXPECT_EQ(oss.str(), "6.5 km/kWh");
}


// --- test case for Volume

TEST(VolumeTest, VolumeFromLiters) {
    auto v = Volume::fromLiters(1.0);
    EXPECT_DOUBLE_EQ(v.toLiters(), 1.0);
    EXPECT_DOUBLE_EQ(v.toMl(), 1000.0);
    EXPECT_NEAR(v.toUsGallons(), 0.264172, 0.000001);
    EXPECT_NEAR(v.toImpGallons(), 0.219969, 0.000001);
}

TEST(VolumeTest, VolumeFromMl) {
    auto v = Volume::fromMl(500.0);
    EXPECT_DOUBLE_EQ(v.toMl(), 500.0);
    EXPECT_DOUBLE_EQ(v.toLiters(), 0.5);
    EXPECT_NEAR(v.toUsGallons(), 0.132086, 0.000001);
    EXPECT_NEAR(v.toImpGallons(), 0.1099845, 0.000001);
}

TEST(VolumeTest, VolumeFromUsGallons) {
    auto v = Volume::fromUsGallons(10.0);
    EXPECT_NEAR(v.toUsGallons(), 10.0, 0.0001);
    EXPECT_NEAR(v.toLiters(), 37.8541, 0.0001);
    EXPECT_NEAR(v.toMl(), 37854.1, 0.1);
    EXPECT_NEAR(v.toImpGallons(), 8.32674, 0.00001);
}

TEST(VolumeTest, VolumeFromImpGallons) {
    auto v = Volume::fromImpGallons(10.0);
    EXPECT_NEAR(v.toImpGallons(), 10.0, 1e-9);
    EXPECT_NEAR(v.toUsGallons(), 12.0095, 0.0001);
    EXPECT_NEAR(v.toLiters(), 45.4609, 0.0001);
    EXPECT_NEAR(v.toMl(), 45460.9, 0.1);
}

TEST(VolumeTest, Comparison) {
    auto v1 = Volume::fromLiters(5.0);
    auto v2 = Volume::fromLiters(5.0);
    auto v3 = Volume::fromLiters(10.0);

    EXPECT_TRUE(v1 == v2);
    EXPECT_TRUE(v1 != v3);
    EXPECT_TRUE(v1 < v3);
}

TEST(VolumeTest, Invalid) {
    EXPECT_THROW(Volume::fromLiters(-1.0), std::invalid_argument);
    EXPECT_THROW(Volume::fromMl(-100.0), std::invalid_argument);
    EXPECT_THROW(Volume::fromUsGallons(-1.0), std::invalid_argument);

    EXPECT_THROW(Volume::fromLiters(std::numeric_limits<double>::quiet_NaN()), std::invalid_argument);
    EXPECT_THROW(Volume::fromLiters(std::numeric_limits<double>::infinity()), std::invalid_argument);

    EXPECT_NO_THROW(Volume::fromLiters(0.0));
}

TEST(VolumeTest, OstreamOperator) {
    auto v = Volume::fromLiters(2.0);
    std::ostringstream oss;
    oss << v;
    EXPECT_EQ(oss.str(), "2 L");
}


// --- test case for Time

TEST(TimeTest, ConversionMatrix) {
    auto t1 = Time::fromSeconds(60.0);
    EXPECT_NEAR(t1.toSeconds(), 60.0, 1e-9);
    EXPECT_NEAR(t1.toMinutes(), 1.0, 1e-9);
    EXPECT_NEAR(t1.toHours(), 1.0/60.0, 1e-9);

    auto t2 = Time::fromMinutes(1.0);
    EXPECT_NEAR(t2.toSeconds(), 60.0, 1e-9);
    EXPECT_NEAR(t2.toMinutes(), 1.0, 1e-9);
    EXPECT_NEAR(t2.toHours(), 1.0/60.0, 1e-9);

    auto t3 = Time::fromHours(1.0/60.0);
    EXPECT_NEAR(t3.toSeconds(), 60.0, 1e-9);
    EXPECT_NEAR(t3.toMinutes(), 1.0, 1e-9);
    EXPECT_NEAR(t3.toHours(), 1.0/60.0, 1e-9);

    EXPECT_NO_THROW(Time::fromSeconds(0.0));
    EXPECT_NO_THROW(Time::fromMinutes(0.0));
    EXPECT_NO_THROW(Time::fromHours(0.0));
}

TEST(TimeTest, Comparison) {
    auto t1 = Time::fromSeconds(30.0);
    auto t2 = Time::fromSeconds(30.0);
    auto t3 = Time::fromSeconds(60.0);

    EXPECT_TRUE(t1 == t2);
    EXPECT_TRUE(t1 != t3);
    EXPECT_TRUE(t1 < t3);
}

TEST(TimeTest, exception) {
    EXPECT_THROW(Time::fromSeconds(NAN), std::invalid_argument);
    EXPECT_THROW(Time::fromSeconds(-1.0), std::invalid_argument);
    EXPECT_THROW(Time::fromSeconds(INFINITY), std::invalid_argument);

    EXPECT_THROW(Time::fromMinutes(NAN), std::invalid_argument);
    EXPECT_THROW(Time::fromMinutes(-1.0), std::invalid_argument);
    EXPECT_THROW(Time::fromMinutes(INFINITY), std::invalid_argument);

    EXPECT_THROW(Time::fromHours(NAN), std::invalid_argument);
    EXPECT_THROW(Time::fromHours(-1.0), std::invalid_argument);
    EXPECT_THROW(Time::fromHours(INFINITY), std::invalid_argument);
}

TEST(TimeTest, OstreamOperator) {
    auto t = Time::fromSeconds(30.0);
    std::ostringstream oss;
    oss << t;
    EXPECT_EQ(oss.str(), "30 s");
}


// --- test case for Acceleration

TEST(AccelerationTest, FullCoverage) {
    auto a = Acceleration::fromMs2(9.8);
    auto s = a * Time::fromSeconds(2.0);
    EXPECT_NEAR(s.toMs(), 19.6, 1e-9);

    EXPECT_NO_THROW(Acceleration::fromMs2(0.0));

    EXPECT_THROW(Acceleration::fromMs2(NAN), std::invalid_argument);
    EXPECT_THROW(a * Time::fromSeconds(-1.0), std::invalid_argument);
}

TEST(AccelerationTest, Comparison) {
    auto a1 = Acceleration::fromMs2(5.0);
    auto a2 = Acceleration::fromMs2(5.0);
    auto a3 = Acceleration::fromMs2(10.0);

    EXPECT_TRUE(a1 == a2);
    EXPECT_TRUE(a1 != a3);
    EXPECT_TRUE(a1 < a3);
}

TEST(AccelerationTest, DerivedFromDeltaSpeed) {
    auto v1 = Speed::fromMs(20.0);
    auto v2 = Speed::fromMs(0.0);
    auto t = Time::fromSeconds(5.0);
    auto a = (v1 - v2) / t;
    EXPECT_NEAR(a.toMs2(), 4.0, 1e-9);

    EXPECT_THROW((v1 - v2) / Time::fromSeconds(0.0), std::invalid_argument);
}

TEST(AccelerationTest, OstreamOperator) {
    auto a = Acceleration::fromMs2(9.81);
    std::ostringstream oss;
    oss << a;
    EXPECT_EQ(oss.str(), "9.81 m/s^2");
}


// --- test case for cross operation

TEST(PhysicsOpsTest, AccelMulTime) {
    auto speed = Speed::fromKmH(100.0);
    auto time = Time::fromSeconds(9.5);
    auto accel = Acceleration::fromSpeedAndTime(speed, time);
    EXPECT_NEAR(accel.toMs2(), 2.9239, 1e-4);
}

TEST(PhysicsOpsTest, SpeedMulTime) {
    auto d = Speed::fromMs(10.0) * Time::fromSeconds(5.0);
    EXPECT_NEAR(d.toMeters(), 50.0, 1e-9);

    EXPECT_THROW(Speed::fromMs(10.0) * Time::fromSeconds(-1.0), std::invalid_argument);
}

TEST(PhysicsOpsTest, VelocityChange) {
    auto v = Speed::fromMs(10.0);
    auto v_delta = Acceleration::fromMs2(2.0) * Time::fromSeconds(5.0);
    auto v2 = v + v_delta;
    EXPECT_NEAR(v2.toMs(), 20.0, 1e-9);
}

TEST(ScalarOpsTest, ScalarMultiplication) {
    auto v = Speed::fromMs(10.0) * 0.5;
    EXPECT_NEAR(v.toMs(), 5.0, 1e-9);
    EXPECT_NEAR((Speed::fromMs(10.0) * 0.0).toMs(), 0.0, 1e-9);
}

TEST(AccelerationTest, ScalarMultiplication) {
    auto a = Acceleration::fromMs2(9.8) * 0.5;
    EXPECT_NEAR(a.toMs2(), 4.9, 1e-9);
    
    auto zero = Acceleration::fromMs2(9.8) * 0.0;
    EXPECT_NEAR(zero.toMs2(), 0.0, 1e-9);
}

TEST(PhysicsOpsTest, DistanceDivTimeEqualsSpeed) {
    auto d = Distance::fromMeters(100.0);
    auto t = Time::fromSeconds(10.0);
    auto speed = d / t;
    EXPECT_NEAR(speed.toMs(), 10.0, 1e-9);

    EXPECT_THROW(d / Time::fromSeconds(0.0), std::invalid_argument);
}

TEST(PhysicsOpsTest, DistanceDivSpeedEqualsTime) {
    auto d = Distance::fromMeters(100.0);
    auto s = Speed::fromMs(20.0);
    auto time = d / s;
    EXPECT_NEAR(time.toSeconds(), 5.0, 1e-9);

    EXPECT_THROW(d / Speed::fromMs(0.0), std::invalid_argument);
}

TEST(PhysicsOpsTest, ArithmeticOperationsAddSub) {
    auto v1 = Speed::fromMs(30.0);
    auto v2 = Speed::fromMs(10.0);
    EXPECT_NEAR((v1 - v2).toMs(), 20.0, 1e-9);
    EXPECT_NEAR((v1 + v2).toMs(), 40.0, 1e-9);

    auto d1 = Distance::fromMeters(150.0);
    auto d2 = Distance::fromMeters(50.0);
    EXPECT_NEAR((d1 - d2).toMeters(), 100.0, 1e-9);
    EXPECT_NEAR((d1 + d2).toMeters(), 200.0, 1e-9);

    auto t1 = Time::fromSeconds(40.0);
    auto t2 = Time::fromSeconds(15.0);
    EXPECT_NEAR((t1 - t2).toSeconds(), 25.0, 1e-9);
    EXPECT_NEAR((t1 + t2).toSeconds(), 55.0, 1e-9);
}

TEST(ScalarOpsTest, SymmetricMultiplication) {
    auto v = 2.0 * Speed::fromMs(5.0);
    EXPECT_NEAR(v.toMs(), 10.0, 1e-9);

    auto d = 3.0 * Distance::fromMeters(10.0);
    EXPECT_NEAR(d.toMeters(), 30.0, 1e-9);

    auto a = 1.5 * Acceleration::fromMs2(2.0);
    EXPECT_NEAR(a.toMs2(), 3.0, 1e-9);
}


TEST(PhysicsOpsTest, TimeMulScalar) {
    auto t = Time::fromSeconds(10.0) * 2.5;
    EXPECT_NEAR(t.toSeconds(), 25.0, 1e-9);

    auto t_sym = 3.0 * Time::fromSeconds(4.0);
    EXPECT_NEAR(t_sym.toSeconds(), 12.0, 1e-9);
}

TEST(PhysicsOpsTest, SpeedDivAccelerationEqualsTime) {
    auto s = Speed::fromMs(20.0);
    auto a = Acceleration::fromMs2(4.0);
    auto t = s / a;
    EXPECT_NEAR(t.toSeconds(), 5.0, 1e-9);

    EXPECT_THROW(s / Acceleration::fromMs2(0.0), std::invalid_argument);
}

TEST(PhysicsOpsTest, TimeDivAccelerationEqualsSpeed) {
    auto t = Time::fromSeconds(10.0);
    auto a = Acceleration::fromMs2(2.0);
    auto s = t / a;
    EXPECT_NEAR(s.toMs(), 5.0, 1e-9);

    EXPECT_THROW(t / Acceleration::fromMs2(0.0), std::invalid_argument);
}

// --- Comprehensive Same-Dimension Division & Ratio Checks ---

TEST(PhysicsOpsTest, SameDimensionDivisionRatio) {
    // Distance / Distance
    auto d1 = Distance::fromMeters(250.0);
    auto d2 = Distance::fromMeters(50.0);
    EXPECT_NEAR(d1 / d2, 5.0, 1e-9);
    EXPECT_THROW(d1 / Distance::fromMeters(0.0), std::invalid_argument);

    // Mass / Mass
    auto m1 = Mass::fromKg(10.0);
    auto m2 = Mass::fromKg(2.0);
    EXPECT_NEAR(m1 / m2, 5.0, 1e-9);
    EXPECT_THROW(m1 / Mass::fromKg(0.0), std::invalid_argument);

    // Speed / Speed
    auto s1 = Speed::fromMs(60.0);
    auto s2 = Speed::fromMs(15.0);
    EXPECT_NEAR(s1 / s2, 4.0, 1e-9);
    EXPECT_THROW(s1 / Speed::fromMs(0.0), std::invalid_argument);

    // Time / Time
    auto t1 = Time::fromSeconds(120.0);
    auto t2 = Time::fromSeconds(30.0);
    EXPECT_NEAR(t1 / t2, 4.0, 1e-9);
    EXPECT_THROW(t1 / Time::fromSeconds(0.0), std::invalid_argument);

    // Pressure / Pressure
    auto p1 = Pressure::fromKpa(200.0);
    auto p2 = Pressure::fromKpa(50.0);
    EXPECT_NEAR(p1 / p2, 4.0, 1e-9);
    EXPECT_THROW(p1 / Pressure::fromKpa(0.0), std::invalid_argument);

    // Power / Power
    auto pow1 = Power::fromKw(150.0);
    auto pow2 = Power::fromKw(30.0);
    EXPECT_NEAR(pow1 / pow2, 5.0, 1e-9);
    EXPECT_THROW(pow1 / Power::fromKw(0.0), std::invalid_argument);

    // Torque / Torque
    auto tr1 = Torque::fromNm(100.0);
    auto tr2 = Torque::fromNm(25.0);
    EXPECT_NEAR(tr1 / tr2, 4.0, 1e-9);
    EXPECT_THROW(tr1 / Torque::fromNm(0.0), std::invalid_argument);

    // Angle / Angle
    auto ang1 = Angle::fromDegrees(180.0);
    auto ang2 = Angle::fromDegrees(45.0);
    EXPECT_NEAR(ang1 / ang2, 4.0, 1e-9);
    EXPECT_THROW(ang1 / Angle::fromDegrees(0.0), std::invalid_argument);


    // Acceleration / Acceleration
    auto a1 = Acceleration::fromMs2(12.0);
    auto a2 = Acceleration::fromMs2(3.0);
    EXPECT_NEAR(a1 / a2, 4.0, 1e-9);
    EXPECT_THROW(a1 / Acceleration::fromMs2(0.0), std::invalid_argument);

    // Efficiency / Efficiency
    auto e1 = Efficiency::fromKml(20.0);
    auto e2 = Efficiency::fromKml(5.0);
    EXPECT_NEAR(e1 / e2, 4.0, 1e-9);

    // EvEfficiency / EvEfficiency
    auto ev1 = EvEfficiency::fromKmkWh(8.0);
    auto ev2 = EvEfficiency::fromKmkWh(2.0);
    EXPECT_NEAR(ev1 / ev2, 4.0, 1e-9);

    // Volume / Volume
    auto vol1 = Volume::fromLiters(20.0);
    auto vol2 = Volume::fromLiters(5.0);
    EXPECT_NEAR(vol1 / vol2, 4.0, 1e-9);
    EXPECT_THROW(vol1 / Volume::fromLiters(0.0), std::invalid_argument);
}
// --- same-dimension arithmetic operations

TEST(ArithmeticTest, AccelerationAddSub) {
    auto a1 = Acceleration::fromMs2(10.0);
    auto a2 = Acceleration::fromMs2(3.0);

    EXPECT_NEAR((a1 + a2).toMs2(), 13.0, 1e-9);
    EXPECT_NEAR((a1 - a2).toMs2(), 7.0, 1e-9);

    EXPECT_NO_THROW(a1 + a2);
    EXPECT_NO_THROW(a1 - a2);
}

TEST(ArithmeticTest, PressureAddSub) {
    auto p1 = Pressure::fromKpa(200.0);
    auto p2 = Pressure::fromKpa(50.0);

    EXPECT_NEAR((p1 + p2).toKpa(), 250.0, 1e-9);
    EXPECT_NEAR((p1 - p2).toKpa(), 150.0, 1e-9);

    EXPECT_THROW(Pressure::fromKpa(50.0) - Pressure::fromKpa(100.0),
                 std::invalid_argument);
}

TEST(rithmeticTest, PowerAddSub) {
    auto p1 = Power::fromKw(100.0);
    auto p2 = Power::fromKw(25.0);

    EXPECT_NEAR((p1 + p2).toKw(), 125.0, 1e-9);
    EXPECT_NEAR((p1 - p2).toKw(), 75.0, 1e-9);

    EXPECT_THROW(Power::fromKw(25.0) - Power::fromKw(50.0),
                 std::invalid_argument);
}

TEST(ArithmeticTest, TorqueAddSub) {
    auto t1 = Torque::fromNm(100.0);
    auto t2 = Torque::fromNm(25.0);

    EXPECT_NEAR((t1 + t2).toNm(), 125.0, 1e-9);
    EXPECT_NEAR((t1 - t2).toNm(), 75.0, 1e-9);

    EXPECT_THROW(Torque::fromNm(25.0) - Torque::fromNm(50.0),
                 std::invalid_argument);
}

TEST(ArithmeticTest, AngleAddSub) {
    auto a1 = Angle::fromDegrees(120.0);
    auto a2 = Angle::fromDegrees(30.0);

    EXPECT_NEAR((a1 + a2).toDegrees(), 150.0, 1e-9);
    EXPECT_NEAR((a1 - a2).toDegrees(), 90.0, 1e-9);
}

TEST(ArithmeticTest, VolumeAddSub) {
    auto v1 = Volume::fromLiters(10.0);
    auto v2 = Volume::fromLiters(2.5);

    EXPECT_NEAR((v1 + v2).toLiters(), 12.5, 1e-9);
    EXPECT_NEAR((v1 - v2).toLiters(), 7.5, 1e-9);

    EXPECT_THROW(Volume::fromLiters(2.0) - Volume::fromLiters(5.0),
                 std::invalid_argument);
}


// --- compound assignment

TEST(CompoundAssignmentTest, SpeedAddSubAssign) {
    auto speed = Speed::fromMs(10.0);

    speed += Speed::fromMs(5.0);
    EXPECT_NEAR(speed.toMs(), 15.0, 1e-9);

    speed -= Speed::fromMs(3.0);
    EXPECT_NEAR(speed.toMs(), 12.0, 1e-9);

    EXPECT_THROW(speed -= Speed::fromMs(20.0), std::invalid_argument);
}

TEST(CompoundAssignmentTest, DistanceAddSubAssign) {
    auto distance = Distance::fromMeters(100.0);

    distance += Distance::fromMeters(50.0);
    EXPECT_NEAR(distance.toMeters(), 150.0, 1e-9);

    distance -= Distance::fromMeters(25.0);
    EXPECT_NEAR(distance.toMeters(), 125.0, 1e-9);

    EXPECT_THROW(distance -= Distance::fromMeters(200.0), std::invalid_argument);
}

TEST(CompoundAssignmentTest, TimeAddSubAssign) {
    auto time = Time::fromSeconds(60.0);

    time += Time::fromSeconds(30.0);
    EXPECT_NEAR(time.toSeconds(), 90.0, 1e-9);

    time -= Time::fromSeconds(10.0);
    EXPECT_NEAR(time.toSeconds(), 80.0, 1e-9);

    EXPECT_THROW(time -= Time::fromSeconds(100.0), std::invalid_argument);
}

TEST(CompoundAssignmentTest, MassAddSubAssign) {
    auto mass = Mass::fromKg(10.0);

    mass += Mass::fromKg(5.0);
    EXPECT_NEAR(mass.toKg(), 15.0, 1e-9);

    mass -= Mass::fromKg(3.0);
    EXPECT_NEAR(mass.toKg(), 12.0, 1e-9);

    EXPECT_THROW(mass -= Mass::fromKg(20.0), std::invalid_argument);
}

TEST(CompoundAssignmentTest, AccelerationAddSubAssign) {
    auto acceleration = Acceleration::fromMs2(10.0);

    acceleration += Acceleration::fromMs2(5.0);
    EXPECT_NEAR(acceleration.toMs2(), 15.0, 1e-9);

    acceleration -= Acceleration::fromMs2(3.0);
    EXPECT_NEAR(acceleration.toMs2(), 12.0, 1e-9);

    // Acceleration permits signed values, so negative results are valid.
    acceleration -= Acceleration::fromMs2(20.0);
    EXPECT_NEAR(acceleration.toMs2(), -8.0, 1e-9);
}

TEST(CompoundAssignmentTest, PressureAddSubAssign) {
    auto pressure = Pressure::fromKpa(100.0);

    pressure += Pressure::fromKpa(25.0);
    EXPECT_NEAR(pressure.toKpa(), 125.0, 1e-9);

    pressure -= Pressure::fromKpa(25.0);
    EXPECT_NEAR(pressure.toKpa(), 100.0, 1e-9);

    EXPECT_THROW(pressure -= Pressure::fromKpa(150.0), std::invalid_argument);
}

TEST(CompoundAssignmentTest, PowerAddSubAssign) {
    auto power = Power::fromKw(100.0);

    power += Power::fromKw(20.0);
    EXPECT_NEAR(power.toKw(), 120.0, 1e-9);

    power -= Power::fromKw(20.0);
    EXPECT_NEAR(power.toKw(), 100.0, 1e-9);

    EXPECT_THROW(power -= Power::fromKw(150.0), std::invalid_argument);
}

TEST(CompoundAssignmentTest, TorqueAddSubAssign) {
    auto torque = Torque::fromNm(100.0);

    torque += Torque::fromNm(20.0);
    EXPECT_NEAR(torque.toNm(), 120.0, 1e-9);

    torque -= Torque::fromNm(20.0);
    EXPECT_NEAR(torque.toNm(), 100.0, 1e-9);

    EXPECT_THROW(torque -= Torque::fromNm(150.0), std::invalid_argument);
}

TEST(CompoundAssignmentTest, AngleAddSubAssign) {
    auto angle = Angle::fromDegrees(100.0);

    angle += Angle::fromDegrees(20.0);
    EXPECT_NEAR(angle.toDegrees(), 120.0, 1e-9);

    angle -= Angle::fromDegrees(30.0);
    EXPECT_NEAR(angle.toDegrees(), 90.0, 1e-9);

    // Angle itself can be negative; normalization is a separate operation.
    angle -= Angle::fromDegrees(120.0);
    EXPECT_NEAR(angle.toDegrees(), -30.0, 1e-9);
}

TEST(CompoundAssignmentTest, VolumeAddSubAssign) {
    auto volume = Volume::fromLiters(10.0);

    volume += Volume::fromLiters(2.0);
    EXPECT_NEAR(volume.toLiters(), 12.0, 1e-9);

    volume -= Volume::fromLiters(5.0);
    EXPECT_NEAR(volume.toLiters(), 7.0, 1e-9);

    EXPECT_THROW(volume -= Volume::fromLiters(10.0), std::invalid_argument);
}


// --- Tier 2 test cases: scalar operations

TEST(Tier2ScalarOpsTest, PressureScalarOperations) {
    auto p = Pressure::fromKpa(100.0);

    EXPECT_NEAR((p * 2.0).toKpa(), 200.0, 1e-9);
    EXPECT_NEAR((2.0 * p).toKpa(), 200.0, 1e-9);
    EXPECT_NEAR((p / 2.0).toKpa(), 50.0, 1e-9);

    EXPECT_THROW(p / 0.0, std::invalid_argument);
    EXPECT_THROW((p * -1.0).toKpa(), std::invalid_argument);
}

TEST(Tier2ScalarOpsTest, PowerScalarOperations) {
    auto p = Power::fromKw(100.0);

    EXPECT_NEAR((p * 2.0).toKw(), 200.0, 1e-9);
    EXPECT_NEAR((2.0 * p).toKw(), 200.0, 1e-9);
    EXPECT_NEAR((p / 2.0).toKw(), 50.0, 1e-9);

    EXPECT_THROW(p / 0.0, std::invalid_argument);
    EXPECT_THROW((p * -1.0).toKw(), std::invalid_argument);
}

TEST(Tier2ScalarOpsTest, TorqueScalarOperations) {
    auto t = Torque::fromNm(100.0);

    EXPECT_NEAR((t * 2.0).toNm(), 200.0, 1e-9);
    EXPECT_NEAR((2.0 * t).toNm(), 200.0, 1e-9);
    EXPECT_NEAR((t / 2.0).toNm(), 50.0, 1e-9);

    EXPECT_THROW(t / 0.0, std::invalid_argument);
    EXPECT_THROW((t * -1.0).toNm(), std::invalid_argument);
}

TEST(Tier2ScalarOpsTest, AngleScalarOperations) {
    auto a = Angle::fromDegrees(30.0);

    EXPECT_NEAR((a * 2.0).toDegrees(), 60.0, 1e-9);
    EXPECT_NEAR((2.0 * a).toDegrees(), 60.0, 1e-9);
    EXPECT_NEAR((a / 2.0).toDegrees(), 15.0, 1e-9);

    EXPECT_THROW(a / 0.0, std::invalid_argument);
}

TEST(Tier2ScalarOpsTest, VolumeScalarOperations) {
    auto v = Volume::fromLiters(10.0);

    EXPECT_NEAR((v * 2.0).toLiters(), 20.0, 1e-9);
    EXPECT_NEAR((2.0 * v).toLiters(), 20.0, 1e-9);
    EXPECT_NEAR((v / 2.0).toLiters(), 5.0, 1e-9);

    EXPECT_THROW(v / 0.0, std::invalid_argument);
    EXPECT_THROW((v * -1.0).toLiters(), std::invalid_argument);
}

TEST(Tier2ScalarOpsTest, EfficiencyScalarOperations) {
    auto e = Efficiency::fromKml(10.0);

    EXPECT_NEAR((e * 2.0).toKml(), 20.0, 1e-9);
    EXPECT_NEAR((2.0 * e).toKml(), 20.0, 1e-9);
    EXPECT_NEAR((e / 2.0).toKml(), 5.0, 1e-9);

    EXPECT_THROW(e / 0.0, std::invalid_argument);
    EXPECT_THROW((e * -1.0).toKml(), std::invalid_argument);
}

TEST(Tier2ScalarOpsTest, EvEfficiencyScalarOperations) {
    auto e = EvEfficiency::fromKmkWh(10.0);

    EXPECT_NEAR((e * 2.0).toKmkWh(), 20.0, 1e-9);
    EXPECT_NEAR((2.0 * e).toKmkWh(), 20.0, 1e-9);
    EXPECT_NEAR((e / 2.0).toKmkWh(), 5.0, 1e-9);

    EXPECT_THROW(e / 0.0, std::invalid_argument);
    EXPECT_THROW((e * -1.0).toKmkWh(), std::invalid_argument);
}


// --- Tier 2 test cases: scalar compound assignment

TEST(Tier2ScalarCompoundAssignmentTest, Speed) {
    auto speed = Speed::fromMs(10.0);

    speed *= 2.0;
    EXPECT_NEAR(speed.toMs(), 20.0, 1e-9);

    speed /= 4.0;
    EXPECT_NEAR(speed.toMs(), 5.0, 1e-9);

    EXPECT_THROW(speed /= 0.0, std::invalid_argument);
    EXPECT_THROW(speed *= -1.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, Distance) {
    auto distance = Distance::fromMeters(10.0);

    distance *= 3.0;
    EXPECT_NEAR(distance.toMeters(), 30.0, 1e-9);

    distance /= 2.0;
    EXPECT_NEAR(distance.toMeters(), 15.0, 1e-9);

    EXPECT_THROW(distance /= 0.0, std::invalid_argument);
    EXPECT_THROW(distance *= -1.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, Acceleration) {
    auto acceleration = Acceleration::fromMs2(10.0);

    acceleration *= 2.0;
    EXPECT_NEAR(acceleration.toMs2(), 20.0, 1e-9);

    acceleration /= 4.0;
    EXPECT_NEAR(acceleration.toMs2(), 5.0, 1e-9);

    acceleration *= -2.0;
    EXPECT_NEAR(acceleration.toMs2(), -10.0, 1e-9);

    EXPECT_THROW(acceleration /= 0.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, Time) {
    auto time = Time::fromSeconds(10.0);

    time *= 3.0;
    EXPECT_NEAR(time.toSeconds(), 30.0, 1e-9);

    time /= 2.0;
    EXPECT_NEAR(time.toSeconds(), 15.0, 1e-9);

    EXPECT_THROW(time /= 0.0, std::invalid_argument);
    EXPECT_THROW(time *= -1.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, Mass) {
    auto mass = Mass::fromKg(10.0);

    mass *= 3.0;
    EXPECT_NEAR(mass.toKg(), 30.0, 1e-9);

    mass /= 2.0;
    EXPECT_NEAR(mass.toKg(), 15.0, 1e-9);

    EXPECT_THROW(mass /= 0.0, std::invalid_argument);
    EXPECT_THROW(mass *= -1.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, Pressure) {
    auto pressure = Pressure::fromKpa(10.0);

    pressure *= 3.0;
    EXPECT_NEAR(pressure.toKpa(), 30.0, 1e-9);

    pressure /= 2.0;
    EXPECT_NEAR(pressure.toKpa(), 15.0, 1e-9);

    EXPECT_THROW(pressure /= 0.0, std::invalid_argument);
    EXPECT_THROW(pressure *= -1.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, Power) {
    auto power = Power::fromKw(10.0);

    power *= 3.0;
    EXPECT_NEAR(power.toKw(), 30.0, 1e-9);

    power /= 2.0;
    EXPECT_NEAR(power.toKw(), 15.0, 1e-9);

    EXPECT_THROW(power /= 0.0, std::invalid_argument);
    EXPECT_THROW(power *= -1.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, Torque) {
    auto torque = Torque::fromNm(10.0);

    torque *= 3.0;
    EXPECT_NEAR(torque.toNm(), 30.0, 1e-9);

    torque /= 2.0;
    EXPECT_NEAR(torque.toNm(), 15.0, 1e-9);

    EXPECT_THROW(torque /= 0.0, std::invalid_argument);
    EXPECT_THROW(torque *= -1.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, Angle) {
    auto angle = Angle::fromDegrees(10.0);

    angle *= 3.0;
    EXPECT_NEAR(angle.toDegrees(), 30.0, 1e-9);

    angle /= 2.0;
    EXPECT_NEAR(angle.toDegrees(), 15.0, 1e-9);

    EXPECT_THROW(angle /= 0.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, Volume) {
    auto volume = Volume::fromLiters(10.0);

    volume *= 3.0;
    EXPECT_NEAR(volume.toLiters(), 30.0, 1e-9);

    volume /= 2.0;
    EXPECT_NEAR(volume.toLiters(), 15.0, 1e-9);

    EXPECT_THROW(volume /= 0.0, std::invalid_argument);
    EXPECT_THROW(volume *= -1.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, Efficiency) {
    auto efficiency = Efficiency::fromKml(10.0);

    efficiency *= 3.0;
    EXPECT_NEAR(efficiency.toKml(), 30.0, 1e-9);

    efficiency /= 2.0;
    EXPECT_NEAR(efficiency.toKml(), 15.0, 1e-9);

    EXPECT_THROW(efficiency /= 0.0, std::invalid_argument);
    EXPECT_THROW(efficiency *= -1.0, std::invalid_argument);
}

TEST(Tier2ScalarCompoundAssignmentTest, EvEfficiency) {
    auto efficiency = EvEfficiency::fromKmkWh(10.0);

    efficiency *= 3.0;
    EXPECT_NEAR(efficiency.toKmkWh(), 30.0, 1e-9);

    efficiency /= 2.0;
    EXPECT_NEAR(efficiency.toKmkWh(), 15.0, 1e-9);

    EXPECT_THROW(efficiency /= 0.0, std::invalid_argument);
    EXPECT_THROW(efficiency *= -1.0, std::invalid_argument);
}


// --- zero, identity, and signed-value boundaries

TEST(BoundaryTest, AddSubIdentity) {
    auto speed = Speed::fromMs(10.0);
    auto distance = Distance::fromMeters(10.0);
    auto time = Time::fromSeconds(10.0);
    auto mass = Mass::fromKg(10.0);
    auto acceleration = Acceleration::fromMs2(-10.0);

    EXPECT_NEAR((speed + Speed::fromMs(0.0)).toMs(), 10.0, 1e-9);
    EXPECT_NEAR((distance - Distance::fromMeters(0.0)).toMeters(), 10.0, 1e-9);
    EXPECT_NEAR((time + Time::fromSeconds(0.0)).toSeconds(), 10.0, 1e-9);
    EXPECT_NEAR((mass - Mass::fromKg(0.0)).toKg(), 10.0, 1e-9);
    EXPECT_NEAR((acceleration + Acceleration::fromMs2(10.0)).toMs2(), 0.0, 1e-9);
}

TEST(BoundaryTest, ScalarIdentity) {
    EXPECT_NEAR((Speed::fromMs(10.0) * 1.0).toMs(), 10.0, 1e-9);
    EXPECT_NEAR((Distance::fromMeters(10.0) * 1.0).toMeters(), 10.0, 1e-9);
    EXPECT_NEAR((Acceleration::fromMs2(10.0) * 1.0).toMs2(), 10.0, 1e-9);
    EXPECT_NEAR((Time::fromSeconds(10.0) * 1.0).toSeconds(), 10.0, 1e-9);
    EXPECT_NEAR((Mass::fromKg(10.0) * 1.0).toKg(), 10.0, 1e-9);
    EXPECT_NEAR((Pressure::fromKpa(10.0) * 1.0).toKpa(), 10.0, 1e-9);
    EXPECT_NEAR((Power::fromKw(10.0) * 1.0).toKw(), 10.0, 1e-9);
    EXPECT_NEAR((Torque::fromNm(10.0) * 1.0).toNm(), 10.0, 1e-9);
    EXPECT_NEAR((Angle::fromDegrees(10.0) * 1.0).toDegrees(), 10.0, 1e-9);
    EXPECT_NEAR((Volume::fromLiters(10.0) * 1.0).toLiters(), 10.0, 1e-9);
    EXPECT_NEAR((Efficiency::fromKml(10.0) * 1.0).toKml(), 10.0, 1e-9);
    EXPECT_NEAR((EvEfficiency::fromKmkWh(10.0) * 1.0).toKmkWh(), 10.0, 1e-9);
}
