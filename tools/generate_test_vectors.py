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

"""
Generate the shared golden test vectors (test_vectors.json) for all
language implementations of unit_conversion.

The expected values are computed here with Decimal (40 significant
digits) from the defining constants below, independently of any
language implementation.  Regenerate after changing constants with:

    python3 tools/generate_test_vectors.py

Vector kinds:
  convert : {"kind":"convert","quantity":Q,"from":U,"value":V,"to":U2,"expected":E}
  error   : {"kind":"error","quantity":Q,"from":U,"value":V,"error":CATEGORY}
            V may be the string "NaN", "Infinity" or "-Infinity".
  op      : {"kind":"op","op":OP, "lhs":{...}, "rhs":{...}|number,
             "expected_quantity":Q2,"expected_unit":U3,"expected":E}
            or {"kind":"op", ..., "error":CATEGORY} for failing ops.
            OP is one of: add, sub, mul, div, mul_scalar, div_scalar.
            For "div" of two equal quantities the expected value is a
            plain number and expected_quantity is "scalar".

Error categories: non_negative, must_be_positive, below_absolute_zero,
not_finite, division_by_zero.

Comparison rule for runners: |actual-expected| <= abs_tol + rel_tol*|expected|
with rel_tol = 1e-9 and abs_tol = 1e-12 unless a case overrides them.
"""

import json
from decimal import Decimal, getcontext

getcontext().prec = 40
D = Decimal

# ---------------------------------------------------------------------------
# Defining constants (same values as the implementations; the source of
# truth for the vectors).  Values are exact decimal strings.
# ---------------------------------------------------------------------------

def lin(factor):
    """base = value * factor"""
    f = D(factor)
    return (lambda v: v * f, lambda b: b / f)


def div_by(factor):
    """base = value / factor (e.g. km/h -> m/s divides by 3.6)"""
    f = D(factor)
    return (lambda v: v / f, lambda b: b * f)


def reciprocal(scale):
    """base = scale / value (e.g. L/100km -> km/L is 100 / value)"""
    s = D(scale)
    return (lambda v: s / v, lambda b: s / b)


# unit -> (to_base, from_base)
UNITS = {
    "Speed": {
        "ms": lin("1"),
        "kmh": div_by("3.6"),
        "mph": lin("0.44704"),
    },
    "Temperature": {
        "celsius": lin("1"),
        "fahrenheit": ((lambda v: (v - D("32.0")) / D("1.8")),
                       (lambda b: b * D("1.8") + D("32.0"))),
        "kelvin": ((lambda v: v - D("273.15")),
                   (lambda b: b + D("273.15"))),
    },
    "Mass": {
        "kg": lin("1"),
        "gram": lin("0.001"),
        "lb": lin("0.45359237"),
        "oz": lin("0.028349523125"),
    },
    "Distance": {
        "meters": lin("1"),
        "km": lin("1000"),
        "mile": lin("1609.344"),
        "feet": lin("0.3048"),
        "inch": lin("0.0254"),
        "mm": lin("0.001"),
    },
    "Pressure": {
        "kpa": lin("1"),
        "bar": lin("100"),
        "psi": lin("6.894757293168361"),
    },
    "Power": {
        "kw": lin("1"),
        "ps": lin("0.73549875"),
        "hp": lin("0.7456998715822702"),
    },
    "Torque": {
        "nm": lin("1"),
        "kgfm": lin("9.80665"),
        "lbft": lin("1.3558179483314003"),
    },
    "Angle": {
        "radians": lin("1"),
        "degrees": div_by("57.295779513082320876798154814105170332405472466564"),
        # degrees -> radians multiplies by pi/180; expressed via the
        # exact reciprocal constant 180/pi above at 40-digit precision.
    },
    "Efficiency": {
        "kml": lin("1"),
        "l100km": reciprocal("100"),
        "mpg": lin("0.425143707430272"),
        "mpg_us": lin("0.425143707430272"),
        "mpg_imp": lin("0.3540061899346471"),
    },
    "EvEfficiency": {
        "km_per_kwh": lin("1"),
        "wh_per_km": reciprocal("1000"),
        "kwh_per_100km": reciprocal("100"),
        "miles_per_kwh": lin("1.609344"),
    },
    "Volume": {
        "liters": lin("1"),
        "ml": div_by("1000"),
        "us_gallons": lin("3.785411784"),
        "imp_gallons": lin("4.54609"),
    },
    "Time": {
        "seconds": lin("1"),
        "minutes": lin("60"),
        "hours": lin("3600"),
    },
    "Acceleration": {
        "ms2": lin("1"),
    },
}

