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
    assert_in_delta(60.0, speed.to_kmh, @epsilon)
    # 60 km/h -> 37.2823 mph
    assert_in_delta(37.2823, speed.to_mph, @epsilon)
  end

  def test_mph_to_kmh
    speed = Speed.from_mph(60.0)
    assert_in_delta(60.0, speed.to_mph, @epsilon)
    # 60 mph -> 96.5606 km/h
    assert_in_delta(96.5606, speed.to_kmh, @epsilon)
  end

  def test_zero_value
    speed = Speed.from_kmh(0.0)
    assert_equal(0.0, speed.to_kmh)
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
    assert_in_delta(32.0, t1.to_fahrenheit, 0.001)
    assert_in_delta(0.0, t1.to_celsius, 0.001)
  end

  def test_celsius_to_farenheiit
    # 100 C -> 212 F
    t2 = Temperature.from_celsius(100.0)
    assert_in_delta(100.0, t2.to_celsius, 0.001)
    assert_in_delta(212.0, t2.to_fahrenheit, 0.001)
  end

  def test_celsius_to_kelvin
    # 0 C -> 273.15 K
    t3 = Temperature.from_celsius(0.0)
    assert_equal(273.15, t3.to_kelvin)
  end

  def test_kelvin_to_celsius
    # 273.15 K -> 0 C
    t4 = Temperature.from_kelvin(273.15)
    assert_equal(273.15, t4.to_kelvin)
    assert_equal(0.0, t4.to_celsius)
  end
end


class TestMass < Minitest::Test
  def test_g_to_kg
    # 1000g -> 1kg
    w = Mass.from_gram(1000.0)
    assert_equal(1000.0, w.to_gram)
    assert_equal(1.0, w.to_kg)
  end

  def test_lb_to_kg
    # 1lb -> 0.45359kg
    w = Mass.from_lb(1.0)
    assert_in_delta(1.0, w.to_lb, 0.000001)
    assert_in_delta(0.453592, w.to_kg, 0.000001)
  end

  def test_kg_to_lb
    # 1kg -> 2.20462lb
    w = Mass.from_kg(1.0)
    assert_in_delta(1.0, w.to_kg, 0.00001)
    assert_in_delta(2.20462, w.to_lb, 0.00001)
  end

  def test_lb_to_oz
    # 1lb -> 16oz
    w = Mass.from_lb(1.0)
    assert_in_delta(1.0, w.to_lb, 0.000001)
    assert_in_delta(16.0, w.to_oz, 0.000001)
  end

  def test_oz_to_lb
    # 1lb -> 16oz
    w = Mass.from_oz(16.0)
    assert_in_delta(16.0, w.to_oz, 0.000001)
    assert_in_delta(1.0, w.to_lb, 0.000001)
  end
end


class TestDistance < Minitest::Test
  def test_meters_to_km
    d = Distance.from_meters(1000.0)
    assert_equal(1000.0, d.to_meters)
    assert_equal(1.0, d.to_km)
  end

  def test_km_to_meters
    # 1.0 km -> 1000.0 m
    d = Distance.from_km(1.0)
    assert_equal(1.0, d.to_km)
    assert_equal(1000.0, d.to_meters)
  end

  def test_mile_to_km
    # 1.0 mile -> 1.609344 km
    d = Distance.from_mile(1.0)
    assert_in_delta(1.0, d.to_mile, 0.000001)
    assert_in_delta(1.609344, d.to_km, 0.000001)
  end

  def test_ft_to_inch
    # 1.0 ft -> 12.0 inch
    d = Distance.from_feet(1.0)
    assert_in_delta(1.0, d.to_feet, 0.000001)
    assert_in_delta(12.0, d.to_inch, 0.000001)
  end

  def test_inch_to_ft
    # 1.0 ft -> 12.0 inch
    d = Distance.from_inch(12.0)
    assert_in_delta(12.0, d.to_inch, 0.000001)
    assert_in_delta(1.0, d.to_feet, 0.000001)
  end
end


class TestPressure < Minitest::Test
  def test_bar_to_kpa
    p = Pressure.from_bar(2.5)
    assert_in_delta(2.5, p.to_bar, 0.001)
    assert_in_delta(250.0, p.to_kpa, 0.001)
  end

  def test_kpa_to_psi
    p = Pressure.from_kpa(250.0)
    assert_in_delta(250.0, p.to_kpa, 0.001)
    assert_in_delta(36.2594, p.to_psi, 0.001)
  end

  def test_psi_to_kpa
    p = Pressure.from_psi(36.2594)
    assert_in_delta(36.2594, p.to_psi, 0.001)
    assert_in_delta(250.0, p.to_kpa, 0.001)
  end
end


class TestTorque < Minitest::Test
  def test_conversion
    t = Torque.from_lbft(100.0)
    assert_in_delta(100.0, t.to_lbft, 0.001)
    assert_in_delta(135.5818, t.to_nm, 0.001)

    t2 = Torque.from_nm(135.5818)
    assert_in_delta(100.0, t.to_lbft, 0.001)
    assert_in_delta(135.5818, t.to_nm, 0.001)

    t3 = Torque.from_kgfm(1.0)
    assert_in_delta(1.0, t3.to_kgfm, 0.001)
    assert_in_delta(9.80665, t3.to_nm, 0.001)
    assert_in_delta(7.233014, t3.to_lbft, 0.001)
  end
