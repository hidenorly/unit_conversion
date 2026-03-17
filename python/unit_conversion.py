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

class Speed:
    KMH_TO_MS = 3.6
    MPH_TO_MS = 0.44704

    def __init__(self, ms: float):
        self._ms = ms

    @classmethod
    def from_kmh(cls, value: float):
        return cls(value / cls.KMH_TO_MS)

    @classmethod
    def from_mph(cls, value: float):
        return cls(value * cls.MPH_TO_MS)

    @property
    def to_kmh(self) -> float:
        return self._ms * self.KMH_TO_MS

    @property
    def to_mph(self) -> float:
        return self._ms / self.MPH_TO_MS


class Temperature:
    _F_OFFSET = 32.0
    _F_FACTOR = 1.8
    _K_OFFSET = 273.15

    def __init__(self, celsius: float):
        self._celsius = celsius

    @classmethod
    def from_celsius(cls, v: float): return cls(v)
    
    @classmethod
    def from_fahrenheit(cls, v: float): 
        return cls((v - cls._F_OFFSET) / cls._F_FACTOR)

    @classmethod
    def from_kelvin(cls, v: float): 
        return cls(v - cls._K_OFFSET)

    @property
    def to_celsius(self): return self._celsius

    @property
    def to_fahrenheit(self): return self._celsius * self._F_FACTOR + self._F_OFFSET

    @property
    def to_kelvin(self): return self._celsius + self._K_OFFSET


class Mass:
    _G_TO_KG = 0.001
    _LB_TO_KG = 0.45359237
    _OZ_TO_KG = 0.0283495231

    def __init__(self, kg: float):
        self._kg = kg

    @classmethod
    def from_kg(cls, v: float):
        return cls(v)

    @classmethod
    def from_gram(cls, v: float):
        return cls(v * cls._G_TO_KG)

    @classmethod
    def from_lb(cls, v: float):
        return cls(v * cls._LB_TO_KG)

    @classmethod
    def from_oz(cls, v: float):
        return cls(v * cls._OZ_TO_KG)

    @property
    def to_kg(self):
        return self._kg

    @property
    def to_gram(self):
        return self._kg / self._G_TO_KG

    @property
    def to_lb(self):
        return self._kg / self._LB_TO_KG

    @property
    def to_oz(self):
        return self._kg / self._OZ_TO_KG


class Distance:
    _kmToM = 1000.0;
    _mileToM = 1609.344;
    _ftToM = 0.3048;
    _inToM = 0.0254;

    def __init__(self, meter: float):
        self._meters = meter;

    @classmethod
    def from_meters(v: float):
        return cls(v)

    @classmethod
    def from_km(cls, v: float):
        return cls(v * cls._kmToM)

    @classmethod
    def from_mile(cls, v: float):
        return cls(v * cls._mileToM)

    @classmethod
    def from_feet(cls, v: float):
        return cls(v * cls._ftToM)

    @classmethod
    def from_inch(cls, v: float):
        return cls(v * cls._inToM)

    @property
    def to_meters(self):
        return self._meters;

    @property
    def to_km(self):
        return self._meters/ self._kmToM;

    @property
    def to_mile(self):
        return self._meters/ self._mileToM;

    @property
    def to_feet(self):
        return self._meters/ self._ftToM;

    @property
    def to_inch(self):
        return self._meters/ self._inToM;

