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
}