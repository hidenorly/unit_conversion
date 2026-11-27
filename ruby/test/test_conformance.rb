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
#
#
# Conformance test: run the shared golden vectors (test_vectors.json at
# the repository root) against the Ruby implementation.
#
# Every language implementation runs the same vectors; a failure here
# means this implementation disagrees with the shared specification.
# Regenerate vectors with tools/generate_test_vectors.py.

require 'minitest/autorun'
require 'json'
require_relative '../lib/unit_conversion'

def find_vectors
  env = ENV['UNIT_CONVERSION_TEST_VECTORS']
  return env if env
  [File.dirname(File.expand_path(__FILE__)), Dir.pwd].each do |base|
    d = base
    5.times do
      cand = File.join(d, 'test_vectors.json')
      return cand if File.exist?(cand)
      d = File.dirname(d)
    end
  end
  raise 'test_vectors.json not found'
end

# quantity -> {unit: [factory, getter]}
DISPATCH = {
  'Speed' => {
    'ms' => [->(v) { Speed.from_ms(v) }, ->(o) { o.to_ms }],
    'kmh' => [->(v) { Speed.from_kmh(v) }, ->(o) { o.to_kmh }],
    'mph' => [->(v) { Speed.from_mph(v) }, ->(o) { o.to_mph }],
  },
  'Temperature' => {
    'celsius' => [->(v) { Temperature.from_celsius(v) }, ->(o) { o.to_celsius }],
    'fahrenheit' => [->(v) { Temperature.from_fahrenheit(v) }, ->(o) { o.to_fahrenheit }],
    'kelvin' => [->(v) { Temperature.from_kelvin(v) }, ->(o) { o.to_kelvin }],
  },
  'Mass' => {
    'kg' => [->(v) { Mass.from_kg(v) }, ->(o) { o.to_kg }],
    'gram' => [->(v) { Mass.from_gram(v) }, ->(o) { o.to_gram }],
    'lb' => [->(v) { Mass.from_lb(v) }, ->(o) { o.to_lb }],
    'oz' => [->(v) { Mass.from_oz(v) }, ->(o) { o.to_oz }],
  },
  'Distance' => {
    'meters' => [->(v) { Distance.from_meters(v) }, ->(o) { o.to_meters }],
    'km' => [->(v) { Distance.from_km(v) }, ->(o) { o.to_km }],
    'mile' => [->(v) { Distance.from_mile(v) }, ->(o) { o.to_mile }],
    'feet' => [->(v) { Distance.from_feet(v) }, ->(o) { o.to_feet }],
    'inch' => [->(v) { Distance.from_inch(v) }, ->(o) { o.to_inch }],
    'mm' => [->(v) { Distance.from_mm(v) }, ->(o) { o.to_mm }],
  },
  'Pressure' => {
    'kpa' => [->(v) { Pressure.from_kpa(v) }, ->(o) { o.to_kpa }],
    'bar' => [->(v) { Pressure.from_bar(v) }, ->(o) { o.to_bar }],
    'psi' => [->(v) { Pressure.from_psi(v) }, ->(o) { o.to_psi }],
  },
  'Power' => {
    'kw' => [->(v) { Power.from_kw(v) }, ->(o) { o.to_kw }],
    'ps' => [->(v) { Power.from_ps(v) }, ->(o) { o.to_ps }],
    'hp' => [->(v) { Power.from_hp(v) }, ->(o) { o.to_hp }],
  },
  'Torque' => {
    'nm' => [->(v) { Torque.from_nm(v) }, ->(o) { o.to_nm }],
    'kgfm' => [->(v) { Torque.from_kgfm(v) }, ->(o) { o.to_kgfm }],
    'lbft' => [->(v) { Torque.from_lbft(v) }, ->(o) { o.to_lbft }],
  },
  'Angle' => {
    'radians' => [->(v) { Angle.from_radians(v) }, ->(o) { o.to_radians }],
    'degrees' => [->(v) { Angle.from_degrees(v) }, ->(o) { o.to_degrees }],
  },
  'Efficiency' => {
    'kml' => [->(v) { Efficiency.from_kml(v) }, ->(o) { o.to_kml }],
    'l100km' => [->(v) { Efficiency.from_l100km(v) }, ->(o) { o.to_l100km }],
    'mpg' => [->(v) { Efficiency.from_mpg(v) }, ->(o) { o.to_mpg }],
  },
  'EvEfficiency' => {
    'km_per_kwh' => [->(v) { EvEfficiency.from_km_per_kwh(v) }, ->(o) { o.to_km_per_kwh }],
    'wh_per_km' => [->(v) { EvEfficiency.from_wh_per_km(v) }, ->(o) { o.to_wh_per_km }],
    'kwh_per_100km' => [->(v) { EvEfficiency.from_kwh_per_100km(v) }, ->(o) { o.to_kwh_per_100km }],
    'miles_per_kwh' => [->(v) { EvEfficiency.from_miles_per_kwh(v) }, ->(o) { o.to_miles_per_kwh }],
  },
  'Volume' => {
    'liters' => [->(v) { Volume.from_liters(v) }, ->(o) { o.to_liters }],
    'ml' => [->(v) { Volume.from_ml(v) }, ->(o) { o.to_ml }],
    'us_gallons' => [->(v) { Volume.from_us_gallons(v) }, ->(o) { o.to_us_gallons }],
    'imp_gallons' => [->(v) { Volume.from_imp_gallons(v) }, ->(o) { o.to_imp_gallons }],
  },
  'Time' => {
    'seconds' => [->(v) { Time.from_seconds(v) }, ->(o) { o.to_seconds }],
    'minutes' => [->(v) { Time.from_minutes(v) }, ->(o) { o.to_minutes }],
    'hours' => [->(v) { Time.from_hours(v) }, ->(o) { o.to_hours }],
  },
  'Acceleration' => {
    'ms2' => [->(v) { Acceleration.from_ms2(v) }, ->(o) { o.to_ms2 }],
  },
}

