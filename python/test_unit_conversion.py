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
import math
from unit_conversion import Speed,Temperature,Mass,Distance,Pressure,Torque,Angle

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


class TestDistance(unittest.TestCase):
    def test_conversion(self):
        # 1.0 km -> 1000.0 m
        self.assertEqual(Distance.from_km(1.0).to_meters, 1000.0)

        # 1.0 mile -> 1.609344 km
        d_mile = Distance.from_mile(1.0)
        self.assertAlmostEqual(d_mile.to_km, 1.609344, places=6)

        # 1.0 ft -> 12.0 inch
        d_ft = Distance.from_feet(1.0)
        self.assertAlmostEqual(d_ft.to_inch, 12.0, places=6)

        # 100.0 inch -> 2.54 m
        d_in = Distance.from_inch(100.0)
        self.assertAlmostEqual(d_in.to_meters, 2.54, places=6)


class TestPressure(unittest.TestCase):
    def test_conversion(self):
        p_bar = Pressure.from_bar(2.5)
        self.assertAlmostEqual(p_bar.to_kpa, 250.0, places=3)

        p_kpa = Pressure.from_kpa(250.0)
        self.assertAlmostEqual(p_kpa.to_psi, 36.2594, places=3)


class TestTorque(unittest.TestCase):
    def test_conversion(self):
        t = Torque.from_kgfm(1.0)
        self.assertAlmostEqual(t.to_nm, 9.80665, places=5)


class TestAngle(unittest.TestCase):
    def test_conversion(self):
        a = Angle.from_degrees(180.0)
        self.assertAlmostEqual(a.to_radians, math.pi, places=6)

        a2 = Angle.from_radians(math.pi / 2)
        self.assertAlmostEqual(a2.to_degrees, 90.0, places=6)


if __name__ == '__main__':
    unittest.main()
