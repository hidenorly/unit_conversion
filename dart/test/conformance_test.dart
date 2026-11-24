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

// Conformance test: run the shared golden vectors (test_vectors.json at
// the repository root) against the Dart implementation.
//
// Every language implementation runs the same vectors; a failure here
// means this implementation disagrees with the shared specification.
// Regenerate vectors with tools/generate_test_vectors.py.

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:unit_conversion/unit_conversion.dart';

File findVectors() {
  final env = Platform.environment['UNIT_CONVERSION_TEST_VECTORS'];
  if (env != null) return File(env);
  var dir = Directory.current;
  for (var i = 0; i < 5; i++) {
    final cand = File('${dir.path}/test_vectors.json');
    if (cand.existsSync()) return cand;
    dir = dir.parent;
  }
  throw StateError('test_vectors.json not found');
}

double parseValue(Object? v) {
  if (v == 'NaN') return double.nan;
  if (v == 'Infinity') return double.infinity;
  if (v == '-Infinity') return double.negativeInfinity;
  return (v as num).toDouble();
}

Object construct(Map<String, dynamic> spec) {
  final quantity = spec['quantity'] as String;
  final unit = spec['unit'] as String;
  final v = parseValue(spec['value']);
  switch ((quantity, unit)) {
    case ('Speed', 'ms'):
      return Speed.fromMs(v);
    case ('Speed', 'kmh'):
      return Speed.fromKmH(v);
    case ('Speed', 'mph'):
      return Speed.fromMph(v);
    case ('Temperature', 'celsius'):
      return Temperature.fromCelsius(v);
    case ('Temperature', 'fahrenheit'):
      return Temperature.fromFahrenheit(v);
    case ('Temperature', 'kelvin'):
      return Temperature.fromKelvin(v);
    case ('Mass', 'kg'):
      return Mass.fromKg(v);
    case ('Mass', 'gram'):
      return Mass.fromGram(v);
    case ('Mass', 'lb'):
      return Mass.fromLb(v);
    case ('Mass', 'oz'):
      return Mass.fromOz(v);
    case ('Distance', 'meters'):
      return Distance.fromMeters(v);
    case ('Distance', 'km'):
      return Distance.fromKm(v);
    case ('Distance', 'mile'):
      return Distance.fromMile(v);
    case ('Distance', 'feet'):
      return Distance.fromFeet(v);
    case ('Distance', 'inch'):
      return Distance.fromInch(v);
    case ('Distance', 'mm'):
      return Distance.fromMm(v);
    case ('Pressure', 'kpa'):
      return Pressure.fromKpa(v);
    case ('Pressure', 'bar'):
      return Pressure.fromBar(v);
    case ('Pressure', 'psi'):
      return Pressure.fromPsi(v);
    case ('Power', 'kw'):
      return Power.fromKw(v);
    case ('Power', 'ps'):
      return Power.fromPs(v);
    case ('Power', 'hp'):
      return Power.fromHp(v);
    case ('Torque', 'nm'):
      return Torque.fromNm(v);
    case ('Torque', 'kgfm'):
      return Torque.fromKgfm(v);
    case ('Torque', 'lbft'):
      return Torque.fromLbft(v);
    case ('Angle', 'radians'):
      return Angle.fromRadians(v);
    case ('Angle', 'degrees'):
      return Angle.fromDegrees(v);
    case ('Efficiency', 'kml'):
      return Efficiency.fromKml(v);
    case ('Efficiency', 'l100km'):
      return Efficiency.fromL100km(v);
    case ('Efficiency', 'mpg'):
      return Efficiency.fromMpg(v);
    case ('EvEfficiency', 'km_per_kwh'):
      return EvEfficiency.fromKmkWh(v);
    case ('EvEfficiency', 'wh_per_km'):
      return EvEfficiency.fromWhkm(v);
    case ('EvEfficiency', 'kwh_per_100km'):
      return EvEfficiency.fromKwh100km(v);
    case ('EvEfficiency', 'miles_per_kwh'):
      return EvEfficiency.fromMpKwh(v);
    case ('Volume', 'liters'):
      return Volume.fromLiters(v);
    case ('Volume', 'ml'):
      return Volume.fromMl(v);
    case ('Volume', 'us_gallons'):
      return Volume.fromUsGallons(v);
    case ('Volume', 'imp_gallons'):
      return Volume.fromImpGallons(v);
    case ('Time', 'seconds'):
      return Time.fromSeconds(v);
    case ('Time', 'minutes'):
      return Time.fromMinutes(v);
    case ('Time', 'hours'):
      return Time.fromHours(v);
    case ('Acceleration', 'ms2'):
      return Acceleration.fromMs2(v);
    default:
      throw ArgumentError('unknown quantity/unit $quantity/$unit');
  }
}