BASE_UNIT = {q: next(iter(u)) for q, u in UNITS.items()}

# Sign policy categories (see README "Sign policy")
NON_NEGATIVE = ["Speed", "Mass", "Distance", "Pressure", "Power",
                "Torque", "Volume", "Time"]
MUST_BE_POSITIVE = ["Efficiency", "EvEfficiency"]
SIGNED = ["Acceleration", "Angle"]

# Sample values per quantity, expressed in its base unit.
BASE_SAMPLES = {
    "Speed": ["0", "1", "10", "27.777777777777777"],
    "Temperature": ["-40", "0", "20", "36.6", "100"],
    "Mass": ["0", "1", "2.5", "80"],
    "Distance": ["0", "1", "42.195", "1000"],
    "Pressure": ["0", "1", "101.325", "250"],
    "Power": ["0", "1", "55", "110"],
    "Torque": ["0", "1", "98.0665", "200"],
    "Angle": ["0", "1.5707963267948966", "-1.5707963267948966", "3.141592653589793"],
    "Efficiency": ["1", "10", "15.5", "25"],
    "EvEfficiency": ["1", "5", "6.5", "8"],
    "Volume": ["0", "1", "4.54609", "50"],
    "Time": ["0", "1", "90", "3600"],
    "Acceleration": ["0", "1", "-9.8", "9.80665"],
}

cases = []


def add_convert(quantity, from_unit, value, to_unit):
    to_base, _ = UNITS[quantity][from_unit]
    _, from_base = UNITS[quantity][to_unit]
    expected = from_base(to_base(D(str(value))))
    cases.append({
        "kind": "convert", "quantity": quantity,
        "from": from_unit, "value": float(D(str(value))),
        "to": to_unit, "expected": float(expected),
    })


def add_error(quantity, from_unit, value, category):
    v = value if isinstance(value, str) else float(D(str(value)))
    cases.append({
        "kind": "error", "quantity": quantity,
        "from": from_unit, "value": v, "error": category,
    })


# --- conversion cases -------------------------------------------------------
for quantity, units in UNITS.items():
    base = BASE_UNIT[quantity]
    # base unit -> every unit, for each sample
    for sample in BASE_SAMPLES[quantity]:
        for unit in units:
            add_convert(quantity, base, sample, unit)
    # every unit -> base unit, for two unit-local samples
    for unit in units:
        if unit == base:
            continue
        for sample in ("1", "12.5"):
            add_convert(quantity, unit, sample, base)

# Temperature boundary: absolute zero itself is valid.
add_convert("Temperature", "celsius", "-273.15", "kelvin")
add_convert("Temperature", "kelvin", "0", "celsius")
add_convert("Temperature", "kelvin", "0", "fahrenheit")

# --- sign-policy / finiteness error cases -----------------------------------
for q in NON_NEGATIVE:
    add_error(q, BASE_UNIT[q], "-1", "non_negative")
for q in MUST_BE_POSITIVE:
    add_error(q, BASE_UNIT[q], "0", "must_be_positive")
    add_error(q, BASE_UNIT[q], "-1", "must_be_positive")
add_error("Temperature", "celsius", "-273.16", "below_absolute_zero")
add_error("Temperature", "kelvin", "-0.1", "below_absolute_zero")
add_error("Temperature", "fahrenheit", "-500", "below_absolute_zero")
add_error("Speed", "ms", "NaN", "not_finite")
add_error("Mass", "kg", "Infinity", "not_finite")
add_error("Distance", "meters", "-Infinity", "not_finite")
add_error("Angle", "degrees", "NaN", "not_finite")

# --- operator cases ----------------------------------------------------------

def qty(quantity, unit, value):
    return {"quantity": quantity, "unit": unit, "value": float(D(str(value)))}


def base_value(q):
    to_base, _ = UNITS[q["quantity"]][q["unit"]]
    return to_base(D(str(q["value"])))


def add_op(op, lhs, rhs, expected_quantity=None, expected_unit=None,
           expected_base=None, error=None):
    case = {"kind": "op", "op": op, "lhs": lhs, "rhs": rhs}
    if error is not None:
        case["error"] = error
    else:
        _, from_base = UNITS[expected_quantity][expected_unit]
        case["expected_quantity"] = expected_quantity
        case["expected_unit"] = expected_unit
        case["expected"] = float(from_base(D(str(expected_base))))
    cases.append(case)


