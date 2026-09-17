#!/usr/bin/env ruby
#  Copyright (C) 2026 hidenorly
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'minitest/autorun'
require 'unit_conversion'

class TestSpeed < Minitest::Test
  def setup
    @epsilon = 0.001
  end

  def test_ms_to_kmh
    speed = Speed.from_ms(16.6666)
    assert_in_delta(60.0, speed.to_kmh, @epsilon)
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

  def test_comparable_and_string
    s1 = Speed.from_ms(10.0)
    s2 = Speed.from_ms(20.0)
    s3 = Speed.from_ms(10.0)

    assert(s1 < s2)
    assert(s2 > s1)
    assert(s1 == s3)
    assert_nil(s1 <=> "not a speed")

    assert_equal("10.0 m/s", s1.to_s)
  end

  def test_arithmetic_guards
    s = Speed.from_ms(10.0)
    assert_raises(ArgumentError) { s + "invalid" }
    assert_raises(ArgumentError) { s - "invalid" }
    assert_raises(ArgumentError) { s * "invalid" }
    assert_raises(ArgumentError) { s / "invalid" }
  end

  def test_guards
    assert_raises(ArgumentError) { Speed.from_kmh(Float::NAN) }
    assert_raises(ArgumentError) { Speed.from_mph(Float::NAN) }
    assert_raises(ArgumentError) { Speed.from_ms(Float::NAN) }

    assert_raises(ArgumentError) { Speed.from_kmh(Float::INFINITY) }
    assert_raises(ArgumentError) { Speed.from_mph(Float::INFINITY) }
    assert_raises(ArgumentError) { Speed.from_ms(Float::INFINITY) }

    assert_raises(ArgumentError) { Speed.from_kmh(-Float::INFINITY) }
    assert_raises(ArgumentError) { Speed.from_mph(-Float::INFINITY) }
    assert_raises(ArgumentError) { Speed.from_ms(-Float::INFINITY) }

    s = Speed.from_ms(10.0)
    s_sub = s - Speed.from_ms(4.0)
    assert_in_delta(6.0, s_sub.to_ms)

    assert_raises(ArgumentError) { s / 0.0 }
    assert_raises(ArgumentError) { s / Time.from_seconds(0.0) }
    assert_raises(ArgumentError) { s / Acceleration.from_ms2(0.0) }
    assert_raises(ArgumentError) { s / "invalid" }
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

  def test_absolute_zero
    assert_raises(ArgumentError) { Temperature.from_kelvin(-0.01) }
    t = Temperature.from_kelvin(0)
    assert_in_delta(-273.15, t.to_celsius, 0.001)

    assert_raises(ArgumentError) { Temperature.from_celsius(-273.16) }

    t = Temperature.from_fahrenheit(-459.67) # Absolute Zero
    assert_in_delta(-273.15, t.to_celsius, 0.001)
  end

  def test_comparable_and_string
    t1 = Temperature.from_celsius(10.0)
    t2 = Temperature.from_celsius(20.0)
    assert(t1 < t2)
    assert_nil(t1 <=> "not a temperature")
    assert_equal("10.0 °C", t1.to_s)
  end

  def test_guards
    assert_raises(ArgumentError) { Temperature.from_celsius(Float::NAN) }
    assert_raises(ArgumentError) { Temperature.from_celsius(Float::INFINITY) }
    assert_raises(ArgumentError) { Temperature.from_fahrenheit(Float::NAN) }
    assert_raises(ArgumentError) { Temperature.from_kelvin(Float::NAN) }

    t1 = Temperature.from_celsius(20.0)
    t2 = Temperature.from_celsius(10.0)

    assert_in_delta(30.0, (t1 + 10.0).to_celsius)
    assert_in_delta(10.0, (t1 - t2))
    assert_in_delta(10.0, (t1 - 10.0).to_celsius)
    assert_in_delta(40.0, (t1 * 2.0).to_celsius)
    assert_in_delta(2.0, (t1 / t2))
    assert_in_delta(10.0, (t1 / 2.0).to_celsius)

    assert_raises(ArgumentError) { t1 + t2 }
    assert_raises(ArgumentError) { t1 + "invalid" }
    assert_raises(ArgumentError) { t1 - "invalid" }
    assert_raises(ArgumentError) { t1 * "invalid" }
    assert_raises(ArgumentError) { t1 / "invalid" }
    assert_raises(ArgumentError) { t1 / 0.0 }
    assert_raises(ArgumentError) { t1 / Temperature.from_celsius(0.0) }

    assert_raises(ArgumentError) { Temperature.from_fahrenheit(Float::INFINITY) }
    assert_raises(ArgumentError) { Temperature.from_kelvin(Float::INFINITY) }
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

  def test_operations_and_comparable
    m1 = Mass.from_kg(1.0)
    m2 = Mass.from_kg(2.0)
    assert(m1 < m2)
    assert_nil(m1 <=> "not a mass")

    m3 = m1 + m2
    assert_in_delta(3.0, m3.to_kg)

    m4 = m2 - m1
    assert_in_delta(1.0, m4.to_kg)

    m5 = m1 * 2.0
    assert_in_delta(2.0, m5.to_kg)

    ratio = m2 / m1
    assert_in_delta(2.0, ratio)

    m6 = m2 / 2.0
    assert_in_delta(1.0, m6.to_kg)

    assert_equal("1.0 kg", m1.to_s)

    assert_raises(ArgumentError) { m1 + "invalid" }
    assert_raises(ArgumentError) { m1 - "invalid" }
    assert_raises(ArgumentError) { m1 * "invalid" }
    assert_raises(ArgumentError) { m1 / "invalid" }
    assert_raises(ArgumentError) { m1 / 0.0 }
  end

  def test_guards
    assert_raises(ArgumentError) { Mass.from_kg(Float::NAN) }
    assert_raises(ArgumentError) { Mass.from_kg(Float::INFINITY) }
    assert_raises(ArgumentError) { Mass.from_kg(-1.0) }

    m = Mass.from_kg(1.0)
    assert_raises(ArgumentError) { m / Mass.from_kg(0.0) }
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

  def test_mm
    assert_in_delta(1000.0, Distance.from_mm(1000.0).to_mm, 0.001)
    assert_raises(ArgumentError) { Distance.from_mm(-1.0) }
  end

  def test_comparable_and_string
    d1 = Distance.from_meters(10.0)
    d2 = Distance.from_meters(20.0)
    assert(d1 < d2)
    assert_nil(d1 <=> "not distance")
    assert_equal("10.0 m", d1.to_s)

    assert_raises(ArgumentError) { d1 + "invalid" }
    assert_raises(ArgumentError) { d1 - "invalid" }
    assert_raises(ArgumentError) { d1 * "invalid" }
  end

  def test_guards
    assert_raises(ArgumentError) { Distance.from_meters(Float::NAN) }
    assert_raises(ArgumentError) { Distance.from_meters(Float::INFINITY) }
    assert_raises(ArgumentError) { Distance.from_meters(-1.0) }

    d = Distance.from_meters(10.0)
    assert_raises(ArgumentError) { d / "invalid" }
    assert_raises(ArgumentError) { Distance.from_feet(Float::INFINITY) }
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

  def test_comparable_and_string
    p1 = Pressure.from_kpa(100.0)
    p2 = Pressure.from_kpa(200.0)
    assert(p1 < p2)
    assert_nil(p1 <=> "not pressure")
    assert_equal("100.0 kPa", p1.to_s)
  end

  def test_guards
    assert_raises(ArgumentError) { Pressure.from_kpa(Float::NAN) }
    assert_raises(ArgumentError) { Pressure.from_kpa(Float::INFINITY) }
    assert_raises(ArgumentError) { Pressure.from_kpa(-1.0) }

    p1 = Pressure.from_kpa(100.0)
    p2 = Pressure.from_kpa(50.0)

    assert_in_delta(150.0, (p1 + p2).to_kpa)
    assert_in_delta(50.0, (p1 - p2).to_kpa)
    assert_in_delta(200.0, (p1 * 2.0).to_kpa)
    assert_in_delta(2.0, (p1 / p2))
    assert_in_delta(50.0, (p1 / 2.0).to_kpa)

    assert_raises(ArgumentError) { p1 + "invalid" }
    assert_raises(ArgumentError) { p1 - "invalid" }
    assert_raises(ArgumentError) { p1 * "invalid" }
    assert_raises(ArgumentError) { p1 / "invalid" }
    assert_raises(ArgumentError) { p1 / 0.0 }
    assert_raises(ArgumentError) { p1 / Pressure.from_kpa(0.0) }
  end