end


class TestAngle < Minitest::Test
  def test_conversion
    a = Angle.from_degrees(180.0)
    assert_in_delta(180.0, a.to_degrees, 0.000001)
    assert_in_delta(Math::PI, a.to_radians, 0.000001)

    a2 = Angle.from_radians(Math::PI / 2)
    assert_in_delta(Math::PI/2, a2.to_radians, 0.000001)
    assert_in_delta 90.0, a2.to_degrees, 0.000001
  end
end


class TestEfficiency < Minitest::Test
  def test_conversion
    e = Efficiency.from_l100km(10.0)
    assert_equal(10.0, e.to_l100km)
    assert_equal(10.0, e.to_kml)

    e2 = Efficiency.from_mpg(23.5215)
    assert_in_delta(23.5215, e2.to_mpg, 0.001)
    assert_in_delta(10.0, e2.to_kml, 0.001)

    e3 = Efficiency.from_kml(10.0)
    assert_in_delta(10.0, e3.to_kml, 0.001)
    assert_in_delta(23.5215, e3.to_mpg, 0.001)
    
    assert_raises(ArgumentError) { Efficiency.from_kml(0) }
  end
end


class TestEvEfficiency < Minitest::Test
  def test_matrix_from_km_per_kwh
    e = EvEfficiency.from_km_per_kwh(6.0)
    assert_equal(6.0, e.to_km_per_kwh)
    assert_in_delta(166.666, e.to_wh_per_km, 0.001)
    assert_in_delta(16.666, e.to_kwh_per_100km, 0.001)
    assert_in_delta(3.728, e.to_miles_per_kwh, 0.001)
  end

  def test_matrix_from_wh_per_km
    e = EvEfficiency.from_wh_per_km(200.0)
    assert_in_delta(5.0, e.to_km_per_kwh, 0.001)
    assert_in_delta(200.0, e.to_wh_per_km, 0.001)
    assert_in_delta(20.0, e.to_kwh_per_100km, 0.001)
    assert_in_delta(3.106, e.to_miles_per_kwh, 0.01)
  end

  def test_matrix_from_kwh_per_100km
    e = EvEfficiency.from_kwh_per_100km(20.0)
    assert_in_delta(5.0, e.to_km_per_kwh, 0.001)
    assert_in_delta(200.0, e.to_wh_per_km, 0.001)
    assert_in_delta(20.0, e.to_kwh_per_100km, 0.001)
    assert_in_delta(3.106, e.to_miles_per_kwh, 0.01)
  end

  def test_matrix_from_miles_per_kwh
    e = EvEfficiency.from_miles_per_kwh(1.0)
    assert_in_delta(1.609344, e.to_km_per_kwh, 1e-6)
    assert_in_delta(621.371, e.to_wh_per_km, 0.001)
    assert_in_delta(62.137, e.to_kwh_per_100km, 0.001)
    assert_equal(1.0, e.to_miles_per_kwh)
  end

  def test_invalid_guards
    assert_raises(ArgumentError) { EvEfficiency.from_km_per_kwh(0.0) }
    assert_raises(ArgumentError) { EvEfficiency.from_wh_per_km(0.0) }
    assert_raises(ArgumentError) { EvEfficiency.from_kwh_per_100km(0.0) }
    assert_raises(ArgumentError) { EvEfficiency.from_miles_per_kwh(0.0) }
  end
end

class TestVolume < Minitest::Test
  def test_volume_conversion
    v = Volume.from_liters(1.0)
    assert_equal(1.0, v.to_liters)
    assert_equal(1000.0, v.to_ml)
    assert_in_delta(0.264172, v.to_us_gallons, 0.000001)
    assert_in_delta(0.219969, v.to_imp_gallons, 0.000001)

    v_ml = Volume.from_ml(500.0)
    assert_equal(500, v_ml.to_ml)
    assert_equal(0.5, v_ml.to_liters)
    assert_in_delta(0.132086, v_ml.to_us_gallons, 0.000001)
    assert_in_delta(0.1099845, v_ml.to_imp_gallons, 0.000001)

    v_us = Volume.from_us_gallons(10.0)
    assert_in_delta(37854.1, v_us.to_ml, 0.1)
    assert_in_delta(37.8541, v_us.to_liters, 0.0001)
    assert_in_delta(10.0, v_us.to_us_gallons, 0.000001)
    assert_in_delta(8.32674, v_us.to_imp_gallons, 0.00001)

    v_imp = Volume.from_imp_gallons(10.0)
    assert_in_delta(45460.9, v_imp.to_ml, 0.000001)
    assert_in_delta(45.4609, v_imp.to_liters, 0.0001)
    assert_in_delta(12.0095, v_imp.to_us_gallons, 0.000001)
    assert_in_delta(10.0, v_imp.to_imp_gallons, 0.000001)
  end
end