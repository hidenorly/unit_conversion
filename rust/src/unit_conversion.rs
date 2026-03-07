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

pub struct Speed {
    ms: f64,
}

impl Speed {
    const KMH_TO_MS: f64 = 3.6;
    const MPH_TO_MS: f64 = 0.44704;

    pub fn from_kmh(value: f64) -> Self {
        Self { ms: value / Self::KMH_TO_MS }
    }

    pub fn from_mph(value: f64) -> Self {
        Self { ms: value * Self::MPH_TO_MS }
    }

    pub fn to_kmh(&self) -> f64 {
        self.ms * Self::KMH_TO_MS
    }

    pub fn to_mph(&self) -> f64 {
        self.ms / Self::MPH_TO_MS
    }

    pub fn to_ms(&self) -> f64 {
        self.ms
    }
}

pub struct Temperature {
    celsius: f64,
}

impl Temperature {
    const F_OFFSET: f64 = 32.0;
    const F_FACTOR: f64 = 1.8;
    const K_OFFSET: f64 = 273.15;

    pub fn from_celsius(v: f64) -> Self { Self { celsius: v } }
    pub fn from_fahrenheit(v: f64) -> Self { Self { celsius: (v - Self::F_OFFSET) / Self::F_FACTOR } }
    pub fn from_kelvin(v: f64) -> Self { Self { celsius: v - Self::K_OFFSET } }

    pub fn to_celsius(&self) -> f64 { self.celsius }
    pub fn to_fahrenheit(&self) -> f64 { self.celsius * Self::F_FACTOR + Self::F_OFFSET }
    pub fn to_kelvin(&self) -> f64 { self.celsius + Self::K_OFFSET }
}