double readVal(Object o, String quantity, String unit) {
  switch ((quantity, unit)) {
    case ('Speed', 'ms'):
      return (o as Speed).toMs;
    case ('Speed', 'kmh'):
      return (o as Speed).toKmH;
    case ('Speed', 'mph'):
      return (o as Speed).toMph;
    case ('Temperature', 'celsius'):
      return (o as Temperature).toCelsius;
    case ('Temperature', 'fahrenheit'):
      return (o as Temperature).toFahrenheit;
    case ('Temperature', 'kelvin'):
      return (o as Temperature).toKelvin;
    case ('Mass', 'kg'):
      return (o as Mass).toKg;
    case ('Mass', 'gram'):
      return (o as Mass).toGram;
    case ('Mass', 'lb'):
      return (o as Mass).toLb;
    case ('Mass', 'oz'):
      return (o as Mass).toOz;
    case ('Distance', 'meters'):
      return (o as Distance).toMeters;
    case ('Distance', 'km'):
      return (o as Distance).toKm;
    case ('Distance', 'mile'):
      return (o as Distance).toMile;
    case ('Distance', 'feet'):
      return (o as Distance).toFeet;
    case ('Distance', 'inch'):
      return (o as Distance).toInch;
    case ('Distance', 'mm'):
      return (o as Distance).toMm;
    case ('Pressure', 'kpa'):
      return (o as Pressure).toKpa;
    case ('Pressure', 'bar'):
      return (o as Pressure).toBar;
    case ('Pressure', 'psi'):
      return (o as Pressure).toPsi;
    case ('Power', 'kw'):
      return (o as Power).toKw;
    case ('Power', 'ps'):
      return (o as Power).toPs;
    case ('Power', 'hp'):
      return (o as Power).toHp;
    case ('Torque', 'nm'):
      return (o as Torque).toNm;
    case ('Torque', 'kgfm'):
      return (o as Torque).toKgfm;
    case ('Torque', 'lbft'):
      return (o as Torque).toLbft;
    case ('Angle', 'radians'):
      return (o as Angle).toRadians;
    case ('Angle', 'degrees'):
      return (o as Angle).toDegrees;
    case ('Efficiency', 'kml'):
      return (o as Efficiency).toKml;
    case ('Efficiency', 'l100km'):
      return (o as Efficiency).toL100km;
    case ('Efficiency', 'mpg'):
      return (o as Efficiency).toMpg;
    case ('EvEfficiency', 'km_per_kwh'):
      return (o as EvEfficiency).toKmkWh;
    case ('EvEfficiency', 'wh_per_km'):
      return (o as EvEfficiency).toWhkm;
    case ('EvEfficiency', 'kwh_per_100km'):
      return (o as EvEfficiency).toKwh100km;
    case ('EvEfficiency', 'miles_per_kwh'):
      return (o as EvEfficiency).toMpKwh;
    case ('Volume', 'liters'):
      return (o as Volume).toLiters;
    case ('Volume', 'ml'):
      return (o as Volume).toMl;
    case ('Volume', 'us_gallons'):
      return (o as Volume).toUsGallons;
    case ('Volume', 'imp_gallons'):
      return (o as Volume).toImpGallons;
    case ('Time', 'seconds'):
      return (o as Time).toSeconds;
    case ('Time', 'minutes'):
      return (o as Time).toMinutes;
    case ('Time', 'hours'):
      return (o as Time).toHours;
    case ('Acceleration', 'ms2'):
      return (o as Acceleration).toMs2;
    case ('scalar', _):
      return (o as num).toDouble();
    default:
      throw ArgumentError('read: mismatched $quantity/$unit');
  }
}

