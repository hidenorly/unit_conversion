#!/usr/bin/env python3
# coding: utf-8
#   Copyright 2025, 2026 hidenorly
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

import unittest
from unit_conversion import Speed,Temperature,Mass

class TestSpeed(unittest.TestCase):
    def test_conversion(self):
        # test conversion km/h -> mph
        s1 = Speed.from_kmh(60.0)
        self.assertAlmostEqual(s1.to_mph, 37.2823, places=3)

        # test conversion mph -> km/h
        s2 = Speed.from_mph(60.0)
        self.assertAlmostEqual(s2.to_kmh, 96.5606, places=3)

        # test zero
        s3 = Speed.from_kmh(0.0)
        self.assertEqual(s3.to_mph, 0.0)

        # test identicality
        original = 120.5
        s4 = Speed.from_kmh(original);
        self.assertAlmostEqual(s4.to_kmh, original, places = 3)


class TestTemperature(unittest.TestCase):
    def test_conversion(self):
        # 32 F -> 0 C
        t1 = Temperature.from_fahrenheit(32.0)
        self.assertAlmostEqual(t1.to_celsius, 0.0, places=3)

        # 100 C -> 212 F
        t2 = Temperature.from_celsius(100.0)
        self.assertAlmostEqual(t2.to_fahrenheit, 212.0, places=3)

        # 0 C -> 273.15 K
        t3 = Temperature.from_celsius(0.0)
        self.assertEqual(t3.to_kelvin, 273.15)


class TestMass(unittest.TestCase):
    def test_conversion(self):
        # 1000g -> 1kg
        self.assertEqual(Mass.from_gram(1000.0).to_kg, 1.0)

        # 1lb -> 0.45359kg
        self.assertAlmostEqual(Mass.from_lb(1.0).to_kg, 0.453592, places=6)

        # 1kg -> 2.20462lb
        self.assertAlmostEqual(Mass.from_kg(1.0).to_lb, 2.20462, places=5)

        # 1lb -> 16oz
        self.assertAlmostEqual(Mass.from_lb(1.0).to_oz, 16.0, places=6)


if __name__ == '__main__':
    unittest.main()
