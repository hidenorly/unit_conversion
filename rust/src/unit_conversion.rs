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
}