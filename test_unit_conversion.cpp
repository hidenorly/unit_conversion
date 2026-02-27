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

// test for conversion from Km/h to Mph
TEST(SpeedTest, ConvertKmHToMph) {
    auto speed = Speed::fromKmH(60.0);
    // 60 km/h is approx. 37.2823 mph
    EXPECT_NEAR(speed.toMph(), 37.2823, 0.001);
}

// test for conversion from Mph to Km/h
TEST(SpeedTest, ConvertMphToKmH) {
    auto speed = Speed::fromMph(60.0);
    // 60 mph is approx. 96.5606 km/h
    EXPECT_NEAR(speed.toKmH(), 96.5606, 0.001);
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
