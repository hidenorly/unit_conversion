#!/usr/bin/env ruby
#  Copyright (C) 2026 hidenorly
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'minitest/autorun'
require_relative 'unit_conversion'

class TestSpeed < Minitest::Test
  def setup
    @epsilon = 0.001
  end

  def test_kmh_to_mph
    speed = Speed.from_kmh(60.0)
    # 60 km/h -> 37.2823 mph
    assert_in_delta(37.2823, speed.to_mph, @epsilon)
  end

  def test_mph_to_kmh
    speed = Speed.from_mph(60.0)
    # 60 mph -> 96.5606 km/h
    assert_in_delta(96.5606, speed.to_kmh, @epsilon)
  end

  def test_zero_value
    speed = Speed.from_kmh(0.0)
    assert_equal(0.0, speed.to_mph)
    assert_equal(0.0, speed.to_ms)
  end

  def test_identity
    original = 120.5
    speed = Speed.from_kmh(original)
    assert_in_delta original, speed.to_kmh, 0.000001
  end
end


class TestTemperature < Minitest::Test
  def test_farenheiit_to_celsius
    # 32 F -> 0 C
    t1 = Temperature.from_fahrenheit(32.0)
    assert_in_delta 0.0, t1.to_celsius, 0.001
  end

  def test_celsius_to_farenheiit
    # 100 C -> 212 F
    t2 = Temperature.from_celsius(100.0)
    assert_in_delta 212.0, t2.to_fahrenheit, 0.001
  end

  def test_celsius_to_kelvin
    # 0 C -> 273.15 K
    t3 = Temperature.from_celsius(0.0)
    assert_equal 273.15, t3.to_kelvin
  end
end