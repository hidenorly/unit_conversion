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

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Speed {
    ms: f64,
}

impl Speed {
    const KMH_TO_MS: f64 = 3.6;
    const MPH_TO_MS: f64 = 0.44704;

    fn new(value: f64) -> Self {
        if value.is_nan() || value < 0.0 || value.is_infinite() {
            panic!("Speed must be a non-negative finite number");
        }
        Self { ms: value }
    }

    pub fn from_ms(value: f64) -> Self {
        Self::new(value)
    }

    pub fn from_kmh(value: f64) -> Self {
        Self::new(value / Self::KMH_TO_MS)
    }

    pub fn from_mph(value: f64) -> Self {
        Self::new(value * Self::MPH_TO_MS)
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

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Temperature {
    celsius: f64,
}

impl Temperature {
    const ABSOLUTE_ZERO_C: f64 = -273.15;
    const F_OFFSET: f64 = 32.0;
    const F_FACTOR: f64 = 1.8;
    const K_OFFSET: f64 = 273.15;

    fn new(c: f64) -> Self {
        if c.is_nan() || c < Self::ABSOLUTE_ZERO_C || c.is_infinite() {
            panic!("Below absolute zero or invalid value");
        }
        Self { celsius: c }
    }

    pub fn from_celsius(v: f64) -> Self { Self::new(v) }
    pub fn from_fahrenheit(v: f64) -> Self { Self::new( (v - Self::F_OFFSET) / Self::F_FACTOR ) }
    pub fn from_kelvin(v: f64) -> Self { Self::new(v - Self::K_OFFSET) }

    pub fn to_celsius(&self) -> f64 { self.celsius }
    pub fn to_fahrenheit(&self) -> f64 { self.celsius * Self::F_FACTOR + Self::F_OFFSET }
    pub fn to_kelvin(&self) -> f64 { self.celsius + Self::K_OFFSET }
}


// --- Mass

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Mass {
    kg: f64,
}

impl Mass {
    const G_TO_KG: f64 = 0.001;
    const LB_TO_KG: f64 = 0.45359237;
    const OZ_TO_KG: f64 = 0.0283495231;

    fn new(kg: f64) -> Self {
        if kg.is_nan() || kg < 0.0 || kg.is_infinite() {
            panic!("Mass must be a non-negative finite number");
        }
        Self { kg }
    }

    pub fn from_kg(v: f64) -> Self { Self::new(v) }
    pub fn from_gram(v: f64) -> Self { Self::new(v * Self::G_TO_KG) }
    pub fn from_lb(v: f64) -> Self { Self::new(v * Self::LB_TO_KG) }
    pub fn from_oz(v: f64) -> Self { Self::new(v * Self::OZ_TO_KG) }

    pub fn to_kg(&self) -> f64 { self.kg }
    pub fn to_gram(&self) -> f64 { self.kg / Self::G_TO_KG }
    pub fn to_lb(&self) -> f64 { self.kg / Self::LB_TO_KG }
    pub fn to_oz(&self) -> f64 { self.kg / Self::OZ_TO_KG }
}


// --- Distance

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Distance {
    meters: f64,
}

impl Distance {
    const KM_TO_M: f64 = 1000.0;
    const MILE_TO_M: f64 = 1609.344;
    const FT_TO_M: f64 = 0.3048;
    const IN_TO_M: f64 = 0.0254;
    const MM_TO_M: f64 = 0.001;

    fn new(meters: f64) -> Self {
        if meters.is_nan() || meters < 0.0 || meters.is_infinite() { panic!("Invalid distance"); }
        Self { meters }
    }

    pub fn from_meters(v: f64) -> Self { Self::new( v ) }
    pub fn from_km(v: f64) -> Self { Self::new( v * Self::KM_TO_M ) }
    pub fn from_mile(v: f64) -> Self { Self::new( v * Self::MILE_TO_M ) }
    pub fn from_feet(v: f64) -> Self { Self::new( v * Self::FT_TO_M ) }
    pub fn from_inch(v: f64) -> Self { Self::new( v * Self::IN_TO_M ) }
    pub fn from_mm(v: f64) -> Self { Self::new(v * Self::MM_TO_M) }

    pub fn to_meters(&self) -> f64 { self.meters }
    pub fn to_km(&self) -> f64 { self.meters / Self::KM_TO_M }
    pub fn to_mile(&self) -> f64 { self.meters / Self::MILE_TO_M }
    pub fn to_feet(&self) -> f64 { self.meters / Self::FT_TO_M }
    pub fn to_inch(&self) -> f64 { self.meters / Self::IN_TO_M }
    pub fn to_mm(&self) -> f64 { self.meters / Self::MM_TO_M }
}


// --- Pressure

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Pressure {
    kpa: f64
}

impl Pressure {
    const BAR_TO_KPA: f64 = 100.0;
    const PSI_TO_KPA: f64 = 6.89476;

    fn new(kpa: f64) -> Self {
        if kpa.is_nan() || kpa < 0.0 || kpa.is_infinite() {
            panic!("Pressure must be a non-negative finite number");
        }
        Self { kpa }
    }

    pub fn from_kpa(v: f64) -> Self { Self::new(v) }
    pub fn from_bar(v: f64) -> Self { Self::new(v * Self::BAR_TO_KPA) }
    pub fn from_psi(v: f64) -> Self { Self::new(v * Self::PSI_TO_KPA) }

    pub fn to_kpa(&self) -> f64 { self.kpa }
    pub fn to_bar(&self) -> f64 { self.kpa / Self::BAR_TO_KPA }
    pub fn to_psi(&self) -> f64 { self.kpa / Self::PSI_TO_KPA }
}


// --- Power

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Power { kw: f64 }

impl Power {
    const PS_TO_KW: f64 = 0.73549875;
    const HP_TO_KW: f64 = 0.74569987;

    fn new(v: f64) -> Self {
        if v.is_nan() || v < 0.0 || v.is_infinite() {
            panic!("Power must be a non-negative finite number");
        }
        Self { kw: v }
    }

    pub fn from_kw(v: f64) -> Self { Self::new(v) }
    pub fn from_ps(v: f64) -> Self { Self::new(v * Self::PS_TO_KW) }
    pub fn from_hp(v: f64) -> Self { Self::new(v * Self::HP_TO_KW) }

    pub fn to_kw(&self) -> f64 { self.kw }
    pub fn to_ps(&self) -> f64 { self.kw / Self::PS_TO_KW }
    pub fn to_hp(&self) -> f64 { self.kw / Self::HP_TO_KW }
}


// --- Torque

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Torque { nm: f64 }

impl Torque {
    const KGFM_TO_NM: f64 = 9.80665;
    const LBFT_TO_NM: f64 = 1.355817948;

    fn new(nm: f64) -> Self {
        if nm.is_nan() || nm < 0.0 || nm.is_infinite() { panic!("Invalid torque"); }
        Self { nm }
    }

    pub fn from_nm(v: f64) -> Self { Self::new(v)  }
    pub fn from_kgfm(v: f64) -> Self { Self::new(v * Self::KGFM_TO_NM) }
    pub fn from_lbft(v: f64) -> Self { Self::new(v * Self::LBFT_TO_NM ) }

    pub fn to_nm(&self) -> f64 { self.nm }
    pub fn to_kgfm(&self) -> f64 { self.nm / Self::KGFM_TO_NM }
    pub fn to_lbft(&self) -> f64 { self.nm / Self::LBFT_TO_NM }
}


// --- Angle

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Angle { rad: f64 }

impl Angle {
    const DEG_TO_RAD: f64 = std::f64::consts::PI / 180.0;

    pub fn from_radians(v: f64) -> Self { Self { rad: v } }
    pub fn from_degrees(v: f64) -> Self { Self { rad: v * Self::DEG_TO_RAD } }

    pub fn to_radians(&self) -> f64 { self.rad }
    pub fn to_degrees(&self) -> f64 { self.rad / Self::DEG_TO_RAD }
}


// -- Efficiency

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Efficiency { kml: f64 }

impl Efficiency {
    const MPG_TO_KML: f64 = 0.425143707;

    fn new(v: f64) -> Self {
        if v <= 0.0 || v.is_nan() || v.is_infinite() {
            panic!("Must be positive");
        }
        Self { kml: v }
    }

    pub fn from_kml(v: f64) -> Self { Self::new(v) }
    pub fn from_l100km(v: f64) -> Self { Self::new(100.0 / v ) }
    pub fn from_mpg(v: f64) -> Self { Self::new(v * Self::MPG_TO_KML ) }

    pub fn to_kml(&self) -> f64 { self.kml }
    pub fn to_l100km(&self) -> f64 { 100.0 / self.kml }
    pub fn to_mpg(&self) -> f64 { self.kml / Self::MPG_TO_KML }
}


// -- EvEfficiency

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct EvEfficiency { km_per_kwh: f64 }

impl EvEfficiency {
    const MILE_TO_KM: f64 = 1.609344;

    fn new(v: f64) -> Self {
        if v <= 0.0 || v.is_nan() || v.is_infinite() {
            panic!("Must be positive");
        }
        Self { km_per_kwh: v }
    }

    pub fn from_km_per_kwh(v: f64) -> Self { Self::new(v) }
    pub fn from_wh_per_km(v: f64) -> Self { Self::new(1000.0 / v) }
    pub fn from_kwh_per_100km(v: f64) -> Self { Self::new(100.0 / v) }
    pub fn from_miles_per_kwh(v: f64) -> Self { Self::new(v * Self::MILE_TO_KM) }

    pub fn to_km_per_kwh(&self) -> f64 { self.km_per_kwh }
    pub fn to_wh_per_km(&self) -> f64 { 1000.0 / self.km_per_kwh }
    pub fn to_kwh_per_100km(&self) -> f64 { 100.0 / self.km_per_kwh }
    pub fn to_miles_per_kwh(&self) -> f64 { self.km_per_kwh / Self::MILE_TO_KM }
}


// --- Volume

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Volume { liters: f64 }

impl Volume {
    const US_GAL: f64 = 3.785411784;
    const IMP_GAL: f64 = 4.54609;

    fn new(liters: f64) -> Self {
        if liters.is_nan() || liters < 0.0 || liters.is_infinite() {
            panic!("Volume must be a non-negative finite number");
        }
        Self { liters }
    }

    pub fn from_liters(v: f64) -> Self { Self::new(v) }
    pub fn from_ml(v: f64) -> Self { Self::new(v / 1000.0) }
    pub fn from_us_gallons(v: f64) -> Self { Self::new(v * Self::US_GAL) }
    pub fn from_imp_gallons(v: f64) -> Self { Self::new(v * Self::IMP_GAL) }

    pub fn to_liters(&self) -> f64 { self.liters }
    pub fn to_ml(&self) -> f64 { self.liters * 1000.0 }
    pub fn to_us_gallons(&self) -> f64 { self.liters / Self::US_GAL }
    pub fn to_imp_gallons(&self) -> f64 { self.liters / Self::IMP_GAL }
}


// --- Time

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Time { s: f64 }

impl Time {
    pub fn new(s: f64) -> Self {
        if s.is_nan() || s < 0.0 || s.is_infinite() { panic!("Invalid Time"); }
        Self { s }
    }
    pub fn from_seconds(v: f64) -> Self { Self::new(v) }
    pub fn from_minutes(v: f64) -> Self { Self::new(v * 60.0) }
    pub fn from_hours(v: f64) -> Self { Self::new(v * 3600.0) }

    pub fn to_seconds(&self) -> f64 { self.s }
    pub fn to_minutes(&self) -> f64 { self.s / 60.0 }
    pub fn to_hours(&self) -> f64 { self.s / 3600.0 }
}


// --- Acceleration

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Acceleration { a: f64 }

impl Acceleration {
    pub fn new(a: f64) -> Self {
        if a.is_nan() || a.is_infinite() { panic!("Invalid Acceleration"); }
        Self { a }
    }
    pub fn from_speed_and_time(s: Speed, t: Time) -> Self {
        if t.to_seconds() == 0.0 { panic!("Time cannot be zero"); }
        Self::new(s.to_ms() / t.to_seconds())
    }
    pub fn from_ms2(a: f64) -> Self {
        Self::new(a)
    }
    pub fn to_ms2(&self) -> f64 { self.a }
}


// --- Operators

impl std::ops::Mul<Time> for Acceleration {
    type Output = Speed;
    fn mul(self, rhs: Time) -> Self::Output {
        Speed::from_ms(self.to_ms2() * rhs.to_seconds())
    }
}

impl std::ops::Mul<Acceleration> for Time {
    type Output = Speed;
    fn mul(self, rhs: Acceleration) -> Self::Output {
        rhs * self
    }
}

impl std::ops::Mul<Time> for Speed {
    type Output = Distance;
    fn mul(self, rhs: Time) -> Self::Output {
        Distance::from_meters(self.to_ms() * rhs.to_seconds())
    }
}

impl std::ops::Mul<Speed> for Time {
    type Output = Distance;
    fn mul(self, rhs: Speed) -> Self::Output {
        rhs * self
    }
}

// Distance / Time = Speed
impl std::ops::Div<Time> for Distance {
    type Output = Speed;
    fn div(self, rhs: Time) -> Self::Output {
        if rhs.to_seconds() == 0.0 {
            panic!("Time cannot be zero");
        }
        Speed::from_ms(self.to_meters() / rhs.to_seconds())
    }
}

// Distance / Speed = Time
impl std::ops::Div<Speed> for Distance {
    type Output = Time;
    fn div(self, rhs: Speed) -> Self::Output {
        if rhs.to_ms() == 0.0 {
            panic!("Speed cannot be zero");
        }
        Time::new(self.to_meters() / rhs.to_ms())
    }
}

impl std::ops::Sub for Speed {
    type Output = Speed;
    fn sub(self, rhs: Speed) -> Self::Output {
        Speed::from_ms(self.to_ms() - rhs.to_ms())
    }
}

impl std::ops::Add for Speed {
    type Output = Speed;
    fn add(self, rhs: Speed) -> Self::Output {
        Speed::from_ms(self.to_ms() + rhs.to_ms())
    }
}

impl std::ops::Sub for Distance {
    type Output = Distance;
    fn sub(self, rhs: Distance) -> Self::Output {
        Distance::from_meters(self.to_meters() - rhs.to_meters())
    }
}

impl std::ops::Add for Distance {
    type Output = Distance;
    fn add(self, rhs: Distance) -> Self::Output {
        Distance::from_meters(self.to_meters() + rhs.to_meters())
    }
}

impl std::ops::Sub for Time {
    type Output = Time;
    fn sub(self, rhs: Time) -> Self::Output {
        Time::new(self.to_seconds() - rhs.to_seconds())
    }
}

impl std::ops::Add for Time {
    type Output = Time;
    fn add(self, rhs: Time) -> Self::Output {
        Time::new(self.to_seconds() + rhs.to_seconds())
    }
}

impl std::ops::Div<Time> for Speed {
    type Output = Acceleration;
    fn div(self, rhs: Time) -> Self::Output {
        if rhs.to_seconds() == 0.0 {
            panic!("Division by zero");
        }
        Acceleration::new(self.to_ms() / rhs.to_seconds())
    }
}

impl std::ops::Mul<f64> for Speed {
    type Output = Speed;
    fn mul(self, rhs: f64) -> Self::Output {
        Speed::from_ms(self.to_ms() * rhs)
    }
}

impl std::ops::Mul<Speed> for f64 {
    type Output = Speed;
    fn mul(self, rhs: Speed) -> Self::Output {
        rhs * self
    }
}

impl std::ops::Mul<f64> for Distance {
    type Output = Distance;
    fn mul(self, rhs: f64) -> Self::Output {
        Distance::from_meters(self.to_meters() * rhs)
    }
}

impl std::ops::Mul<Distance> for f64 {
    type Output = Distance;
    fn mul(self, rhs: Distance) -> Self::Output {
        rhs * self
    }
}

impl std::ops::Mul<f64> for Acceleration {
    type Output = Acceleration;
    fn mul(self, rhs: f64) -> Self::Output {
        Acceleration::new(self.to_ms2() * rhs)
    }
}

impl std::ops::Mul<Acceleration> for f64 {
    type Output = Acceleration;
    fn mul(self, rhs: Acceleration) -> Self::Output {
        rhs * self
    }
}
