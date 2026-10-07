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
  const double epsilon = 0.0001;

  group('Speed Conversion Tests', () {
    test('test Km/h to Mph conversion', () {
      final speed = Speed.fromKmH(60.0);
      expect(speed.toKmH, closeTo(60.0, epsilon));
      // 60 km/h -> 37.2823 mph
      expect(speed.toMph, closeTo(37.2823, epsilon));
      // km/h -> m/s
      expect(speed.toMs, closeTo(60.0*1000/3600, epsilon));
    });

    test('test Mph to Km/h conversion', () {
      final speed = Speed.fromMph(60.0);
      expect(speed.toMph, closeTo(60.0, epsilon));
      // 60 mph -> 96.5606 km/h
      expect(speed.toKmH, closeTo(96.5606, epsilon));
    });

    test('test m/s to Km/h conversion', () {
      final speed = Speed.fromMs(60.0*1000/3600);
      expect(speed.toKmH, closeTo(60.0, epsilon));
      // 60 km/h -> 37.2823 mph
      expect(speed.toMph, closeTo(37.2823, epsilon));
    });

    test('test zero value', () {
      final speed = Speed.fromKmH(0.0);
      expect(speed.toMph, equals(0.0));
      expect(speed.toMs, equals(0.0));
    });

    test('test identicality', () {
      const double original = 120.5;
      final speed = Speed.fromKmH(original);
      expect(speed.toKmH, closeTo(original, epsilon));
    });

    test('Speed Invalid Guards', () {
      expect(() => Speed.fromMs(-1.0), throwsArgumentError);
      expect(() => Speed.fromKmH(-10.0), throwsArgumentError);
      expect(() => Speed.fromMph(-5.0), throwsArgumentError);
      expect(() => Speed.fromMs(double.nan), throwsArgumentError);
      expect(() => Speed.fromMs(double.infinity), throwsArgumentError);
    });

    test('Speed Comparison, Equality and Operators', () {
      final s1 = Speed.fromKmH(50.0);
      final s2 = Speed.fromKmH(50.0);
      final s3 = Speed.fromKmH(100.0);

      expect(s1 == s2, isTrue);
      expect(s1 == s3, isFalse);
      expect(s1 == 'not a speed', isFalse);
      expect(s1.hashCode, equals(s2.hashCode));

      expect(s1.compareTo(s3), lessThan(0));
      expect(s3.compareTo(s1), greaterThan(0));
      expect(s1.compareTo(s2), equals(0));

      expect(s1 < s3, isTrue);
      expect(s1 <= s2, isTrue);
      expect(s3 > s1, isTrue);
      expect(s3 >= s1, isTrue);
      expect(s3 < s1, isFalse);
      expect(s3 <= s1, isFalse);
      expect(s1 > s3, isFalse);
      expect(s1 >= s3, isFalse);

      // Speed subtraction and addition
      final sub = Speed.fromKmH(100.0) - Speed.fromKmH(40.0);
      expect(sub.toKmH, closeTo(60.0, epsilon));
      final add = Speed.fromKmH(40.0) + Speed.fromKmH(60.0);
      expect(add.toKmH, closeTo(100.0, epsilon));

      // Speed compound assignment
      var speed = Speed.fromMs(10.0);
      speed += Speed.fromMs(5.0);
      expect(speed.toMs, closeTo(15.0, 1e-9));

      speed -= Speed.fromMs(3.0);
      expect(speed.toMs, closeTo(12.0, 1e-9));

      speed *= 2.0;
      expect(speed.toMs, closeTo(24.0, 1e-9));

      speed /= 2.0;
      expect(speed.toMs, closeTo(12.0, 1e-9));
    });

    test('Speed Scalar Multiplication', () {
      final v = Speed.fromMs(10.0) * 0.5;
      expect(v.toMs, closeTo(5.0, 1e-9));

      final zero = Speed.fromMs(10.0) * 0.0;
      expect(zero.toMs, closeTo(0.0, 1e-9));
    });

    test('Speed Scalar Division', () {
      final v = Speed.fromMs(10.0) / 2.0;
      expect(v.toMs, closeTo(5.0, 1e-9));

      expect(() => Speed.fromMs(10.0) / 0.0, throwsArgumentError);
    });

    test('Speed / Speed -> Ratio (double)', () {
      final s1 = Speed.fromMs(20.0);
      final s2 = Speed.fromMs(5.0);
      final ratio = s1 / s2;
      expect(ratio, closeTo(4.0, 1e-9));

      expect(() => Speed.fromMs(20.0) / Speed.fromMs(0.0), throwsArgumentError);
    });
  });


  group('Temperature Conversion Tests', () {
    test('Fahrenheit to Celsius', () {
      final t = Temperature.fromFahrenheit(32.0);
      expect(t.toFahrenheit, closeTo(32.0, epsilon));
      expect(t.toCelsius, closeTo(0.0, epsilon));
    });

    test('Celsius to Fahrenheit', () {
      final t = Temperature.fromCelsius(100.0);
      expect(t.toCelsius, equals(100.0));
      expect(t.toFahrenheit, closeTo(212.0, epsilon));
    });

    test('Celsius to Kelvin', () {
      final t = Temperature.fromCelsius(0.0);
      expect(t.toCelsius, closeTo(0.0, epsilon));
      expect(t.toKelvin, equals(273.15));
    });

    test('Kelvin to Celsius', () {
      final t = Temperature.fromKelvin(0.0);
      expect(t.toKelvin, equals(0.0));
      expect(t.toCelsius, equals(-273.15));
    });

    test('Temperature Absolute Zero Guard', () {
      expect(() => Temperature.fromCelsius(-273.16), throwsArgumentError);
      expect(() => Temperature.fromKelvin(-0.1), throwsArgumentError);
      
      final t = Temperature.fromFahrenheit(-459.67); // Absolute Zero
      expect(t.toCelsius, closeTo(-273.15, 0.001));

      expect(() => Temperature.fromCelsius(double.nan), throwsArgumentError);
      expect(() => Temperature.fromCelsius(double.infinity), throwsArgumentError);
      expect(() => Temperature.fromKelvin(double.infinity), throwsArgumentError);
    });

    test('Temperature Comparison and Operators', () {
      final t1 = Temperature.fromCelsius(25.0);
      final t2 = Temperature.fromCelsius(25.0);
      final t3 = Temperature.fromCelsius(30.0);

      expect(t1 == t2, isTrue);
      expect(t1 == t3, isFalse);
      expect(t1 == 'not a temp', isFalse);
      expect(t1.hashCode, equals(t2.hashCode));

      expect(t1.compareTo(t3), lessThan(0));
      expect(t3.compareTo(t1), greaterThan(0));
      expect(t1.compareTo(t2), equals(0));

      expect(t1 < t3, isTrue);
      expect(t1 <= t2, isTrue);
      expect(t3 > t1, isTrue);
      expect(t3 >= t1, isTrue);
      expect(t3 < t1, isFalse);
      expect(t3 <= t1, isFalse);
      expect(t1 > t3, isFalse);
      expect(t1 >= t3, isFalse);
    });
  });


  group('Mass Conversion Tests', () {
    test('Gram to Kg', () {
      final m = Mass.fromGram(1000.0);
      expect(m.toGram, equals(1000.0));
      expect(m.toKg, equals(1.0));
    });

    test('Lb to Kg', () {
      final m = Mass.fromLb(1.0);
      expect(m.toLb, closeTo(1.0, epsilon));
      expect(m.toKg, closeTo(0.453592, epsilon));
    });

    test('Kg to Lb', () {
      final m = Mass.fromKg(1.0);
      expect(m.toKg, closeTo(1.0, epsilon));
      expect(m.toLb, closeTo(2.20462, epsilon));
    });

    test('Lb to Oz', () {
      final m = Mass.fromLb(1.0);
      expect(m.toLb, closeTo(1.0, epsilon));
      expect(m.toOz, closeTo(16.0, epsilon));
    });

    test('Oz to Kg', () {
      final m = Mass.fromOz(16.0);
      expect(m.toOz, closeTo(16.0, epsilon));
      expect(m.toKg, closeTo(0.453592, epsilon));
    });

    test('Mass Invalid Guards', () {
      expect(() => Mass.fromKg(-1.0), throwsArgumentError);
      expect(() => Mass.fromGram(-100.0), throwsArgumentError);
      expect(() => Mass.fromLb(-1.0), throwsArgumentError);
      expect(() => Mass.fromOz(-1.0), throwsArgumentError);
      expect(() => Mass.fromKg(double.nan), throwsArgumentError);
      expect(() => Mass.fromKg(double.infinity), throwsArgumentError);
    });

    test('Mass Comparison and Operators', () {
      final m1 = Mass.fromKg(10.0);
      final m2 = Mass.fromKg(10.0);
      final m3 = Mass.fromKg(20.0);

      expect(m1 == m2, isTrue);
      expect(m1 == m3, isFalse);
      expect(m1 == 'not a mass', isFalse);
      expect(m1.hashCode, equals(m2.hashCode));

      expect(m1.compareTo(m3), lessThan(0));
      expect(m3.compareTo(m1), greaterThan(0));
      expect(m1.compareTo(m2), equals(0));

      expect(m1 < m3, isTrue);
      expect(m1 <= m2, isTrue);
      expect(m3 > m1, isTrue);
      expect(m3 >= m1, isTrue);
      expect(m3 < m1, isFalse);
      expect(m3 <= m1, isFalse);
      expect(m1 > m3, isFalse);
      expect(m1 >= m3, isFalse);

      final multiplied = Mass.fromKg(5.0) * 2.0;
      expect(multiplied.toKg, closeTo(10.0, 1e-9));

      var mass = Mass.fromKg(10.0);
      mass += Mass.fromKg(5.0);
      expect(mass.toKg, closeTo(15.0, 1e-9));

      mass -= Mass.fromKg(3.0);
      expect(mass.toKg, closeTo(12.0, 1e-9));

      mass *= 2.0;
      expect(mass.toKg, closeTo(24.0, 1e-9));

      mass /= 2.0;
      expect(mass.toKg, closeTo(12.0, 1e-9));
    });

    test('Mass Scalar Division', () {
      final m = Mass.fromKg(10.0) / 2.0;
      expect(m.toKg, closeTo(5.0, 1e-9));

      expect(() => Mass.fromKg(10.0) / 0.0, throwsArgumentError);
    });

    test('Mass / Mass -> Ratio (double)', () {
      final m1 = Mass.fromKg(20.0);
      final m2 = Mass.fromKg(4.0);
      final ratio = m1 / m2;
      expect(ratio, closeTo(5.0, 1e-9));

      expect(() => Mass.fromKg(10.0) / Mass.fromKg(0.0), throwsArgumentError);
    });
  });


  group('Distance Conversion Tests', () {
    test('Meter to km', () {
      final d = Distance.fromMeters(100.0);
      expect(d.toMeters, closeTo(100.0, epsilon));
      expect(d.toKm, closeTo(0.1, epsilon));
    });

    test('Km to mile', () {
      final d = Distance.fromKm(1.0);
      expect(d.toKm, closeTo(1.0, epsilon));
      expect(d.toMile, closeTo(0.621371, epsilon));
    });

    test('Mile to Km', () {
      final d = Distance.fromMile(1.0);
      expect(d.toMile, closeTo(1.0, epsilon));
      expect(d.toKm, closeTo(1.609344, epsilon));
    });

    test('Feet to Inch', () {
      final d = Distance.fromFeet(1.0);
      expect(d.toFeet, closeTo(1.0, epsilon));
      expect(d.toInch, closeTo(12.0, epsilon));
    });

    test('MmToMeter', () {
      expect(() => Distance.fromMm(-1.0), throwsArgumentError);
      final d = Distance.fromMm(1000.0);
      expect(d.toMm, 1000.0);
      expect(d.toMeters, 1.0);
    });

    test('Distance Invalid Guards', () {
      expect(() => Distance.fromMeters(-1.0), throwsArgumentError);
      expect(() => Distance.fromKm(double.nan), throwsArgumentError);
      expect(() => Distance.fromMile(double.infinity), throwsArgumentError);
    });

    test('Distance Comparison, Equality and Operators', () {
      final d1 = Distance.fromMeters(100.0);
      final d2 = Distance.fromMeters(100.0);
      final d3 = Distance.fromMeters(200.0);

      expect(d1 == d2, isTrue);
      expect(d1 == d3, isFalse);
      expect(d1 == 'not a distance', isFalse);
      expect(d1.hashCode, equals(d2.hashCode));

      expect(d1.compareTo(d3), lessThan(0));
      expect(d3.compareTo(d1), greaterThan(0));
      expect(d1.compareTo(d2), equals(0));

      expect(d1 < d3, isTrue);
      expect(d1 <= d2, isTrue);
      expect(d3 > d1, isTrue);
      expect(d3 >= d1, isTrue);
      expect(d3 < d1, isFalse);
      expect(d3 <= d1, isFalse);
      expect(d1 > d3, isFalse);
      expect(d1 >= d3, isFalse);

      final multiplied = Distance.fromMeters(50.0) * 2.0;
      expect(multiplied.toMeters, closeTo(100.0, 1e-9));

      var distance = Distance.fromMeters(100.0);
      distance += Distance.fromMeters(50.0);
      expect(distance.toMeters, closeTo(150.0, 1e-9));

      distance -= Distance.fromMeters(25.0);
      expect(distance.toMeters, closeTo(125.0, 1e-9));

      distance *= 2.0;
      expect(distance.toMeters, closeTo(250.0, 1e-9));

      distance /= 2.0;
      expect(distance.toMeters, closeTo(125.0, 1e-9));
    });

    test('Distance Scalar Division', () {
      final d = Distance.fromMeters(100.0) / 2.0;
      expect(d.toMeters, closeTo(50.0, 1e-9));

      expect(() => Distance.fromMeters(100.0) / 0.0, throwsArgumentError);
    });

    test('Distance / Time -> Speed', () {
      final d = Distance.fromMeters(100.0);
      final t = Time.fromSeconds(10.0);
      final s = d / t;
      expect(s.toMs, closeTo(10.0, 1e-9));

      expect(() => Distance.fromMeters(100.0) / Time.fromSeconds(0.0), throwsArgumentError);
    });

    test('Distance / Speed -> Time', () {
      final d = Distance.fromMeters(100.0);
      final s = Speed.fromMs(20.0);
      final t = d / s;
      expect(t.toSeconds, closeTo(5.0, 1e-9));

      expect(() => Distance.fromMeters(100.0) / Speed.fromMs(0.0), throwsArgumentError);
    });

    test('Distance / Distance -> Ratio (double)', () {
      final d1 = Distance.fromMeters(150.0);
      final d2 = Distance.fromMeters(50.0);
      final ratio = d1 / d2;
      expect(ratio, closeTo(3.0, 1e-9));

      expect(() => Distance.fromMeters(100.0) / Distance.fromMeters(0.0), throwsArgumentError);
    });
  });


  group('Pressure Conversion Tests', () {
    test('Psi to Kpa', () {
      final p = Pressure.fromPsi(36.2594);
      expect(p.toPsi, closeTo(36.2594, epsilon));
      expect(p.toKpa, closeTo(250.0, 0.001));
    });

    test('Bar to Kpa', () {
      final p = Pressure.fromBar(2.5);
      expect(p.toBar, closeTo(2.5, epsilon));
      expect(p.toKpa, closeTo(250.0, epsilon));
    });

    test('Kpa To Psi/Bar', () {
      final p = Pressure.fromKpa(250.0);
      expect(p.toKpa, closeTo(250.0, epsilon));
      expect(p.toPsi, closeTo(36.2594, epsilon));
      expect(p.toBar, closeTo(2.5, epsilon));
    });

    test('Pressure Invalid Guards', () {
      expect(() => Pressure.fromKpa(-1.0), throwsArgumentError);
      expect(() => Pressure.fromBar(-0.1), throwsArgumentError);
      expect(() => Pressure.fromPsi(-1.0), throwsArgumentError);
      expect(() => Pressure.fromKpa(double.nan), throwsArgumentError);
      expect(() => Pressure.fromKpa(double.infinity), throwsArgumentError);
    });

    test('Pressure Comparison and Operators', () {
      final p1 = Pressure.fromKpa(100.0);
      final p2 = Pressure.fromKpa(100.0);
      final p3 = Pressure.fromKpa(200.0);

      expect(p1 == p2, isTrue);
      expect(p1 == p3, isFalse);
      expect(p1 == 'not pressure', isFalse);
      expect(p1.hashCode, equals(p2.hashCode));

      expect(p1.compareTo(p3), lessThan(0));
      expect(p3.compareTo(p1), greaterThan(0));
      expect(p1.compareTo(p2), equals(0));

      expect(p1 < p3, isTrue);
      expect(p1 <= p2, isTrue);
      expect(p3 > p1, isTrue);
      expect(p3 >= p1, isTrue);
      expect(p3 < p1, isFalse);
      expect(p3 <= p1, isFalse);
      expect(p1 > p3, isFalse);
      expect(p1 >= p3, isFalse);

      final add = Pressure.fromKpa(100.0) + Pressure.fromKpa(50.0);
      expect(add.toKpa, closeTo(150.0, 1e-9));

      final sub = Pressure.fromKpa(100.0) - Pressure.fromKpa(40.0);
      expect(sub.toKpa, closeTo(60.0, 1e-9));

      final multiplied = Pressure.fromKpa(50.0) * 2.0;
      expect(multiplied.toKpa, closeTo(100.0, 1e-9));

      var pressure = Pressure.fromKpa(100.0);
      pressure += Pressure.fromKpa(50.0);
      expect(pressure.toKpa, closeTo(150.0, 1e-9));

      pressure -= Pressure.fromKpa(25.0);
      expect(pressure.toKpa, closeTo(125.0, 1e-9));

      pressure *= 2.0;
      expect(pressure.toKpa, closeTo(250.0, 1e-9));

      pressure /= 2.0;
      expect(pressure.toKpa, closeTo(125.0, 1e-9));
    });

    test('Pressure Scalar Division', () {
      final p = Pressure.fromKpa(100.0) / 2.0;
      expect(p.toKpa, closeTo(50.0, 1e-9));

      expect(() => Pressure.fromKpa(100.0) / 0.0, throwsArgumentError);
    });

    test('Pressure / Pressure -> Ratio (double)', () {
      final p1 = Pressure.fromKpa(200.0);
      final p2 = Pressure.fromKpa(50.0);
      final ratio = p1 / p2;
      expect(ratio, closeTo(4.0, 1e-9));

      expect(() => Pressure.fromKpa(200.0) / Pressure.fromKpa(0.0), throwsArgumentError);
    });
  });


  group('Power Conversion tests', () {
    test('Power Matrix and Guards', () {
      final p = Power.fromPs(100);
      expect(p.toKw, closeTo(73.549, 0.001));
      expect(p.toHp, closeTo(p.toKw / 0.74569987, 0.001));
      
      expect(() => Power.fromKw(double.nan), throwsArgumentError);
      expect(() => Power.fromKw(double.infinity), throwsArgumentError);
      expect(() => Power.fromKw(-5.0), throwsArgumentError);

      expect(() => Power.fromPs(double.nan), throwsArgumentError);
      expect(() => Power.fromPs(double.infinity), throwsArgumentError);
      expect(() => Power.fromPs(-5.0), throwsArgumentError);

      expect(() => Power.fromHp(double.nan), throwsArgumentError);
      expect(() => Power.fromHp(double.infinity), throwsArgumentError);
      expect(() => Power.fromHp(-5.0), throwsArgumentError);
    });

    test('Power Comparison and Operators', () {
      final p1 = Power.fromKw(50.0);
      final p2 = Power.fromKw(50.0);
      final p3 = Power.fromKw(100.0);

      expect(p1 == p2, isTrue);
      expect(p1 == p3, isFalse);
      expect(p1 == 'not power', isFalse);
      expect(p1.hashCode, equals(p2.hashCode));

      expect(p1.compareTo(p3), lessThan(0));
      expect(p3.compareTo(p1), greaterThan(0));
      expect(p1.compareTo(p2), equals(0));

      expect(p1 < p3, isTrue);
      expect(p1 <= p2, isTrue);
      expect(p3 > p1, isTrue);
      expect(p3 >= p1, isTrue);
      expect(p3 < p1, isFalse);
      expect(p3 <= p1, isFalse);
      expect(p1 > p3, isFalse);
      expect(p1 >= p3, isFalse);

      final add = Power.fromKw(50.0) + Power.fromKw(25.0);
      expect(add.toKw, closeTo(75.0, 1e-9));

      final sub = Power.fromKw(100.0) - Power.fromKw(25.0);
      expect(sub.toKw, closeTo(75.0, 1e-9));

      final multiplied = Power.fromKw(50.0) * 2.0;
      expect(multiplied.toKw, closeTo(100.0, 1e-9));

      var power = Power.fromKw(50.0);
      power += Power.fromKw(25.0);
      expect(power.toKw, closeTo(75.0, 1e-9));

      power -= Power.fromKw(15.0);
      expect(power.toKw, closeTo(60.0, 1e-9));

      power *= 2.0;
      expect(power.toKw, closeTo(120.0, 1e-9));

      power /= 2.0;
      expect(power.toKw, closeTo(60.0, 1e-9));
    });

    test('Power Scalar Division', () {
      final p = Power.fromKw(100.0) / 2.0;
      expect(p.toKw, closeTo(50.0, 1e-9));

      expect(() => Power.fromKw(100.0) / 0.0, throwsArgumentError);
    });

    test('Power / Power -> Ratio (double)', () {
      final p1 = Power.fromKw(100.0);
      final p2 = Power.fromKw(25.0);
      final ratio = p1 / p2;
      expect(ratio, closeTo(4.0, 1e-9));

      expect(() => Power.fromKw(100.0) / Power.fromKw(0.0), throwsArgumentError);
    });
  });


  group('Torque Conversion tests', () {
    test('Nm to Kgfm/Lbft,', () {
      final t = Torque.fromNm(100.0);
      expect(t.toNm, closeTo(100.0, epsilon));
      expect(t.toKgfm, closeTo(10.1971, epsilon));
      expect(t.toLbft, closeTo(73.7562, epsilon));
    });

    test('Kgfm to Nm/Lbft,', () {
      final t = Torque.fromKgfm(10.19716);
      expect(t.toKgfm, closeTo(10.19716, epsilon));
      expect(t.toNm, closeTo(100.0, epsilon));
      expect(t.toLbft, closeTo(73.7562, epsilon));
    });

    test('Lbft to Nm/Kgfm,', () {
      final t = Torque.fromLbft(73.7562);
      expect(t.toLbft, closeTo(73.7562, epsilon));
      expect(t.toNm, closeTo(100.0, epsilon));
      expect(t.toKgfm, closeTo(10.1971, epsilon));
    });

    test('Torque guards,', () {
      expect(() => Torque.fromNm(double.nan), throwsArgumentError);
      expect(() => Torque.fromKgfm(double.infinity), throwsArgumentError);
      expect(() => Torque.fromLbft(-5.0), throwsArgumentError);
    });

    test('Torque Comparison and Operators', () {
      final t1 = Torque.fromNm(100.0);
      final t2 = Torque.fromNm(100.0);
      final t3 = Torque.fromNm(200.0);

      expect(t1 == t2, isTrue);
      expect(t1 == t3, isFalse);
      expect(t1 == 'not torque', isFalse);
      expect(t1.hashCode, equals(t2.hashCode));

      expect(t1.compareTo(t3), lessThan(0));
      expect(t3.compareTo(t1), greaterThan(0));
      expect(t1.compareTo(t2), equals(0));

      expect(t1 < t3, isTrue);
      expect(t1 <= t2, isTrue);
      expect(t3 > t1, isTrue);
      expect(t3 >= t1, isTrue);
      expect(t3 < t1, isFalse);
      expect(t3 <= t1, isFalse);
      expect(t1 > t3, isFalse);
      expect(t1 >= t3, isFalse);

      final add = Torque.fromNm(100.0) + Torque.fromNm(50.0);
      expect(add.toNm, closeTo(150.0, 1e-9));

      final sub = Torque.fromNm(100.0) - Torque.fromNm(40.0);
      expect(sub.toNm, closeTo(60.0, 1e-9));

      final multiplied = Torque.fromNm(50.0) * 2.0;
      expect(multiplied.toNm, closeTo(100.0, 1e-9));

      var torque = Torque.fromNm(100.0);
      torque += Torque.fromNm(50.0);
      expect(torque.toNm, closeTo(150.0, 1e-9));

      torque -= Torque.fromNm(25.0);
      expect(torque.toNm, closeTo(125.0, 1e-9));

      torque *= 2.0;
      expect(torque.toNm, closeTo(250.0, 1e-9));

      torque /= 2.0;
      expect(torque.toNm, closeTo(125.0, 1e-9));
    });

    test('Torque Scalar Division', () {
      final t = Torque.fromNm(100.0) / 2.0;
      expect(t.toNm, closeTo(50.0, 1e-9));

      expect(() => Torque.fromNm(100.0) / 0.0, throwsArgumentError);
    });

    test('Torque / Torque -> Ratio (double)', () {
      final t1 = Torque.fromNm(200.0);
      final t2 = Torque.fromNm(50.0);
      final ratio = t1 / t2;
      expect(ratio, closeTo(4.0, 1e-9));

      expect(() => Torque.fromNm(200.0) / Torque.fromNm(0.0), throwsArgumentError);
    });
  });


  group('Angle Conversion Tests', () {
    test('Angle Conversion test', () {
      final a = Angle.fromDegrees(180.0);
      expect(a.toDegrees, closeTo(180.0, epsilon));
      expect(a.toRadians, closeTo(math.pi, epsilon));

      final a2 = Angle.fromRadians(math.pi / 2);
      expect(a2.toRadians, closeTo(math.pi / 2, epsilon));
      expect(a2.toDegrees, closeTo(90.0, epsilon));

      expect(() => Angle.fromDegrees(double.nan), throwsArgumentError);
      expect(() => Angle.fromRadians(double.infinity), throwsArgumentError);
    });

    test('Angle Normalization test', () {
      final a1 = Angle.fromDegrees(450.0).normalizeDegrees();
      expect(a1.toDegrees, closeTo(90.0, epsilon));

      final a2 = Angle.fromDegrees(-90.0).normalizeDegrees();
      expect(a2.toDegrees, closeTo(270.0, epsilon));

      final a3 = Angle.fromDegrees(360.0).normalizeDegrees();
      expect(a3.toDegrees, closeTo(0.0, epsilon));

      final r1 = Angle.fromRadians(math.pi * 2.5).normalizeRadians();
      expect(r1.toRadians, closeTo(math.pi * 0.5, epsilon));

      final r2 = Angle.fromRadians(-math.pi * 0.5).normalizeRadians();
      expect(r2.toRadians, closeTo(math.pi * 1.5, epsilon));
    });

    test('Angle Signed Normalization test', () {
      final a1 = Angle.fromRadians(math.pi * 1.5).normalizedSigned();
      expect(a1.toRadians, closeTo(-math.pi * 0.5, epsilon));

      final a2 = Angle.fromRadians(-math.pi * 1.5).normalizedSigned();
      expect(a2.toRadians, closeTo(math.pi * 0.5, epsilon));
    });

    test('Angle Comparison and Operators', () {
      final a1 = Angle.fromDegrees(45.0);
      final a2 = Angle.fromDegrees(45.0);
      final a3 = Angle.fromDegrees(90.0);

      expect(a1 == a2, isTrue);
      expect(a1 == a3, isFalse);
      expect(a1 == 'not angle', isFalse);
      expect(a1.hashCode, equals(a2.hashCode));

      expect(a1.compareTo(a3), lessThan(0));
      expect(a3.compareTo(a1), greaterThan(0));
      expect(a1.compareTo(a2), equals(0));

      expect(a1 < a3, isTrue);
      expect(a1 <= a2, isTrue);
      expect(a3 > a1, isTrue);
      expect(a3 >= a1, isTrue);
      expect(a3 < a1, isFalse);
      expect(a3 <= a1, isFalse);
      expect(a1 > a3, isFalse);
      expect(a1 >= a3, isFalse);

      final add = Angle.fromDegrees(45.0) + Angle.fromDegrees(30.0);
      expect(add.toDegrees, closeTo(75.0, 1e-9));

      final sub = Angle.fromDegrees(90.0) - Angle.fromDegrees(30.0);
      expect(sub.toDegrees, closeTo(60.0, 1e-9));

      final multiplied = Angle.fromDegrees(45.0) * 2.0;
      expect(multiplied.toDegrees, closeTo(90.0, 1e-9));

      var angle = Angle.fromDegrees(45.0);
      angle += Angle.fromDegrees(30.0);
      expect(angle.toDegrees, closeTo(75.0, 1e-9));

      angle -= Angle.fromDegrees(15.0);
      expect(angle.toDegrees, closeTo(60.0, 1e-9));

      angle *= 2.0;
      expect(angle.toDegrees, closeTo(120.0, 1e-9));

      angle /= 2.0;
      expect(angle.toDegrees, closeTo(60.0, 1e-9));
    });

    test('Angle Scalar Division', () {
      final a = Angle.fromDegrees(180.0) / 2.0;
      expect(a.toDegrees, closeTo(90.0, 1e-9));

      expect(() => Angle.fromDegrees(180.0) / 0.0, throwsArgumentError);
    });

    test('Angle / Angle -> Ratio (double)', () {
      final a1 = Angle.fromDegrees(180.0);
      final a2 = Angle.fromDegrees(45.0);
      final ratio = a1 / a2;
      expect(ratio, closeTo(4.0, 1e-9));

      expect(() => Angle.fromDegrees(180.0) / Angle.fromDegrees(0.0), throwsArgumentError);
    });
  });


  group('Efficiency conversion tests', () {
    test('Efficiency fromL100km', () {
      final e = Efficiency.fromL100km(10.0);
      expect(e.toKml, closeTo(10.0, epsilon));
      expect(e.toMpg, closeTo(23.5215, epsilon));
    });

    test('Efficiency MpgToKml', () {
      final e = Efficiency.fromMpg(23.5215);
      expect(e.toKml, closeTo(10.0, epsilon));
    });

    test('Efficiency KmlToL100andMPG', () {
      final e = Efficiency.fromKml(10.0);
      expect(e.toKml, closeTo(10.0, epsilon));
      expect(e.toL100km, closeTo(10.0, epsilon));
      expect(e.toMpg, closeTo(23.5215, epsilon));
    });

    test('Efficiency Invalid', () {
      expect(() => Efficiency.fromKml(0.0), throwsArgumentError);
      expect(() => Efficiency.fromL100km(0.0), throwsArgumentError);
      expect(() => Efficiency.fromMpg(0.0), throwsArgumentError);

      expect(() => Efficiency.fromKml(double.nan), throwsArgumentError);
      expect(() => Efficiency.fromL100km(double.nan), throwsArgumentError);
      expect(() => Efficiency.fromMpg(double.nan), throwsArgumentError);
      expect(() => Efficiency.fromKml(double.infinity), throwsArgumentError);
    });

    test('Efficiency Comparison and Operators', () {
      final e1 = Efficiency.fromKml(10.0);
      final e2 = Efficiency.fromKml(10.0);
      final e3 = Efficiency.fromKml(15.0);

      expect(e1 == e2, isTrue);
      expect(e1 == e3, isFalse);
      expect(e1 == 'not efficiency', isFalse);
      expect(e1.hashCode, equals(e2.hashCode));

      expect(e1.compareTo(e3), lessThan(0));
      expect(e3.compareTo(e1), greaterThan(0));
      expect(e1.compareTo(e2), equals(0));

      expect(e1 < e3, isTrue);
      expect(e1 <= e2, isTrue);
      expect(e3 > e1, isTrue);
      expect(e3 >= e1, isTrue);
      expect(e3 < e1, isFalse);
      expect(e3 <= e1, isFalse);
      expect(e1 > e3, isFalse);
      expect(e1 >= e3, isFalse);

      final multiplied = Efficiency.fromKml(10.0) * 2.0;
      expect(multiplied.toKml, closeTo(20.0, 1e-9));
    });

    test('Efficiency Scalar Division', () {
      final e = Efficiency.fromKml(10.0) / 2.0;
      expect(e.toKml, closeTo(5.0, 1e-9));

      expect(() => Efficiency.fromKml(10.0) / 0.0, throwsArgumentError);
    });

    test('Efficiency / Efficiency -> Ratio (double)', () {
      final e1 = Efficiency.fromKml(20.0);
      final e2 = Efficiency.fromKml(5.0);
      final ratio = e1 / e2;
      expect(ratio, closeTo(4.0, 1e-9));

      expect(() => Efficiency.fromKml(20.0) / Efficiency.fromKml(0.0), throwsArgumentError);
    });
  });


  group('EvEfficiency Tests', () {
    test('fromKmkWh', () {
      final e = EvEfficiency.fromKmkWh(6.0);
      expect(e.toKmkWh, equals(6.0));
      expect(e.toWhkm, closeTo(166.666, 0.001));
      expect(e.toKwh100km, closeTo(16.666, 0.001));
      expect(e.toMpKwh, closeTo(3.728, 0.001));
    });

    test('fromWhkm', () {
      final e = EvEfficiency.fromWhkm(200.0);
      expect(e.toKmkWh, closeTo(5.0, 0.001));
      expect(e.toWhkm, closeTo(200.0, 0.001));
      expect(e.toKwh100km, closeTo(20.0, 0.001));
      expect(e.toMpKwh, closeTo(3.106, 0.01));
    });

    test('fromKwh100km', () {
      final e = EvEfficiency.fromKwh100km(20.0);
      expect(e.toKmkWh, closeTo(5.0, 0.001));
      expect(e.toWhkm, closeTo(200.0, 0.001));
      expect(e.toKwh100km, closeTo(20.0, 0.001));
      expect(e.toMpKwh, closeTo(3.106, 0.01));
    });

    test('fromMpKwh', () {
      final e = EvEfficiency.fromMpKwh(1.0);
      expect(e.toKmkWh, closeTo(1.609344, 0.000001));
      expect(e.toWhkm, closeTo(621.371, 0.001));
      expect(e.toKwh100km, closeTo(62.137, 0.001));
      expect(e.toMpKwh, closeTo(1.0, 0.000001));
    });

    test('Invalid', () {
      expect(() => EvEfficiency.fromKmkWh(0.0), throwsArgumentError);
      expect(() => EvEfficiency.fromWhkm(0.0), throwsArgumentError);
      expect(() => EvEfficiency.fromKwh100km(0.0), throwsArgumentError);
      expect(() => EvEfficiency.fromMpKwh(0.0), throwsArgumentError);
      expect(() => EvEfficiency.fromKmkWh(-1.0), throwsArgumentError);
      expect(() => EvEfficiency.fromKmkWh(double.nan), throwsArgumentError);
      expect(() => EvEfficiency.fromKmkWh(double.infinity), throwsArgumentError);
    });

    test('EvEfficiency Comparison and Operators', () {
      final e1 = EvEfficiency.fromKmkWh(5.0);
      final e2 = EvEfficiency.fromKmkWh(5.0);
      final e3 = EvEfficiency.fromKmkWh(6.0);

      expect(e1 == e2, isTrue);
      expect(e1 == e3, isFalse);
      expect(e1 == 'not evefficiency', isFalse);
      expect(e1.hashCode, equals(e2.hashCode));

      expect(e1.compareTo(e3), lessThan(0));
      expect(e3.compareTo(e1), greaterThan(0));
      expect(e1.compareTo(e2), equals(0));

      expect(e1 < e3, isTrue);
      expect(e1 <= e2, isTrue);
      expect(e3 > e1, isTrue);
      expect(e3 >= e1, isTrue);
      expect(e3 < e1, isFalse);
      expect(e3 <= e1, isFalse);
      expect(e1 > e3, isFalse);
      expect(e1 >= e3, isFalse);

      final multiplied = EvEfficiency.fromKmkWh(5.0) * 2.0;
      expect(multiplied.toKmkWh, closeTo(10.0, 1e-9));
    });

    test('EvEfficiency Scalar Division', () {
      final e = EvEfficiency.fromKmkWh(10.0) / 2.0;
      expect(e.toKmkWh, closeTo(5.0, 1e-9));

      expect(() => EvEfficiency.fromKmkWh(10.0) / 0.0, throwsArgumentError);
    });

    test('EvEfficiency / EvEfficiency -> Ratio (double)', () {
      final e1 = EvEfficiency.fromKmkWh(20.0);
      final e2 = EvEfficiency.fromKmkWh(5.0);
      final ratio = e1 / e2;
      expect(ratio, closeTo(4.0, 1e-9));

      expect(() => EvEfficiency.fromKmkWh(20.0) / EvEfficiency.fromKmkWh(0.0), throwsArgumentError);
    });
  });


  group('Volume conversion tests', () {
    test('Volume fromLiters', () {
      final v1 = Volume.fromLiters(1.0);
      expect(v1.toLiters, equals(1.0));
      expect(v1.toMl, equals(1000.0));
      expect(v1.toUsGallons, closeTo(0.264172, 0.000001));
      expect(v1.toImpGallons, closeTo(0.219969, 0.000001));
    });

    test('Volume fromMl', () {
      final v2 = Volume.fromMl(1000.0);
      expect(v2.toLiters, equals(1.0));
      expect(v2.toMl, equals(1000.0));
      expect(v2.toUsGallons, closeTo(0.264172, 0.000001));
      expect(v2.toImpGallons, closeTo(0.219969, 0.000001));
    });

    test('Volume fromUsGallons', () {
      final v3 = Volume.fromUsGallons(1.0);
      expect(v3.toUsGallons, closeTo(1.0, 0.000001));
      expect(v3.toLiters, closeTo(3.78541, 0.00001));
      expect(v3.toMl, closeTo(3785.41, 0.01));
      expect(v3.toImpGallons, closeTo(0.832674, 0.000001));
    });

    test('Volume fromImpGallons', () {
      final v4 = Volume.fromImpGallons(1.0);
      expect(v4.toImpGallons, closeTo(1.0, 0.000001));
      expect(v4.toLiters, equals(4.54609));
      expect(v4.toMl, closeTo(4546.09, 0.000001));
      expect(v4.toUsGallons, closeTo(1.20095, 0.000001));
    });

    test('Volume Invalid Guards', () {
      expect(() => Volume.fromLiters(-1.0), throwsArgumentError);
      expect(() => Volume.fromMl(double.nan), throwsArgumentError);
      expect(() => Volume.fromUsGallons(double.infinity), throwsArgumentError);
    });

    test('Volume Comparison and Operators', () {
      final v1 = Volume.fromLiters(10.0);
      final v2 = Volume.fromLiters(10.0);
      final v3 = Volume.fromLiters(20.0);

      expect(v1 == v2, isTrue);
      expect(v1 == v3, isFalse);
      expect(v1 == 'not volume', isFalse);
      expect(v1.hashCode, equals(v2.hashCode));

      expect(v1.compareTo(v3), lessThan(0));
      expect(v3.compareTo(v1), greaterThan(0));
      expect(v1.compareTo(v2), equals(0));

      expect(v1 < v3, isTrue);
      expect(v1 <= v2, isTrue);
      expect(v3 > v1, isTrue);
      expect(v3 >= v1, isTrue);
      expect(v3 < v1, isFalse);
      expect(v3 <= v1, isFalse);
      expect(v1 > v3, isFalse);
      expect(v1 >= v3, isFalse);

      final add = Volume.fromLiters(10.0) + Volume.fromLiters(5.0);
      expect(add.toLiters, closeTo(15.0, 1e-9));

      final sub = Volume.fromLiters(10.0) - Volume.fromLiters(4.0);
      expect(sub.toLiters, closeTo(6.0, 1e-9));

      final multiplied = Volume.fromLiters(10.0) * 2.0;
      expect(multiplied.toLiters, closeTo(20.0, 1e-9));

      var volume = Volume.fromLiters(10.0);
      volume += Volume.fromLiters(5.0);
      expect(volume.toLiters, closeTo(15.0, 1e-9));

      volume -= Volume.fromLiters(3.0);
      expect(volume.toLiters, closeTo(12.0, 1e-9));

      volume *= 2.0;
      expect(volume.toLiters, closeTo(24.0, 1e-9));

      volume /= 2.0;
      expect(volume.toLiters, closeTo(12.0, 1e-9));
    });

    test('Volume Scalar Division', () {
      final v = Volume.fromLiters(10.0) / 2.0;
      expect(v.toLiters, closeTo(5.0, 1e-9));

      expect(() => Volume.fromLiters(10.0) / 0.0, throwsArgumentError);
    });

    test('Volume / Volume -> Ratio (double)', () {
      final v1 = Volume.fromLiters(20.0);
      final v2 = Volume.fromLiters(5.0);
      final ratio = v1 / v2;
      expect(ratio, closeTo(4.0, 1e-9));

      expect(() => Volume.fromLiters(20.0) / Volume.fromLiters(0.0), throwsArgumentError);
    });
  });


  group('Time conversion tests', () {
    test('Time normal', () {
      final t = Time.fromHours(1.0);
      expect(t.toSeconds, 3600.0);
      expect(t.toMinutes, 60.0);
      expect(t.toHours, 1.0);
      expect(Time.fromSeconds(0.0).toSeconds, 0.0);
    });

    test('Time illegal', () {
      expect(() => Time.fromSeconds(double.nan), throwsArgumentError);
      expect(() => Time.fromSeconds(-0.1), throwsArgumentError);
      expect(() => Time.fromSeconds(double.infinity), throwsArgumentError);
    });

    test('Time Scalar Division', () {
      final t = Time.fromSeconds(60.0) / 2.0;
      expect(t.toSeconds, closeTo(30.0, 1e-9));
      expect(() => Time.fromSeconds(60.0) / 0.0, throwsArgumentError);
    });

    test('Time Comparison, Equality and Operators', () {
      final t1 = Time.fromSeconds(30.0);
      final t2 = Time.fromSeconds(30.0);
      final t3 = Time.fromSeconds(60.0);

      expect(t1 == t2, isTrue);
      expect(t1 == t3, isFalse);
      expect(t1 == 'not time', isFalse);
      expect(t1.hashCode, equals(t2.hashCode));

      expect(t1.compareTo(t3), lessThan(0));
      expect(t3.compareTo(t1), greaterThan(0));
      expect(t1.compareTo(t2), equals(0));

      expect(t1 < t3, isTrue);
      expect(t1 <= t2, isTrue);
      expect(t3 > t1, isTrue);
      expect(t3 >= t1, isTrue);
      expect(t3 < t1, isFalse);
      expect(t3 <= t1, isFalse);
      expect(t1 > t3, isFalse);
      expect(t1 >= t3, isFalse);

      final multiplied = Time.fromSeconds(15.0) * 2.0;
      expect(multiplied.toSeconds, closeTo(30.0, 1e-9));

      var time = Time.fromSeconds(30.0);
      time += Time.fromSeconds(15.0);
      expect(time.toSeconds, closeTo(45.0, 1e-9));

      time -= Time.fromSeconds(5.0);
      expect(time.toSeconds, closeTo(40.0, 1e-9));

      time *= 2.0;
      expect(time.toSeconds, closeTo(80.0, 1e-9));

      time /= 2.0;
      expect(time.toSeconds, closeTo(40.0, 1e-9));

      // Time / Acceleration -> Speed test
      final s = Time.fromSeconds(10.0) / Acceleration.fromMs2(2.0);
      expect(s.toMs, closeTo(5.0, 1e-9));
      expect(() => Time.fromSeconds(10.0) / Acceleration.fromMs2(0.0), throwsArgumentError);
    });

    test('Time / Time -> Ratio (double)', () {
      final t1 = Time.fromSeconds(60.0);
      final t2 = Time.fromSeconds(15.0);
      final ratio = t1 / t2;
      expect(ratio, closeTo(4.0, 1e-9));

      expect(() => Time.fromSeconds(60.0) / Time.fromSeconds(0.0), throwsArgumentError);
    });
  });


  group('Acceleration conversion tests', () {
    test('Acceleration Conversion normal', () {
      final a = Acceleration.fromMs2(9.8);
      final s = a * Time.fromSeconds(2.0);
      expect(s.toMs, closeTo(19.6, 1e-9));
    });

    test('Acceleration fromSpeedAndTime', () {
      final s = Speed.fromMs(20.0);
      final t = Time.fromSeconds(4.0);
      final a = Acceleration.fromSpeedAndTime(s, t);
      expect(a.toMs2, closeTo(5.0, 1e-9));

      expect(() => Acceleration.fromSpeedAndTime(s, Time.fromSeconds(0.0)), throwsArgumentError);
    });
      
    test('Acceleration Conversion Exception', () {
      expect(() => Acceleration.fromMs2(double.nan), throwsArgumentError);
      expect(() => Acceleration.fromMs2(double.infinity), throwsArgumentError);

      final a = Acceleration.fromMs2(9.8);
      expect(() => a * Time.fromSeconds(-1.0), throwsArgumentError);
    });

    test('Acceleration Comparison, Equality and Operators', () {
      final a1 = Acceleration.fromMs2(5.0);
      final a2 = Acceleration.fromMs2(5.0);
      final a3 = Acceleration.fromMs2(10.0);

      expect(a1 == a2, isTrue);
      expect(a1 == a3, isFalse);
      expect(a1 == 'not acceleration', isFalse);
      expect(a1.hashCode, equals(a2.hashCode));

      expect(a1.compareTo(a3), lessThan(0));
      expect(a3.compareTo(a1), greaterThan(0));
      expect(a1.compareTo(a2), equals(0));

      expect(a1 < a3, isTrue);
      expect(a1 <= a2, isTrue);
      expect(a3 > a1, isTrue);
      expect(a3 >= a1, isTrue);
      expect(a3 < a1, isFalse);
      expect(a3 <= a1, isFalse);
      expect(a1 > a3, isFalse);
      expect(a1 >= a3, isFalse);

      final multiplied = Acceleration.fromMs2(4.0) * 2.0;
      expect(multiplied.toMs2, closeTo(8.0, 1e-9));

      // AccelMul scalar multiplication / acceleration * num
      final scaled = Acceleration.fromMs2(4.0) * 2.0;
      expect(scaled.toMs2, closeTo(8.0, 1e-9));

      final add = Acceleration.fromMs2(5.0) + Acceleration.fromMs2(3.0);
      expect(add.toMs2, closeTo(8.0, 1e-9));

      final sub = Acceleration.fromMs2(8.0) - Acceleration.fromMs2(3.0);
      expect(sub.toMs2, closeTo(5.0, 1e-9));

      final divided = Acceleration.fromMs2(10.0) / 2.0;
      expect(divided.toMs2, closeTo(5.0, 1e-9));

      final ratio = Acceleration.fromMs2(10.0) / Acceleration.fromMs2(2.0);
      expect(ratio, closeTo(5.0, 1e-9));

      expect(() => Acceleration.fromMs2(10.0) / 0.0, throwsArgumentError);
      expect(() => Acceleration.fromMs2(10.0) / Acceleration.fromMs2(0.0), throwsArgumentError);

      var acceleration = Acceleration.fromMs2(5.0);
      acceleration += Acceleration.fromMs2(3.0);
      expect(acceleration.toMs2, closeTo(8.0, 1e-9));

      acceleration -= Acceleration.fromMs2(2.0);
      expect(acceleration.toMs2, closeTo(6.0, 1e-9));

      acceleration *= 2.0;
      expect(acceleration.toMs2, closeTo(12.0, 1e-9));

      acceleration /= 2.0;
      expect(acceleration.toMs2, closeTo(6.0, 1e-9));
    });
  });


  test('Speed * Time', () {
    final d = Speed.fromMs(10.0) * Time.fromSeconds(5.0);
    expect(d.toMeters, closeTo(50.0, 1e-9));
    expect(() => Speed.fromMs(10.0) * Time.fromSeconds(-1.0), throwsArgumentError);
  });

  test('Speed += delta of speed, deta of speed = a*t', () {
    final v = Speed.fromMs(10.0);
    final vDelta = Acceleration.fromMs2(2.0) * Time.fromSeconds(5.0);
    final v2 = v + vDelta;
    expect(v2.toMs, closeTo(20.0, 1e-9));
  });

  test('Acceleration derived from Delta Speed', () {
    final v1 = Speed.fromMs(20.0);
    final v2 = Speed.fromMs(0.0);
    final t = Time.fromSeconds(5.0);
    final a = (v1 - v2) / t;
    expect(a.toMs2, closeTo(4.0, 1e-9));

    expect(() => (v1 - v2) / Time.fromSeconds(0.0), throwsArgumentError);
  });

  test('Speed derived from Speed / Acceleration', () {
    final v = Speed.fromMs(20.0);
    final a = Acceleration.fromMs2(4.0);
    final t = v / a;
    expect(t.toSeconds, closeTo(5.0, 1e-9));

    expect(() => v / Acceleration.fromMs2(0.0), throwsArgumentError);
  });

  test('Scalar Multiplication', () {
    final v = Speed.fromMs(10.0) * 0.5;
    expect(v.toMs, closeTo(5.0, 1e-9));

    final zero = Speed.fromMs(10.0) * 0.0;
    expect(zero.toMs, closeTo(0.0, 1e-9));
  });

  test('Speed Scalar Division', () {
    final v = Speed.fromMs(10.0) / 2.0;
    expect(v.toMs, closeTo(5.0, 1e-9));

    expect(() => Speed.fromMs(10.0) / 0.0, throwsArgumentError);
  });

  test('Acceleration Scalar Multiplication', () {
    final a = Acceleration.fromMs2(9.8) * 0.5;
    expect(a.toMs2, closeTo(4.9, 1e-9));

    final zero = Acceleration.fromMs2(9.8) * 0.0;
    expect(zero.toMs2, closeTo(0.0, 1e-9));
  });

  test('Acceleration Scalar Division', () {
    final a = Acceleration.fromMs2(9.8) / 2.0;
    expect(a.toMs2, closeTo(4.9, 1e-9));

    expect(() => Acceleration.fromMs2(9.8) / 0.0, throwsArgumentError);
  });

  group('Distance Operations Tests', () {
    test('Distance Addition and Subtraction', () {
      final d1 = Distance.fromMeters(100.0);
      final d2 = Distance.fromMeters(50.0);
      expect((d1 + d2).toMeters, closeTo(150.0, 1e-9));
      expect((d1 - d2).toMeters, closeTo(50.0, 1e-9));
    });

    test('Distance Scalar Multiplication', () {
      final d = Distance.fromMeters(100.0) * 2.5;
      expect(d.toMeters, closeTo(250.0, 1e-9));
    });

    test('Distance Scalar Division', () {
      final d = Distance.fromMeters(100.0) / 2.0;
      expect(d.toMeters, closeTo(50.0, 1e-9));

      expect(() => Distance.fromMeters(100.0) / 0.0, throwsArgumentError);
    });

    test('Distance / Time -> Speed', () {
      final d = Distance.fromMeters(100.0);
      final t = Time.fromSeconds(10.0);
      final s = d / t;
      expect(s.toMs, closeTo(10.0, 1e-9));

      expect(() => Distance.fromMeters(100.0) / Time.fromSeconds(0.0), throwsArgumentError);
    });

    test('Distance / Speed -> Time', () {
      final d = Distance.fromMeters(100.0);
      final s = Speed.fromMs(20.0);
      final t = d / s;
      expect(t.toSeconds, closeTo(5.0, 1e-9));

      expect(() => Distance.fromMeters(100.0) / Speed.fromMs(0.0), throwsArgumentError);
    });

    test('Distance / Distance -> Ratio (double)', () {
      final d1 = Distance.fromMeters(150.0);
      final d2 = Distance.fromMeters(50.0);
      final ratio = d1 / d2;
      expect(ratio, closeTo(3.0, 1e-9));

      expect(() => Distance.fromMeters(100.0) / Distance.fromMeters(0.0), throwsArgumentError);
    });
  });

  group('Time Operations Tests', () {
    test('Time Addition and Subtraction', () {
      final t1 = Time.fromSeconds(60.0);
      final t2 = Time.fromSeconds(30.0);
      expect((t1 + t2).toSeconds, closeTo(90.0, 1e-9));
      expect((t1 - t2).toSeconds, closeTo(30.0, 1e-9));
    });

    test('Time Scalar Multiplication', () {
      final t = Time.fromSeconds(60.0) * 1.5;
      expect(t.toSeconds, closeTo(90.0, 1e-9));
    });

    test('Time / Acceleration -> Speed', () {
      final t = Time.fromSeconds(10.0);
      final a = Acceleration.fromMs2(2.0);
      final s = t / a;
      expect(s.toMs, closeTo(5.0, 1e-9));

      expect(() => Time.fromSeconds(10.0) / Acceleration.fromMs2(0.0), throwsArgumentError);
    });

    test('Time / Time -> Ratio (double)', () {
      final t1 = Time.fromSeconds(60.0);
      final t2 = Time.fromSeconds(15.0);
      final ratio = t1 / t2;
      expect(ratio, closeTo(4.0, 1e-9));

      expect(() => Time.fromSeconds(60.0) / Time.fromSeconds(0.0), throwsArgumentError);
    });
  });

  group('Mass Operations Tests', () {
    test('Mass Addition and Subtraction', () {
      final m1 = Mass.fromKg(10.0);
      final m2 = Mass.fromKg(5.0);
      expect((m1 + m2).toKg, closeTo(15.0, 1e-9));
      expect((m1 - m2).toKg, closeTo(5.0, 1e-9));
    });

    test('Mass Scalar Multiplication', () {
      final m = Mass.fromKg(10.0) * 2.0;
      expect(m.toKg, closeTo(20.0, 1e-9));
    });

    test('Mass Scalar Division', () {
      final m = Mass.fromKg(10.0) / 2.0;
      expect(m.toKg, closeTo(5.0, 1e-9));

      expect(() => Mass.fromKg(10.0) / 0.0, throwsArgumentError);
    });

    test('Mass / Mass -> Ratio (double)', () {
      final m1 = Mass.fromKg(20.0);
      final m2 = Mass.fromKg(4.0);
      final ratio = m1 / m2;
      expect(ratio, closeTo(5.0, 1e-9));

      expect(() => Mass.fromKg(10.0) / Mass.fromKg(0.0), throwsArgumentError);
    });
  });

  group('Unsupported Operator Edge Cases', () {
    test('Unsupported operator types and unsupported divisions', () {
      final speed = Speed.fromMs(10.0);
      final accel = Acceleration.fromMs2(2.0);
      final time = Time.fromSeconds(5.0);
      final dist = Distance.fromMeters(50.0);
      final mass = Mass.fromKg(10.0);

      // Unsupported multiplication types
      expect(() => speed * 'unsupported', throwsArgumentError);
      expect(() => accel * 'unsupported', throwsArgumentError);

      // Unsupported division types & zero checks
      expect(() => speed / 'unsupported', throwsArgumentError);
      expect(() => dist / 'unsupported', throwsArgumentError);
      expect(() => time / 'unsupported', throwsArgumentError);
      expect(() => mass / 'unsupported', throwsArgumentError);

      // Additional division guards
      expect(() => speed / Time.fromSeconds(0.0), throwsArgumentError);
      expect(() => speed / Acceleration.fromMs2(0.0), throwsArgumentError);
      expect(() => dist / Speed.fromMs(0.0), throwsArgumentError);
      expect(() => time / Acceleration.fromMs2(0.0), throwsArgumentError);
    });
  });
}