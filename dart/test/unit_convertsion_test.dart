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

import 'package:test/test.dart';
import '../lib/unit_conversion.dart';
import 'dart:math' as math;

void main() {
  group('Speed Conversion Tests', () {
    const double epsilon = 0.001;

    test('test Km/h to Mph conversion', () {
      final speed = Speed.fromKmH(60.0);
      // 60 km/h -> 37.2823 mph
      expect(speed.toMph, closeTo(37.2823, epsilon));
    });

    test('test Mph to Km/h conversion', () {
      final speed = Speed.fromMph(60.0);
      // 60 mph -> 96.5606 km/h
      expect(speed.toKmH, closeTo(96.5606, epsilon));
    });

    test('test zero value', () {
      final speed = Speed.fromKmH(0.0);
      expect(speed.toMph, equals(0.0));
      expect(speed.toMs, equals(0.0));
    });

    test('test identicality', () {
      const double original = 120.5;
      final speed = Speed.fromKmH(original);
      expect(speed.toKmH, closeTo(original, 0.000001));
    });
  });

  group('Temperature Conversion Tests', () {
    test('Fahrenheit to Celsius', () {
      final t = Temperature.fromFahrenheit(32.0);
      expect(t.toCelsius, closeTo(0.0, 0.001));
    });

    test('Celsius to Fahrenheit', () {
      final t = Temperature.fromCelsius(100.0);
      expect(t.toFahrenheit, closeTo(212.0, 0.001));
    });

    test('Celsius to Kelvin', () {
      final t = Temperature.fromCelsius(0.0);
      expect(t.toKelvin, equals(273.15));
    });
  });

 group('Mass Conversion Tests', () {
    test('Gram to Kg', () {
      final m = Mass.fromGram(1000.0);
      expect(m.toKg, equals(1.0));
    });

    test('Lb to Kg', () {
      final m = Mass.fromLb(1.0);
      expect(m.toKg, closeTo(0.453592, 0.000001));
    });

    test('Kg to Lb', () {
      final m = Mass.fromKg(1.0);
      expect(m.toLb, closeTo(2.20462, 0.00001));
    });

    test('Lb to Oz', () {
      final m = Mass.fromLb(1.0);
      expect(m.toOz, closeTo(16.0, 0.000001));
    });
  });

  group('Distance Conversion Tests', () {
    test('Mile to Km', () {
      final d = Distance.fromMile(1.0);
      expect(d.toKm, closeTo(1.609344, 0.000001));
    });

    test('Foot to Inch', () {
      final d = Distance.fromFeet(1.0);
      expect(d.toInch, closeTo(12.0, 0.000001));
    });
  });

  group('Pressure Conversion Tests', () {
    test('Bar to Kpa', () {
      final p = Pressure.fromBar(2.5);
      expect(p.toKpa, closeTo(250.0, 0.001));
    });
    test('Kpa To Psi', () {
      final p = Pressure.fromKpa(250.0);
      expect(p.toPsi, closeTo(36.2594, 0.001));
    });
  });

  test('Torque Conversion test', () {
    final t = Torque.fromNm(100.0);
    expect(t.toLbft, closeTo(73.7562, 0.0001));
  });

  test('Angle Conversion test', () {
    final a = Angle.fromDegrees(180.0);
    expect(a.toRadians, closeTo(math.pi, 0.000001));

    final a2 = Angle.fromRadians(math.pi / 2);
    expect(a2.toDegrees, closeTo(90.0, 0.000001));
  });

}
