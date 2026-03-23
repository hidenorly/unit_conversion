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
    assert_in_delta(original, speed.to_kmh, 0.000001)
  end
end


class TestTemperature < Minitest::Test
  def test_farenheiit_to_celsius
    # 32 F -> 0 C
    t1 = Temperature.from_fahrenheit(32.0)
    assert_in_delta(0.0, t1.to_celsius, 0.001)
  end

  def test_celsius_to_farenheiit
    # 100 C -> 212 F
    t2 = Temperature.from_celsius(100.0)
    assert_in_delta(212.0, t2.to_fahrenheit, 0.001)
  end

  def test_celsius_to_kelvin
    # 0 C -> 273.15 K
    t3 = Temperature.from_celsius(0.0)
    assert_equal(273.15, t3.to_kelvin)
  end
end


class TestMass < Minitest::Test
  def test_g_to_kg
    # 1000g -> 1kg
    assert_equal(1.0, Mass.from_gram(1000.0).to_kg)
  end

  def test_lb_to_kg
    # 1lb -> 0.45359kg
    assert_in_delta(0.453592, Mass.from_lb(1.0).to_kg, 0.000001)
  end

  def test_kg_to_lb
    # 1kg -> 2.20462lb
    assert_in_delta(2.20462, Mass.from_kg(1.0).to_lb, 0.00001)
  end

  def test_lb_to_oz
    # 1lb -> 16oz
    assert_in_delta(16.0, Mass.from_lb(1.0).to_oz, 0.000001)
  end
end


class TestDistance < Minitest::Test
  def test_km_to_m
    # 1.0 km -> 1000.0 m
    assert_equal(1000.0, Distance.from_km(1.0).to_meters)
  end

  def test_mile_to_km
    # 1.0 mile -> 1.609344 km
    d_mile = Distance.from_mile(1.0)
    assert_in_delta(1.609344, d_mile.to_km, 0.000001)
  end

  def test_ft_to_inch
    # 1.0 ft -> 12.0 inch
    d_ft = Distance.from_feet(1.0)
    assert_in_delta(12.0, d_ft.to_inch, 0.000001)
  end
end


class TestPressure < Minitest::Test
  def test_bar_to_kpa
    p = Pressure.from_bar(2.5)
    assert_in_delta(250.0, p.to_kpa, 0.001)
  end

  def test_kpa_to_psi
    p = Pressure.from_kpa(250.0)
    assert_in_delta(36.2594, p.to_psi, 0.001)
  end
end