end


class TestPower < Minitest::Test
  def test_conversion
    p = Power.from_kw(1)
    assert_in_delta 1.3596, p.to_ps, 0.0001
    assert_in_delta 1.3410, p.to_hp, 0.0001
  end

  def test_comparable_and_string
    p1 = Power.from_kw(10.0)
    p2 = Power.from_kw(20.0)
    assert(p1 < p2)
    assert_nil(p1 <=> "not power")
    assert_equal("10.0 kW", p1.to_s)
  end

  def test_guards
    assert_raises(ArgumentError) { Power.from_kw(Float::NAN) }
    assert_raises(ArgumentError) { Power.from_ps(Float::NAN) }
    assert_raises(ArgumentError) { Power.from_hp(Float::NAN) }

    assert_raises(ArgumentError) { Power.from_kw(Float::INFINITY) }
    assert_raises(ArgumentError) { Power.from_ps(Float::INFINITY) }
    assert_raises(ArgumentError) { Power.from_hp(Float::INFINITY) }

    # neg
    assert_raises(ArgumentError) { Power.from_kw(-1) }
    assert_raises(ArgumentError) { Power.from_kw(-Float::INFINITY) }
    assert_raises(ArgumentError) { Power.from_ps(-Float::INFINITY) }
    assert_raises(ArgumentError) { Power.from_hp(-Float::INFINITY) }

    p1 = Power.from_kw(10.0)
    p2 = Power.from_kw(5.0)

    assert_in_delta(15.0, (p1 + p2).to_kw)
    assert_in_delta(5.0, (p1 - p2).to_kw)
    assert_in_delta(20.0, (p1 * 2.0).to_kw)
    assert_in_delta(2.0, (p1 / p2))
    assert_in_delta(5.0, (p1 / 2.0).to_kw)

    assert_raises(ArgumentError) { p1 + "invalid" }
    assert_raises(ArgumentError) { p1 - "invalid" }
    assert_raises(ArgumentError) { p1 * "invalid" }
    assert_raises(ArgumentError) { p1 / "invalid" }
    assert_raises(ArgumentError) { p1 / 0.0 }
    assert_raises(ArgumentError) { p1 / Power.from_kw(0.0) }
  end
