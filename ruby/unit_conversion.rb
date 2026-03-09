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

