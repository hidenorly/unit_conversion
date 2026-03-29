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

class Speed
  KMH_TO_MS = 3.6
  MPH_TO_MS = 0.44704

  private_class_method :new

  def initialize(ms)
    @ms = ms
  end

  def self.from_kmh(value)
    return new(value / KMH_TO_MS)
  end

  def self.from_mph(value)
    return new(value * MPH_TO_MS)
  end

  def to_kmh
    return @ms * KMH_TO_MS
  end

  def to_mph
    return @ms / MPH_TO_MS
  end

  def to_ms
    return @ms
  end
end


class Temperature
  F_OFFSET = 32.0
  F_FACTOR = 1.8
  K_OFFSET = 273.15

  private_class_method :new

  def initialize(celsius)
    @celsius = celsius
  end

  def self.from_celsius(v)
    return new(v)
  end

  def self.from_fahrenheit(v)
    return new((v - F_OFFSET) / F_FACTOR)
  end

  def self.from_kelvin(v)
    return new(v - K_OFFSET)
  end

  def to_celsius()
    return @celsius
  end

  def to_fahrenheit()
    return @celsius * F_FACTOR + F_OFFSET
  end

  def to_kelvin()
    return @celsius + K_OFFSET
  end
end


class Mass
  G_TO_KG = 0.001
  LB_TO_KG = 0.45359237
  OZ_TO_KG = 0.0283495231

  private_class_method :new
  def initialize(kg); @kg = kg; end

  def self.from_kg(v)
    return new(v)
  end

  def self.from_gram(v)
    return new(v * G_TO_KG)
  end

  def self.from_lb(v)
    return new(v * LB_TO_KG)
  end

  def self.from_oz(v)
    return new(v * OZ_TO_KG)
  end

  def to_kg
    return @kg
  end

  def to_gram
    return @kg / G_TO_KG
  end

  def to_lb
    return @kg / LB_TO_KG
  end

  def to_oz
    return @kg / OZ_TO_KG
  end
end


class Distance
  KM_TO_M   = 1000.0
  MILE_TO_M = 1609.344
  FT_TO_M   = 0.3048
  IN_TO_M   = 0.0254

  private_class_method :new

  def initialize(meters)
    @meters = meters
  end

  def self.from_meters(v)
    return new(v)
  end

  def self.from_km(v)
    return new(v * KM_TO_M)
  end

  def self.from_mile(v)
    return new(v * MILE_TO_M)
  end

  def self.from_feet(v)
    return new(v * FT_TO_M)
  end

  def self.from_inch(v)
    return new(v * IN_TO_M)
  end

  def to_meters
    return @meters
  end

  def to_km
    return @meters / KM_TO_M
  end

  def to_mile
    return @meters / MILE_TO_M
  end

  def to_feet
    return @meters / FT_TO_M
  end

  def to_inch
    return @meters / IN_TO_M
  end
end


class Pressure
  BAR_TO_KPA = 100.0
  PSI_TO_KPA = 6.89476

  private_class_method :new

  def initialize(kpa)
    @kpa = kpa
  end

  def self.from_kpa(v)
    return new(v)
  end

  def self.from_bar(v)
    return new(v * BAR_TO_KPA)
  end

  def self.from_psi(v)
    return new(v * PSI_TO_KPA)
  end

  def to_kpa
    return @kpa
  end

  def to_bar
    return @kpa / BAR_TO_KPA
  end

  def to_psi
    return @kpa / PSI_TO_KPA
  end
end


class Torque
  KGFM_TO_NM = 9.80665
  LBFT_TO_NM = 1.355817948

  private_class_method :new

  def initialize(nm)
    @nm = nm
  end

  def self.from_nm(v)
    return new(v)
  end

  def self.from_kgfm(v)
    return new(v * KGFM_TO_NM)
  end

  def self.from_lbft(v)
    return new(v * LBFT_TO_NM)
  end

  def to_nm
    return @nm
  end

  def to_kgfm
    return @nm / KGFM_TO_NM
  end

  def to_lbft
    return @nm / LBFT_TO_NM
  end
end