end


class TestTorque < Minitest::Test
  def test_conversion
    t = Torque.from_lbft(100.0)
    assert_in_delta(100.0, t.to_lbft, 0.001)
    assert_in_delta(135.5818, t.to_nm, 0.001)

    t2 = Torque.from_nm(135.5818)
    assert_in_delta(100.0, t2.to_lbft, 0.001)
    assert_in_delta(135.5818, t2.to_nm, 0.001)

    t3 = Torque.from_kgfm(1.0)
    assert_in_delta(1.0, t3.to_kgfm, 0.001)
    assert_in_delta(9.80665, t3.to_nm, 0.001)
    assert_in_delta(7.233014, t3.to_lbft, 0.001)
  end

  def test_comparable_and_string
    t1 = Torque.from_nm(10.0)
    t2 = Torque.from_nm(20.0)
    assert(t1 < t2)
    assert_nil(t1 <=> "not torque")
    assert_equal("10.0 Nm", t1.to_s)
  end

  def test_guards
    assert_raises(ArgumentError) { Torque.from_nm(Float::NAN) }
    assert_raises(ArgumentError) { Torque.from_kgfm(Float::NAN) }
    assert_raises(ArgumentError) { Torque.from_lbft(Float::NAN) }

    assert_raises(ArgumentError) { Torque.from_nm(Float::INFINITY) }
    assert_raises(ArgumentError) { Torque.from_kgfm(Float::INFINITY) }
    assert_raises(ArgumentError) { Torque.from_lbft(Float::INFINITY) }

    # neg
    assert_raises(ArgumentError) { Torque.from_nm(-Float::INFINITY) }
    assert_raises(ArgumentError) { Torque.from_kgfm(-Float::INFINITY) }
    assert_raises(ArgumentError) { Torque.from_lbft(-Float::INFINITY) }
    assert_raises(ArgumentError) { Torque.from_nm(-1.0) }

    t1 = Torque.from_nm(10.0)
    t2 = Torque.from_nm(5.0)

    assert_in_delta(15.0, (t1 + t2).to_nm)
    assert_in_delta(5.0, (t1 - t2).to_nm)
    assert_in_delta(20.0, (t1 * 2.0).to_nm)
    assert_in_delta(2.0, (t1 / t2))
    assert_in_delta(5.0, (t1 / 2.0).to_nm)

    assert_raises(ArgumentError) { t1 + "invalid" }
    assert_raises(ArgumentError) { t1 - "invalid" }
    assert_raises(ArgumentError) { t1 * "invalid" }
    assert_raises(ArgumentError) { t1 / "invalid" }
    assert_raises(ArgumentError) { t1 / 0.0 }
    assert_raises(ArgumentError) { t1 / Torque.from_nm(0.0) }
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

  def test_normalization
    # Test normalize degrees (e.g. 450° -> 90°, -90° -> 270°)
    a_deg1 = Angle.from_degrees(450.0).normalize_degrees
    assert_in_delta(90.0, a_deg1.to_degrees, 0.000001)

    a_deg2 = Angle.from_degrees(-90.0).normalize_degrees
    assert_in_delta(270.0, a_deg2.to_degrees, 0.000001)

    # Test normalize radians (e.g. 3 * pi -> pi, -pi/2 -> 3*pi/2)
    a_rad1 = Angle.from_radians(3.0 * Math::PI).normalize_radians
    assert_in_delta(Math::PI, a_rad1.to_radians, 0.000001)

    a_rad2 = Angle.from_radians(-Math::PI / 2.0).normalize_radians
    assert_in_delta(1.5 * Math::PI, a_rad2.to_radians, 0.000001)

    # Test normalize signed
    a_signed = Angle.from_degrees(270.0).normalize_signed
    assert_in_delta(-90.0, a_signed.to_degrees, 0.000001)
  end

  def test_comparable_and_string
    a1 = Angle.from_radians(1.0)
    a2 = Angle.from_radians(2.0)
    assert(a1 < a2)
    assert_nil(a1 <=> "not angle")
    assert_equal("1.0 rad", a1.to_s)
  end

  def test_guards
    assert_raises(ArgumentError) { Angle.from_radians(Float::NAN) }
    assert_raises(ArgumentError) { Angle.from_radians(Float::INFINITY) }
    assert_raises(ArgumentError) { Angle.from_degrees(Float::NAN) }

    a1 = Angle.from_radians(2.0)
    a2 = Angle.from_radians(1.0)

    assert_in_delta(3.0, (a1 + a2).to_radians)
    assert_in_delta(1.0, (a1 - a2).to_radians)
    assert_in_delta(4.0, (a1 * 2.0).to_radians)
    assert_in_delta(2.0, (a1 / a2))
    assert_in_delta(1.0, (a1 / 2.0).to_radians)

    # Additional negative test for signed normalization when negative
    a_neg_signed = Angle.from_degrees(-270.0).normalize_signed
    assert_in_delta(90.0, a_neg_signed.to_degrees, 0.000001)

    assert_raises(ArgumentError) { a1 + "invalid" }
    assert_raises(ArgumentError) { a1 - "invalid" }
    assert_raises(ArgumentError) { a1 * "invalid" }
    assert_raises(ArgumentError) { a1 / "invalid" }
    assert_raises(ArgumentError) { a1 / 0.0 }
    assert_raises(ArgumentError) { a1 / Angle.from_radians(0.0) }
    assert_raises(ArgumentError) { Angle.from_degrees(Float::INFINITY) }
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
    assert_raises(ArgumentError) { Efficiency.from_l100km(0) }
    assert_raises(ArgumentError) { Efficiency.from_mpg(0) }

    assert_raises(ArgumentError) { Efficiency.from_kml(Float::NAN) }
    assert_raises(ArgumentError) { Efficiency.from_l100km(Float::NAN) }
    assert_raises(ArgumentError) { Efficiency.from_mpg(Float::NAN) }
  end

  def test_comparable_and_string
    e1 = Efficiency.from_kml(10.0)
    e2 = Efficiency.from_kml(15.0)
    assert(e1 < e2)
    assert_nil(e1 <=> "not efficiency")
    assert_equal("10.0 km/L", e1.to_s)

    assert_in_delta(25.0, (e1 + e2).to_kml)
    assert_in_delta(5.0, (e2 - e1).to_kml)

    e1 = Efficiency.from_kml(10.0)
    e2 = Efficiency.from_kml(5.0)

    assert_in_delta(15.0, (e1 + e2).to_kml)
    assert_in_delta(5.0, (e1 - e2).to_kml)
    assert_in_delta(20.0, (e1 * 2.0).to_kml)
    assert_in_delta(2.0, (e1 / e2))
    assert_in_delta(5.0, (e1 / 2.0).to_kml)

    assert_raises(ArgumentError) { Efficiency.from_kml(Float::INFINITY) }
    assert_raises(ArgumentError) { Efficiency.from_kml(-1.0) }
    assert_raises(ArgumentError) { e1 + "invalid" }
    assert_raises(ArgumentError) { e1 - "invalid" }
    assert_raises(ArgumentError) { e1 * "invalid" }
    assert_raises(ArgumentError) { e1 / "invalid" }
    assert_raises(ArgumentError) { e1 / 0.0 }
    assert_raises(ArgumentError) { e1 / Efficiency.from_kml(0.0) }
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

  def test_comparable_and_string
    e1 = EvEfficiency.from_km_per_kwh(5.0)
    e2 = EvEfficiency.from_km_per_kwh(6.0)
    assert(e1 < e2)
    assert_nil(e1 <=> "not evefficiency")
    assert_equal("5.0 km/kWh", e1.to_s)
  end

  def test_invalid_guards
    assert_raises(ArgumentError) { EvEfficiency.from_km_per_kwh(0.0) }
    assert_raises(ArgumentError) { EvEfficiency.from_wh_per_km(0.0) }
    assert_raises(ArgumentError) { EvEfficiency.from_kwh_per_100km(0.0) }
    assert_raises(ArgumentError) { EvEfficiency.from_miles_per_kwh(0.0) }
    assert_raises(ArgumentError) { EvEfficiency.from_km_per_kwh(-1.0) }
    assert_raises(ArgumentError) { EvEfficiency.from_km_per_kwh(Float::NAN) }

    e1 = EvEfficiency.from_km_per_kwh(6.0)
    e2 = EvEfficiency.from_km_per_kwh(2.0)

    assert_in_delta(8.0, (e1 + e2).to_km_per_kwh)
    assert_in_delta(4.0, (e1 - e2).to_km_per_kwh)
    assert_in_delta(12.0, (e1 * 2.0).to_km_per_kwh)
    assert_in_delta(3.0, (e1 / e2))
    assert_in_delta(3.0, (e1 / 2.0).to_km_per_kwh)

    assert_raises(ArgumentError) { EvEfficiency.from_km_per_kwh(Float::INFINITY) }
    assert_raises(ArgumentError) { e1 + "invalid" }
    assert_raises(ArgumentError) { e1 - "invalid" }
    assert_raises(ArgumentError) { e1 * "invalid" }
    assert_raises(ArgumentError) { e1 / "invalid" }
    assert_raises(ArgumentError) { e1 / 0.0 }
    assert_raises(ArgumentError) { e1 / EvEfficiency.from_km_per_kwh(0.0) }
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

  def test_comparable_and_string
    v1 = Volume.from_liters(1.0)
    v2 = Volume.from_liters(2.0)
    assert(v1 < v2)
    assert_nil(v1 <=> "not volume")
    assert_equal("1.0 L", v1.to_s)
  end

  def test_guards
    assert_raises(ArgumentError) { Volume.from_liters(Float::NAN) }
    assert_raises(ArgumentError) { Volume.from_liters(Float::INFINITY) }
    assert_raises(ArgumentError) { Volume.from_liters(-1.0) }

    v1 = Volume.from_liters(10.0)
    v2 = Volume.from_liters(4.0)

    assert_in_delta(14.0, (v1 + v2).to_liters)
    assert_in_delta(6.0, (v1 - v2).to_liters)
    assert_in_delta(20.0, (v1 * 2.0).to_liters)
    assert_in_delta(2.5, (v1 / v2))
    assert_in_delta(5.0, (v1 / 2.0).to_liters)

    assert_raises(ArgumentError) { v1 + "invalid" }
    assert_raises(ArgumentError) { v1 - "invalid" }
    assert_raises(ArgumentError) { v1 * "invalid" }
    assert_raises(ArgumentError) { v1 / "invalid" }
    assert_raises(ArgumentError) { v1 / 0.0 }
    assert_raises(ArgumentError) { v1 / Volume.from_liters(0.0) }
  end
