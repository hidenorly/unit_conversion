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
from unit_conversion import Speed,Temperature,Mass,Distance,Pressure,Torque,Angle,Efficiency

class TestSpeed(unittest.TestCase):
    def test_conversion(self):
        # test conversion km/h -> mph
        s1 = Speed.from_kmh(60.0)
        self.assertAlmostEqual(s1.to_kmh, 60.0, places=3)
        self.assertAlmostEqual(s1.to_mph, 37.2823, places=3)

        # test conversion mph -> km/h
        s2 = Speed.from_mph(60.0)
        self.assertAlmostEqual(s2.to_mph, 60.0, places=3)
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
        self.assertAlmostEqual(t1.to_fahrenheit, 32.0, places=3)
        self.assertAlmostEqual(t1.to_celsius, 0.0, places=3)

        # 100 C -> 212 F
        t2 = Temperature.from_celsius(100.0)
        self.assertAlmostEqual(t2.to_celsius, 100.0, places=3)
        self.assertAlmostEqual(t2.to_fahrenheit, 212.0, places=3)

        # 0 C -> 273.15 K
        t3 = Temperature.from_celsius(0.0)
        self.assertAlmostEqual(t3.to_celsius, 0.0, places=3)
        self.assertEqual(t3.to_kelvin, 273.15)

        # 0 C -> 273.15 K
        t4 = Temperature.from_kelvin(273.15)
        self.assertEqual(t4.to_kelvin, 273.15)
        self.assertAlmostEqual(t3.to_celsius, 0.0, places=3)


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

        w1 = Mass.from_kg(1.0)
        self.assertEqual(w1.to_kg, 1.0)

        w2 = Mass.from_gram(1000.0)
        self.assertEqual(w2.to_gram, 1000.0)

        w3 = Mass.from_lb(8.0)
        self.assertEqual(w3.to_lb, 8.0)

        w4 = Mass.from_oz(8.0)
        self.assertEqual(w4.to_oz, 8.0)


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

        d1 = Distance.from_meters(1000.0)
        self.assertEqual(d1.to_meters, 1000.0)

        d2 = Distance.from_km(1.0)
        self.assertEqual(d2.to_km, 1.0)

        d3 = Distance.from_mile(1.0)
        self.assertEqual(d3.to_mile, 1.0)

        d4 = Distance.from_feet(10.0)
        self.assertEqual(d4.to_feet, 10.0)

        d5 = Distance.from_inch(16.0)
        self.assertEqual(d5.to_inch, 16.0)


class TestPressure(unittest.TestCase):
    def test_conversion(self):
        p_bar = Pressure.from_bar(2.5)
        self.assertAlmostEqual(p_bar.to_bar, 2.5, places=3)
        self.assertAlmostEqual(p_bar.to_kpa, 250.0, places=3)

        p_kpa = Pressure.from_kpa(250.0)
        self.assertAlmostEqual(p_kpa.to_kpa, 250.0, places=3)
        self.assertAlmostEqual(p_kpa.to_psi, 36.2594, places=3)

        p_psi = Pressure.from_psi(36.2594)
        self.assertAlmostEqual(p_psi.to_psi, 36.2594, places=3)
        self.assertAlmostEqual(p_psi.to_kpa, 250.0, places=3)


class TestTorque(unittest.TestCase):
    def test_conversion(self):
        t = Torque.from_kgfm(1.0)
        self.assertAlmostEqual(t.to_kgfm, 1.0, places=5)
        self.assertAlmostEqual(t.to_nm, 9.80665, places=5)
        self.assertAlmostEqual(t.to_lbft, 7.233014, places=5)

        t2 = Torque.from_nm(9.80665)
        self.assertAlmostEqual(t2.to_nm, 9.80665, places=5)
        self.assertAlmostEqual(t2.to_kgfm, 1.0, places=5)
        self.assertAlmostEqual(t2.to_lbft, 7.233014, places=5)

        t3 = Torque.from_lbft(7.233014)
        self.assertAlmostEqual(t3.to_lbft, 7.233014, places=5)
        self.assertAlmostEqual(t3.to_nm, 9.80665, places=5)
        self.assertAlmostEqual(t3.to_kgfm, 1.0, places=5)


class TestAngle(unittest.TestCase):
    def test_conversion(self):
        a = Angle.from_degrees(180.0)
        self.assertAlmostEqual(a.to_degrees, 180.0, places=6)
        self.assertAlmostEqual(a.to_radians, math.pi, places=6)

        a2 = Angle.from_radians(math.pi / 2)
        self.assertAlmostEqual(a2.to_radians, math.pi / 2, places=6)
        self.assertAlmostEqual(a2.to_degrees, 90.0, places=6)


class TestEfficiency(unittest.TestCase):
    def test_conversion(self):
        e = Efficiency.from_l100km(10.0)
        self.assertEqual(e.to_l100km, 10.0)
        self.assertEqual(e.to_kml, 10.0)
        self.assertAlmostEqual(e.to_mpg, 23.5215, places=3)

        e2 = Efficiency.from_mpg(23.5215)
        self.assertAlmostEqual(e2.to_mpg, 23.5215, places=3)
        self.assertAlmostEqual(e2.to_kml, 10.0, delta=0.0001)
        self.assertAlmostEqual(e2.to_l100km, 10.0, delta=0.0001)


if __name__ == '__main__':
    unittest.main()
