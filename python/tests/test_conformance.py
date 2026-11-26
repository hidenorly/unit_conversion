#!/usr/bin/env python3
# coding: utf-8
#   Copyright 2026 hidenorly
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

# Conformance test: run the shared golden vectors (test_vectors.json at
# the repository root) against the Python implementation.
#
# Every language implementation runs the same vectors; a failure here
# means this implementation disagrees with the shared specification.
# Regenerate vectors with tools/generate_test_vectors.py.

import json
import math
import os
import unittest

from unit_conversion import (
    Acceleration, Angle, Distance, Efficiency, EvEfficiency, Mass,
    Power, Pressure, Speed, Temperature, Time, Torque, Volume,
)


def find_vectors():
    env = os.environ.get("UNIT_CONVERSION_TEST_VECTORS")
    if env:
        return env
    here = os.path.dirname(os.path.abspath(__file__))
    cwd = os.getcwd()
    for base in (here, cwd):
        d = base
        for _ in range(5):
            cand = os.path.join(d, "test_vectors.json")
            if os.path.exists(cand):
                return cand
            d = os.path.dirname(d)
    raise FileNotFoundError("test_vectors.json not found")


# quantity -> {unit: (factory, getter-attribute)}
DISPATCH = {
    "Speed": {"ms": (Speed.from_ms, "to_ms"),
              "kmh": (Speed.from_kmh, "to_kmh"),
              "mph": (Speed.from_mph, "to_mph")},
    "Temperature": {"celsius": (Temperature.from_celsius, "to_celsius"),
                    "fahrenheit": (Temperature.from_fahrenheit, "to_fahrenheit"),
                    "kelvin": (Temperature.from_kelvin, "to_kelvin")},
    "Mass": {"kg": (Mass.from_kg, "to_kg"),
             "gram": (Mass.from_gram, "to_gram"),
             "lb": (Mass.from_lb, "to_lb"),
             "oz": (Mass.from_oz, "to_oz")},
    "Distance": {"meters": (Distance.from_meters, "to_meters"),
                 "km": (Distance.from_km, "to_km"),
                 "mile": (Distance.from_mile, "to_mile"),
                 "feet": (Distance.from_feet, "to_feet"),
                 "inch": (Distance.from_inch, "to_inch"),
                 "mm": (Distance.from_mm, "to_mm")},
    "Pressure": {"kpa": (Pressure.from_kpa, "to_kpa"),
                 "bar": (Pressure.from_bar, "to_bar"),
                 "psi": (Pressure.from_psi, "to_psi")},
    "Power": {"kw": (Power.from_kw, "to_kw"),
              "ps": (Power.from_ps, "to_ps"),
              "hp": (Power.from_hp, "to_hp")},
    "Torque": {"nm": (Torque.from_nm, "to_nm"),
               "kgfm": (Torque.from_kgfm, "to_kgfm"),
               "lbft": (Torque.from_lbft, "to_lbft")},
    "Angle": {"radians": (Angle.from_radians, "to_radians"),
              "degrees": (Angle.from_degrees, "to_degrees")},
    "Efficiency": {"kml": (Efficiency.from_kml, "to_kml"),
                   "l100km": (Efficiency.from_l100km, "to_l100km"),
                   "mpg": (Efficiency.from_mpg, "to_mpg")},
    "EvEfficiency": {"km_per_kwh": (EvEfficiency.from_km_per_kwh, "to_km_per_kwh"),
                     "wh_per_km": (EvEfficiency.from_wh_per_km, "to_wh_per_km"),
                     "kwh_per_100km": (EvEfficiency.from_kwh_per_100km, "to_kwh_per_100km"),
                     "miles_per_kwh": (EvEfficiency.from_miles_per_kwh, "to_miles_per_kwh")},
    "Volume": {"liters": (Volume.from_liters, "to_liters"),
               "ml": (Volume.from_ml, "to_ml"),
               "us_gallons": (Volume.from_us_gallons, "to_us_gallons"),
               "imp_gallons": (Volume.from_imp_gallons, "to_imp_gallons")},
    "Time": {"seconds": (Time.from_seconds, "to_seconds"),
             "minutes": (Time.from_minutes, "to_minutes"),
             "hours": (Time.from_hours, "to_hours")},
    "Acceleration": {"ms2": (Acceleration.from_ms2, "to_ms2")},
}


def parse_value(v):
    if v == "NaN":
        return float("nan")
    if v == "Infinity":
        return float("inf")
    if v == "-Infinity":
        return float("-inf")
    return float(v)


def construct(spec):
    factory, _ = DISPATCH[spec["quantity"]][spec["unit"]]
    return factory(parse_value(spec["value"]))


def read(obj, quantity, unit):
    _, getter = DISPATCH[quantity][unit]
    return float(getattr(obj, getter))


def apply_op(case):
    lhs = construct(case["lhs"])
    op = case["op"]
    if op in ("mul_scalar", "div_scalar"):
        rhs = parse_value(case["rhs"])
    else:
        rhs = construct(case["rhs"])
    if op == "add":
        return lhs + rhs
    if op == "sub":
        return lhs - rhs
    if op in ("mul", "mul_scalar"):
        return lhs * rhs
    if op in ("div", "div_scalar"):
        return lhs / rhs
    raise AssertionError(f"unknown op {op}")


class TestConformance(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        with open(find_vectors(), encoding="utf-8") as fh:
            cls.doc = json.load(fh)
        cls.rel_tol = cls.doc.get("rel_tol", 1e-9)
        cls.abs_tol = cls.doc.get("abs_tol", 1e-12)

    def assert_close(self, actual, expected, label):
        tol = self.abs_tol + self.rel_tol * abs(expected)
        self.assertTrue(
            math.isfinite(actual) and abs(actual - expected) <= tol,
            f"{label}: got {actual!r}, expected {expected!r} (tol {tol:g})")

    def test_vectors(self):
        for i, case in enumerate(self.doc["cases"]):
            label = f"case {i}: {case}"
            with self.subTest(case=i, kind=case["kind"]):
                if case["kind"] == "convert":
                    obj = construct({"quantity": case["quantity"],
                                     "unit": case["from"],
                                     "value": case["value"]})
                    actual = read(obj, case["quantity"], case["to"])
                    self.assert_close(actual, case["expected"], label)
                elif case["kind"] == "error":
                    with self.assertRaises(Exception, msg=label):
                        construct({"quantity": case["quantity"],
                                   "unit": case["from"],
                                   "value": case["value"]})
                elif case["kind"] == "op":
                    if "error" in case:
                        with self.assertRaises(Exception, msg=label):
                            apply_op(case)
                    else:
                        result = apply_op(case)
                        if case["expected_quantity"] == "scalar":
                            self.assert_close(float(result), case["expected"], label)
                        else:
                            actual = read(result, case["expected_quantity"],
                                          case["expected_unit"])
                            self.assert_close(actual, case["expected"], label)
                else:
                    self.fail(f"unknown kind {case['kind']}")


if __name__ == "__main__":
    unittest.main()
