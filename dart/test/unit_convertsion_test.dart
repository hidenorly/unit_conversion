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
  });

  test('Angle Conversion test', () {
    final a = Angle.fromDegrees(180.0);
    expect(a.toDegrees, closeTo(180.0, epsilon));
    expect(a.toRadians, closeTo(math.pi, epsilon));

    final a2 = Angle.fromRadians(math.pi / 2);
    expect(a2.toRadians, closeTo(math.pi / 2, epsilon));
    expect(a2.toDegrees, closeTo(90.0, epsilon));
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
  });
}
