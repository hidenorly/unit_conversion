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



#[cfg(test)]
mod tests {
    use unit_conversion::Speed;

    #[test]
    fn test_speed_conversion() {
        let epsilon = 0.001;

        // test km/h -> mph
        let s1 = Speed::from_kmh(60.0);
        assert!((s1.to_mph() - 37.2823).abs() < epsilon);
        assert!((s1.to_ms() - 60.0/3.6).abs() < epsilon);

        // test mph -> km/h
        let s2 = Speed::from_mph(60.0);
        assert!((s2.to_kmh() - 96.5606).abs() < epsilon);
        assert!((s2.to_ms() - 60.0*0.44704).abs() < epsilon);

        // test zero
        let s3 = Speed::from_kmh(0.0);
        assert_eq!(s3.to_mph(), 0.0);

        // test identicality
        let original = 120.5;
        let s4 = Speed::from_kmh(original);
        assert!( (s4.to_kmh() - original).abs() < 0.000001);
    }

    use unit_conversion::Temperature;

    #[test]
    fn test_temp_conversion() {
        let eps = 0.001;

        // 32 F -> 0 C
        let t1 = Temperature::from_fahrenheit(32.0);
        assert!((t1.to_celsius() - 0.0).abs() < eps);

        // 100 C -> 212 F
        let t2 = Temperature::from_celsius(100.0);
        assert!((t2.to_fahrenheit() - 212.0).abs() < eps);

        // 0 C -> 273.15 K
        let t3 = Temperature::from_celsius(0.0);
        assert_eq!(t3.to_kelvin(), 273.15);
    }


    use unit_conversion::Mass;

    #[test]
    fn test_mass_conversion() {
        let eps = 0.00001;

        // 1000g -> 1kg
        assert_eq!(Mass::from_gram(1000.0).to_kg(), 1.0);

        // 1lb -> 0.45359kg
        assert!((Mass::from_lb(1.0).to_kg() - 0.453592).abs() < eps);

        // 1kg -> 2.20462lb
        assert!((Mass::from_kg(1.0).to_lb() - 2.20462).abs() < eps);

        // 1lb -> 16oz
        assert!((Mass::from_lb(1.0).to_oz() - 16.0).abs() < eps);
    }


    use unit_conversion::Distance;

    #[test]
    fn test_distance_conversion() {
        let eps = 1e-9;

        // 1.0 km -> 1000.0 m
        assert_eq!(Distance::from_km(1.0).to_meters(), 1000.0);

        // 1.0 mile -> 1.609344 km
        let d_mile = Distance::from_mile(1.0);
        assert!((d_mile.to_km() - 1.609344).abs() < eps);

        // 1.0 ft -> 12.0 inch
        let d_ft = Distance::from_feet(1.0);
        assert!((d_ft.to_inch() - 12.0).abs() < eps);

        // 100.0 inch -> 2.54 m
        let d_in = Distance::from_inch(100.0);
        assert!((d_in.to_meters() - 2.54).abs() < eps);
    }
}