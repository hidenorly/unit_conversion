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


// --- Speed

pub struct Speed {
    ms: f64,
}

impl Speed {
    const KMH_TO_MS: f64 = 3.6;
    const MPH_TO_MS: f64 = 0.44704;

    pub fn from_ms(value: f64) -> Self {
        Self { ms: value }
    }

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


// --- Temperature

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


// --- Weight

pub struct Mass {
    kg: f64,
}

impl Mass {
    const G_TO_KG: f64 = 0.001;
    const LB_TO_KG: f64 = 0.45359237;
    const OZ_TO_KG: f64 = 0.0283495231;

    pub fn from_kg(v: f64) -> Self { Self { kg: v } }
    pub fn from_gram(v: f64) -> Self { Self { kg: v * Self::G_TO_KG } }
    pub fn from_lb(v: f64) -> Self { Self { kg: v * Self::LB_TO_KG } }
    pub fn from_oz(v: f64) -> Self { Self { kg: v * Self::OZ_TO_KG } }

    pub fn to_kg(&self) -> f64 { self.kg }
    pub fn to_gram(&self) -> f64 { self.kg / Self::G_TO_KG }
    pub fn to_lb(&self) -> f64 { self.kg / Self::LB_TO_KG }
    pub fn to_oz(&self) -> f64 { self.kg / Self::OZ_TO_KG }
}


// --- Distance

pub struct Distance {
    meters: f64,
}

impl Distance {
    const KM_TO_M: f64 = 1000.0;
    const MILE_TO_M: f64 = 1609.344;
    const FT_TO_M: f64 = 0.3048;
    const IN_TO_M: f64 = 0.0254;

    pub fn from_meters(v: f64) -> Self { Self { meters: v } }
    pub fn from_km(v: f64) -> Self { Self { meters: v * Self::KM_TO_M } }
    pub fn from_mile(v: f64) -> Self { Self { meters: v * Self::MILE_TO_M } }
    pub fn from_feet(v: f64) -> Self { Self { meters: v * Self::FT_TO_M } }
    pub fn from_inch(v: f64) -> Self { Self { meters: v * Self::IN_TO_M } }

    pub fn to_meters(&self) -> f64 { self.meters }
    pub fn to_km(&self) -> f64 { self.meters / Self::KM_TO_M }
    pub fn to_mile(&self) -> f64 { self.meters / Self::MILE_TO_M }
    pub fn to_feet(&self) -> f64 { self.meters / Self::FT_TO_M }
    pub fn to_inch(&self) -> f64 { self.meters / Self::IN_TO_M }
}


// --- Pressure

pub struct Pressure {
    kpa: f64
}

impl Pressure {
    const BAR_TO_KPA: f64 = 100.0;
    const PSI_TO_KPA: f64 = 6.89476;

    pub fn from_kpa(v: f64) -> Self { Self { kpa: v } }
    pub fn from_bar(v: f64) -> Self { Self { kpa: v * Self::BAR_TO_KPA } }
    pub fn from_psi(v: f64) -> Self { Self { kpa: v * Self::PSI_TO_KPA } }

    pub fn to_kpa(&self) -> f64 { self.kpa }
    pub fn to_bar(&self) -> f64 { self.kpa / Self::BAR_TO_KPA }
    pub fn to_psi(&self) -> f64 { self.kpa / Self::PSI_TO_KPA }
}


// --- Torque

pub struct Torque { nm: f64 }

impl Torque {
    const KGFM_TO_NM: f64 = 9.80665;
    const LBFT_TO_NM: f64 = 1.355817948;

    pub fn from_nm(v: f64) -> Self { Self { nm: v } }
    pub fn from_kgfm(v: f64) -> Self { Self { nm: v * Self::KGFM_TO_NM } }
    pub fn from_lbft(v: f64) -> Self { Self { nm: v * Self::LBFT_TO_NM } }

    pub fn to_nm(&self) -> f64 { self.nm }
    pub fn to_kgfm(&self) -> f64 { self.nm / Self::KGFM_TO_NM }
    pub fn to_lbft(&self) -> f64 { self.nm / Self::LBFT_TO_NM }
}


// --- Angle

pub struct Angle { rad: f64 }

impl Angle {
    const DEG_TO_RAD: f64 = std::f64::consts::PI / 180.0;

    pub fn from_radians(v: f64) -> Self { Self { rad: v } }
    pub fn from_degrees(v: f64) -> Self { Self { rad: v * Self::DEG_TO_RAD } }

    pub fn to_radians(&self) -> f64 { self.rad }
    pub fn to_degrees(&self) -> f64 { self.rad / Self::DEG_TO_RAD }
}


// -- Efficiency

pub struct Efficiency { kml: f64 }

impl Efficiency {
    const MPG_TO_KML: f64 = 0.425143707;

    pub fn from_kml(v: f64) -> Self { Self { kml: v } }
    pub fn from_l100km(v: f64) -> Self { Self { kml: 100.0 / v } }
    pub fn from_mpg(v: f64) -> Self { Self { kml: v * Self::MPG_TO_KML } }

    pub fn to_kml(&self) -> f64 { self.kml }
    pub fn to_l100km(&self) -> f64 { 100.0 / self.kml }
    pub fn to_mpg(&self) -> f64 { self.kml / Self::MPG_TO_KML }
}