/// Apply one operator case. Operators are Dart extensions, so each
/// combination is spelled out with statically typed locals.
Object applyOp(Map<String, dynamic> c) {
  final op = c['op'] as String;
  final lhs = construct((c['lhs'] as Map).cast<String, dynamic>());
  if (op == 'mul_scalar' || op == 'div_scalar') {
    final s = parseValue(c['rhs']);
    if (lhs is Speed) return op == 'mul_scalar' ? lhs * s : lhs / s;
    if (lhs is Distance) return op == 'mul_scalar' ? lhs * s : lhs / s;
    if (lhs is Efficiency) return op == 'mul_scalar' ? lhs * s : lhs / s;
    throw ArgumentError('scalar op unsupported for ${lhs.runtimeType}');
  }
  final rhs = construct((c['rhs'] as Map).cast<String, dynamic>());
  if (op == 'add' || op == 'sub') {
    if (lhs is Speed && rhs is Speed) return op == 'add' ? lhs + rhs : lhs - rhs;
    if (lhs is Mass && rhs is Mass) return op == 'add' ? lhs + rhs : lhs - rhs;
    if (lhs is Time && rhs is Time) return op == 'add' ? lhs + rhs : lhs - rhs;
    if (lhs is Angle && rhs is Angle) return op == 'add' ? lhs + rhs : lhs - rhs;
    if (lhs is Temperature && rhs is Temperature) {
      return op == 'add' ? lhs + rhs : lhs - rhs;
    }
    if (lhs is Acceleration && rhs is Acceleration) {
      return op == 'add' ? lhs + rhs : lhs - rhs;
    }
    if (lhs is Distance && rhs is Distance) {
      return op == 'add' ? lhs + rhs : lhs - rhs;
    }
    throw ArgumentError('add/sub unsupported: ${lhs.runtimeType}, ${rhs.runtimeType}');
  }
  if (op == 'mul') {
    if (lhs is Speed && rhs is Time) return lhs * rhs;
    if (lhs is Time && rhs is Speed) return lhs * rhs;
    if (lhs is Acceleration && rhs is Time) return lhs * rhs;
    throw ArgumentError('mul unsupported: ${lhs.runtimeType}, ${rhs.runtimeType}');
  }
  if (op == 'div') {
    if (lhs is Distance && rhs is Time) return lhs / rhs;
    if (lhs is Speed && rhs is Time) return lhs / rhs;
    if (lhs is Distance && rhs is Speed) return lhs / rhs;
    if (lhs is Speed && rhs is Acceleration) return lhs / rhs;
    if (lhs is Distance && rhs is Distance) return lhs / rhs;
    if (lhs is Speed && rhs is Speed) return lhs / rhs;
    if (lhs is Time && rhs is Time) return lhs / rhs;
    if (lhs is Volume && rhs is Volume) return lhs / rhs;
    if (lhs is Acceleration && rhs is Acceleration) return lhs / rhs;
    if (lhs is Efficiency && rhs is Efficiency) return lhs / rhs;
    if (lhs is EvEfficiency && rhs is EvEfficiency) return lhs / rhs;
    throw ArgumentError('div unsupported: ${lhs.runtimeType}, ${rhs.runtimeType}');
  }
  throw ArgumentError('unknown op $op');
}

void main() {
  final doc = jsonDecode(findVectors().readAsStringSync()) as Map<String, dynamic>;
  final relTol = (doc['rel_tol'] as num?)?.toDouble() ?? 1e-9;
  final absTol = (doc['abs_tol'] as num?)?.toDouble() ?? 1e-12;
  final cases = (doc['cases'] as List).cast<Map<String, dynamic>>();

  void checkClose(double actual, double expected, String label) {
    final tol = absTol + relTol * expected.abs();
    expect(actual.isFinite && (actual - expected).abs() <= tol, isTrue,
        reason: '$label: got $actual, expected $expected (tol $tol)');
  }

  group('Golden vectors conformance (${cases.length} cases)', () {
    for (var i = 0; i < cases.length; i++) {
      final c = cases[i];
      test('case $i ${c['kind']}', () {
        final label = 'case $i: $c';
        switch (c['kind']) {
          case 'convert':
            final obj = construct({
              'quantity': c['quantity'],
              'unit': c['from'],
              'value': c['value'],
            });
            checkClose(readVal(obj, c['quantity'] as String, c['to'] as String),
                (c['expected'] as num).toDouble(), label);
          case 'error':
            expect(
                () => construct({
                      'quantity': c['quantity'],
                      'unit': c['from'],
                      'value': c['value'],
                    }),
                throwsA(anything),
                reason: label);
          case 'op':
            if (c.containsKey('error')) {
              expect(() => applyOp(c), throwsA(anything), reason: label);
            } else {
              final result = applyOp(c);
              final actual = c['expected_quantity'] == 'scalar'
                  ? readVal(result, 'scalar', '')
                  : readVal(result, c['expected_quantity'] as String,
                      c['expected_unit'] as String);
              checkClose(actual, (c['expected'] as num).toDouble(), label);
            }
          default:
            fail('unknown kind ${c['kind']}');
        }
      });
    }
  });
}