def parse_value(v)
  case v
  when 'NaN' then Float::NAN
  when 'Infinity' then Float::INFINITY
  when '-Infinity' then -Float::INFINITY
  else v.to_f
  end
end

def construct(spec)
  factory, = DISPATCH[spec['quantity']][spec['unit']]
  factory.call(parse_value(spec['value']))
end

def read_value(obj, quantity, unit)
  _, getter = DISPATCH[quantity][unit]
  getter.call(obj).to_f
end

def apply_op(c)
  lhs = construct(c['lhs'])
  rhs = %w[mul_scalar div_scalar].include?(c['op']) ? parse_value(c['rhs']) : construct(c['rhs'])
  case c['op']
  when 'add' then lhs + rhs
  when 'sub' then lhs - rhs
  when 'mul', 'mul_scalar' then lhs * rhs
  when 'div', 'div_scalar' then lhs / rhs
  else raise "unknown op #{c['op']}"
  end
end

class TestConformance < Minitest::Test
  DOC = JSON.parse(File.read(find_vectors))
  REL_TOL = DOC.fetch('rel_tol', 1e-9)
  ABS_TOL = DOC.fetch('abs_tol', 1e-12)

  def assert_close(actual, expected, label)
    tol = ABS_TOL + REL_TOL * expected.abs
    assert(actual.finite? && (actual - expected).abs <= tol,
           "#{label}: got #{actual.inspect}, expected #{expected.inspect} (tol #{tol})")
  end

  def test_vectors
    DOC['cases'].each_with_index do |c, i|
      label = "case #{i}: #{c}"
      case c['kind']
      when 'convert'
        obj = construct('quantity' => c['quantity'], 'unit' => c['from'], 'value' => c['value'])
        assert_close(read_value(obj, c['quantity'], c['to']), c['expected'], label)
      when 'error'
        assert_raises(StandardError, label) do
          construct('quantity' => c['quantity'], 'unit' => c['from'], 'value' => c['value'])
        end
      when 'op'
        if c.key?('error')
          assert_raises(StandardError, label) { apply_op(c) }
        else
          result = apply_op(c)
          if c['expected_quantity'] == 'scalar'
            assert_close(result.to_f, c['expected'], label)
          else
            assert_close(read_value(result, c['expected_quantity'], c['expected_unit']),
                         c['expected'], label)
          end
        end
      else
        flunk("unknown kind #{c['kind']}")
      end
    end
  end
end