def add_ratio(lhs, rhs):
    expected = base_value(lhs) / base_value(rhs)
    cases.append({"kind": "op", "op": "div", "lhs": lhs, "rhs": rhs,
                  "expected_quantity": "scalar", "expected": float(expected)})


S, T, A, DI, M = "Speed", "Time", "Acceleration", "Distance", "Mass"

# same-quantity add/sub (cross-unit where interesting)
add_op("add", qty(S, "ms", "10"), qty(S, "kmh", "36"), S, "ms", "20")
add_op("add", qty(M, "kg", "1.5"), qty(M, "gram", "500"), M, "kg", "2")
add_op("add", qty(T, "seconds", "30"), qty(T, "minutes", "0.5"), T, "seconds", "60")
add_op("add", qty("Angle", "degrees", "90"), qty("Angle", "degrees", "90"),
       "Angle", "degrees", "3.141592653589793")  # expected_base is radians (= 180 deg)
add_op("add", qty("Temperature", "celsius", "20"), qty("Temperature", "celsius", "10"),
       "Temperature", "celsius", "30")
add_op("sub", qty(S, "ms", "20"), qty(S, "ms", "10"), S, "ms", "10")
add_op("sub", qty("Temperature", "celsius", "20"), qty("Temperature", "celsius", "30"),
       "Temperature", "celsius", "-10")
# arithmetic results follow the sign policy
add_op("sub", qty(S, "ms", "10"), qty(S, "ms", "20"), error="non_negative")
add_op("sub", qty(A, "ms2", "5"), qty(A, "ms2", "10"), A, "ms2", "-5")
add_op("sub", qty("Temperature", "celsius", "-270"), qty("Temperature", "celsius", "10"),
       error="below_absolute_zero")

# scalar mul/div
add_op("mul_scalar", qty(S, "ms", "10"), 2.5, S, "ms", "25")
add_op("div_scalar", qty(S, "ms", "10"), 4, S, "ms", "2.5")
add_op("mul_scalar", qty(DI, "meters", "10"), 0, DI, "meters", "0")
add_op("div_scalar", qty(S, "ms", "10"), 0, error="division_by_zero")
add_op("mul_scalar", qty("Efficiency", "kml", "10"), -1, error="must_be_positive")

# cross-quantity mul/div (dimensional arithmetic)
add_op("mul", qty(S, "ms", "10"), qty(T, "seconds", "5"), DI, "meters", "50")
add_op("mul", qty(T, "seconds", "5"), qty(S, "ms", "10"), DI, "meters", "50")
add_op("mul", qty(A, "ms2", "2"), qty(T, "seconds", "5"), S, "ms", "10")
add_op("div", qty(DI, "meters", "100"), qty(T, "seconds", "20"), S, "ms", "5")
add_op("div", qty(S, "ms", "20"), qty(T, "seconds", "4"), A, "ms2", "5")
add_op("div", qty(DI, "meters", "100"), qty(S, "ms", "20"), T, "seconds", "5")
add_op("div", qty(S, "ms", "20"), qty(A, "ms2", "2"), T, "seconds", "10")
add_op("div", qty(DI, "meters", "100"), qty(T, "seconds", "0"),
       error="division_by_zero")

# same-quantity division -> scalar ratio
add_ratio(qty(DI, "km", "2.5"), qty(DI, "meters", "1000"))
add_ratio(qty(S, "kmh", "36"), qty(S, "ms", "10"))
add_ratio(qty(T, "seconds", "3600"), qty(T, "minutes", "30"))
add_ratio(qty("Volume", "liters", "50"), qty("Volume", "ml", "500"))
add_ratio(qty(A, "ms2", "9.8"), qty(A, "ms2", "2"))
add_ratio(qty("Efficiency", "kml", "20"), qty("Efficiency", "l100km", "10"))
add_ratio(qty("EvEfficiency", "km_per_kwh", "6.5"),
          qty("EvEfficiency", "wh_per_km", "200"))

# ---------------------------------------------------------------------------
doc = {
    "version": 1,
    "description": "Shared golden test vectors for all unit_conversion "
                   "implementations. Generated by "
                   "tools/generate_test_vectors.py; do not edit by hand.",
    "rel_tol": 1e-9,
    "abs_tol": 1e-12,
    "cases": cases,
}

with open("test_vectors.json", "w", encoding="utf-8") as fh:
    json.dump(doc, fh, indent=1, ensure_ascii=False)
    fh.write("\n")

print(f"wrote test_vectors.json with {len(cases)} cases")
