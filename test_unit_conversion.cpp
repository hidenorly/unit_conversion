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
    EXPECT_NEAR(speed.toMph(), 37.2823, 0.001);
    EXPECT_NEAR(speed.toMs(), 60.0/3.6, 0.001);
}

// test for conversion from Mph to Km/h
TEST(SpeedTest, ConvertMphToKmH) {
    auto speed = Speed::fromMph(60.0);
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


// --- test case for Temperature

TEST(TemperatureTest, FahrenheitToCelsius) {
    auto t = Temperature::fromFahrenheit(32.0);
    EXPECT_NEAR(t.toCelsius(), 0.0, 0.001);
}

TEST(TemperatureTest, CelsiusToFahrenheit) {
    auto t = Temperature::fromCelsius(100.0);
    EXPECT_NEAR(t.toFahrenheit(), 212.0, 0.001);
}

TEST(TemperatureTest, CelsiusToKelvin) {
    auto t = Temperature::fromCelsius(0.0);
    EXPECT_DOUBLE_EQ(t.toKelvin(), 273.15);
}

TEST(TemperatureTest, KelvinToCelsius) {
    auto t = Temperature::fromKelvin(373.15);
    EXPECT_NEAR(t.toCelsius(), 100.0, 0.001);
}


// --- test case for Weight

TEST(MassTest, GramToKg) {
    auto m = Mass::fromGram(1000.0);
    EXPECT_DOUBLE_EQ(m.toKg(), 1.0);
}

TEST(MassTest, LbToKg) {
    auto m = Mass::fromLb(1.0);
    EXPECT_NEAR(m.toKg(), 0.453592, 0.000001);
}

TEST(MassTest, KgToLb) {
    auto m = Mass::fromKg(1.0);
    EXPECT_NEAR(m.toLb(), 2.20462, 0.00001);
}

TEST(MassTest, LbToOz) {
    auto m = Mass::fromLb(1.0);
    EXPECT_NEAR(m.toOz(), 16.0, 0.000001);
}


// --- test case for distance

TEST(DistanceTest, KmToMeters) {
    auto d = Distance::fromKm(1.0);
    EXPECT_DOUBLE_EQ(d.toMeters(), 1000.0);
}

TEST(DistanceTest, MileToKm) {
    auto d = Distance::fromMile(1.0);
    EXPECT_NEAR(d.toKm(), 1.609344, 0.000001);
}

TEST(DistanceTest, FootToInch) {
    auto d = Distance::fromFeet(1.0);
    EXPECT_NEAR(d.toInch(), 12.0, 0.000001);
}


// --- test case for pressure

TEST(PressureTest, BarToKpa) {
    auto p = Pressure::fromBar(2.5);
    EXPECT_NEAR(p.toKpa(), 250.0, 0.001);
}

TEST(PressureTest, KpaToPsi) {
    auto p = Pressure::fromKpa(250.0);
    EXPECT_NEAR(p.toPsi(), 36.2594, 0.001);
}


// --- test case for torque

TEST(TorqueTest, KgfmToNm) {
    auto t = Torque::fromKgfm(10.0);
    EXPECT_NEAR(t.toNm(), 98.0665, 0.0001);
}