end


class TestTime < Minitest::Test
  def test_time_conversion_matrix
    t_s = Time.from_seconds(60.0)
    assert_in_delta(60.0, t_s.to_seconds)
    assert_in_delta(1.0, t_s.to_minutes)
    assert_in_delta(1.0/60.0, t_s.to_hours)

    t_m = Time.from_minutes(1.0)
    assert_in_delta(60.0, t_m.to_seconds)
    assert_in_delta(1.0, t_m.to_minutes)
    assert_in_delta(1.0/60.0, t_m.to_hours)

    t_h = Time.from_hours(1.0/60.0)
    assert_in_delta(60.0, t_h.to_seconds)
    assert_in_delta(1.0, t_h.to_minutes)
    assert_in_delta(1.0/60.0, t_h.to_hours)
  end

  def test_comparable_and_operations
    t1 = Time.from_seconds(10.0)
    t2 = Time.from_seconds(20.0)
    assert(t1 < t2)
    assert_nil(t1 <=> "not time")

    t3 = t1 + t2
    assert_in_delta(30.0, t3.to_seconds)

    t4 = t2 - t1
    assert_in_delta(10.0, t4.to_seconds)

    t5 = t1 * 2.0
    assert_in_delta(20.0, t5.to_seconds)

    dist = t1 * Speed.from_ms(10.0)
    assert_in_delta(100.0, dist.to_meters)

    spd = t1 * Acceleration.new(2.0)
    assert_in_delta(20.0, spd.to_ms)

    ratio = t2 / t1
    assert_in_delta(2.0, ratio)

    spd_div = t1 / Acceleration.new(2.0)
    assert_in_delta(5.0, spd_div.to_ms)

    t6 = t2 / 2.0
    assert_in_delta(10.0, t6.to_seconds)

    assert_equal("10.0 s", t1.to_s)

    assert_raises(ArgumentError) { t1 + "invalid" }
    assert_raises(ArgumentError) { t1 - "invalid" }
    assert_raises(ArgumentError) { t1 * "invalid" }
    assert_raises(ArgumentError) { t1 / "invalid" }
    assert_raises(ArgumentError) { t1 / 0.0 }
    assert_raises(ArgumentError) { t1 / Acceleration.new(0.0) }
    assert_raises(ArgumentError) { t1 / Time.from_seconds(0.0) }
  end

  def test_guards
    assert_raises(ArgumentError) { Time.from_seconds(Float::NAN) }
    assert_raises(ArgumentError) { Time.from_seconds(Float::INFINITY) }
    assert_raises(ArgumentError) { Time.from_seconds(-1.0) }

    t = Time.from_seconds(10.0)
    assert_raises(ArgumentError) { t * "invalid" }
  end
