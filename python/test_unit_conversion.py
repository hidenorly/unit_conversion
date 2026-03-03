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
from unit_conversion import Speed

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

if __name__ == '__main__':
    unittest.main()