end


class TestAcceleration < Minitest::Test
  def test_full_coverage
    a = Acceleration.new(9.8)
    s = a * Time.from_seconds(2.0)
    assert_in_delta(19.6, s.to_ms)
    
    a2 = Acceleration.from_speed_and_time(Speed.from_ms(20.0), Time.from_seconds(4.0))
    assert_in_delta(5.0, a2.to_ms2)

    assert(Acceleration.new(5.0) < Acceleration.new(10.0))
    assert_nil(Acceleration.new(5.0) <=> "not acceleration")
    assert_equal("9.8 m/s^2", a.to_s)

    assert_raises(ArgumentError) { Acceleration.new(Float::NAN) }
    assert_raises(ArgumentError) { Acceleration.new(Float::INFINITY) }
    assert_raises(ArgumentError) { a * "invalid" }
    assert_raises(ArgumentError) { a / "invalid" }
    assert_raises(ArgumentError) { a / 0.0 }
    assert_raises(ArgumentError) { a * Time.from_seconds(-1.0) }
    assert_raises(ArgumentError) { Acceleration.from_speed_and_time(Speed.from_ms(10.0), Time.from_seconds(0.0)) }

    assert_raises(ArgumentError) { Acceleration.new(Float::INFINITY) }
  end
end


class TestOperation < Minitest::Test
  def test_speed_mul_time
    d = Speed.from_ms(10.0) * Time.from_seconds(5.0)
    assert_in_delta(50.0, d.to_meters)

    d2 = Time.from_seconds(5.0) * Speed.from_ms(10.0)
    assert_in_delta(50.0, d2.to_meters)

    assert_raises(ArgumentError) {
      Speed.from_ms(10.0) * Time.from_seconds(-1.0)
    }
  end

  def test_speed_div
    accel = Speed.from_ms(20.0) / Time.from_seconds(4.0)
    assert_in_delta(5.0, accel.to_ms2)

    tm = Speed.from_ms(20.0) / Acceleration.new(2.0)
    assert_in_delta(10.0, tm.to_seconds)

    sp = Speed.from_ms(20.0) / 2.0
    assert_in_delta(10.0, sp.to_ms)
  end

  def test_time_div
    ratio = Time.from_seconds(60.0) / Time.from_seconds(12.0)
    assert_in_delta(5.0, ratio)

    tm = Time.from_seconds(60.0) / 2.0
    assert_in_delta(30.0, tm.to_seconds)
  end

  def test_accel_from_delta_speed
    v_f = Speed.from_ms(20.0)
    v_i = Speed.from_ms(0.0)
    t = Time.from_seconds(5.0)
    a = (v_f - v_i) / t
    assert_in_delta(4.0, a.to_ms2)

    assert_raises(ArgumentError) do
      (v_f - v_i) / Time.from_seconds(0.0)
    end
  end

  def test_velocity_change
    v = Speed.from_ms(10.0)
    v_delta = Acceleration.new(2.0) * Time.from_seconds(5.0)
    v2 = v + v_delta
    assert_in_delta(20.0, v2.to_ms)
  end

  def test_scalar_mul
    v = Speed.from_ms(10.0) * 0.5
    assert_in_delta(5.0, v.to_ms)

    v_coerced = 0.5 * Speed.from_ms(10.0)
    assert_in_delta(5.0, v_coerced.to_ms)

    zero = Speed.from_ms(10.0) * 0.0
    assert_in_delta(0.0, zero.to_ms)
  end

  def test_acceleration_scalar_mul
    a = Acceleration.new(9.8) * 0.5
    assert_in_delta(4.9, a.to_ms2)

    a_coerced = 0.5 * Acceleration.new(9.8)
    assert_in_delta(4.9, a_coerced.to_ms2)

    zero = Acceleration.new(9.8) * 0.0
    assert_in_delta(0.0, zero.to_ms2)
  end

  def test_distance_div
    d1 = Distance.from_meters(100.0)
    d2 = Distance.from_meters(20.0)

    # Distance / Distance = scalar
    ratio = d1 / d2
    assert_in_delta(5.0, ratio)

    # Distance / Speed = Time
    t = Distance.from_meters(100.0) / Speed.from_ms(10.0)
    assert_in_delta(10.0, t.to_seconds)

    # Distance / Time = Speed
    v = Distance.from_meters(100.0) / Time.from_seconds(10.0)
    assert_in_delta(10.0, v.to_ms)
  end

  def test_scalar_mul_operations
    # Speed * scalar
    v = Speed.from_ms(10.0) * 2.0
    assert_in_delta(20.0, v.to_ms)

    # Acceleration * scalar
    a = Acceleration.new(10.0) * 0.5
    assert_in_delta(5.0, a.to_ms2)

    # Time * scalar
    t = Time.from_seconds(10.0) * 3.0
    assert_in_delta(30.0, t.to_seconds)

    # Distance * scalar
    d = Distance.from_meters(10.0) * 4.0
    assert_in_delta(40.0, d.to_meters)

    # scalar * Distance
    d_coerced = 4.0 * Distance.from_meters(10.0)
    assert_in_delta(40.0, d_coerced.to_meters)
  end

  def test_div_guards
    assert_raises(ArgumentError) { Distance.from_meters(10.0) / Distance.from_meters(0.0) }
    assert_raises(ArgumentError) { Distance.from_meters(10.0) / Speed.from_ms(0.0) }
    assert_raises(ArgumentError) { Distance.from_meters(10.0) / Time.from_seconds(0.0) }
    assert_raises(ArgumentError) { Speed.from_ms(10.0) / Time.from_seconds(0.0) }
    assert_raises(ArgumentError) { Speed.from_ms(10.0) / Acceleration.new(0.0) }
    assert_raises(ArgumentError) { Time.from_seconds(10.0) / Time.from_seconds(0.0) }
  end
end
