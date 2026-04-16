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
    const EPSILON: f64 = 0.001;

    use unit_conversion::Speed;

    #[test]
    fn test_speed_conversion() {
        // test km/h -> mph
        let s1 = Speed::from_kmh(60.0);
        assert!((s1.to_kmh() - 60.0).abs() < EPSILON);
        assert!((s1.to_mph() - 37.2823).abs() < EPSILON);
        assert!((s1.to_ms() - 60.0/3.6).abs() < EPSILON);

        // test mph -> km/h
        let s2 = Speed::from_mph(60.0);
        assert!((s2.to_mph() - 60.0).abs() < EPSILON);
        assert!((s2.to_kmh() - 96.5606).abs() < EPSILON);
        assert!((s2.to_ms() - 60.0*0.44704).abs() < EPSILON);

        // test zero
        let s3 = Speed::from_kmh(0.0);
        assert_eq!(s3.to_kmh(), 0.0);
        assert_eq!(s3.to_mph(), 0.0);
        assert_eq!(s3.to_ms(), 0.0);

        // test identicality
        let original = 120.5;
        let s4 = Speed::from_kmh(original);
        assert!( (s4.to_kmh() - original).abs() < 0.000001);

        // test m/s -> km/h
        let s5 = Speed::from_ms(60.0/3.6);
        assert!((s5.to_ms() - 60.0/3.6).abs() < EPSILON);
        assert!((s5.to_kmh() - 60.0).abs() < EPSILON);
        assert!((s5.to_mph() - 37.2823).abs() < EPSILON);
    }

    use unit_conversion::Temperature;

    #[test]
    fn test_temp_conversion() {
        // 32 F -> 0 C
        let t1 = Temperature::from_fahrenheit(32.0);
        assert!((t1.to_fahrenheit() - 32.0).abs() < EPSILON);
        assert!((t1.to_celsius() - 0.0).abs() < EPSILON);

        // 100 C -> 212 F
        let t2 = Temperature::from_celsius(100.0);
        assert!((t2.to_celsius() - 100.0).abs() < EPSILON);
        assert!((t2.to_fahrenheit() - 212.0).abs() < EPSILON);

        // 0 C -> 273.15 K
        let t3 = Temperature::from_celsius(0.0);
        assert!((t3.to_celsius() - 0.0).abs() < EPSILON);
        assert_eq!(t3.to_kelvin(), 273.15);

        // 0 C -> 273.15 K
        let t4 = Temperature::from_kelvin(273.15);
        assert_eq!(t4.to_kelvin(), 273.15);
        assert!((t4.to_celsius() - 0.0).abs() < EPSILON);
    }


    use unit_conversion::Mass;

    #[test]
    fn test_mass_conversion() {
        // 1000g -> 1kg
        let w = Mass::from_gram(1000.0);
        assert_eq!(w.to_gram(), 1000.0);
        assert_eq!(w.to_kg(), 1.0);

        // 1lb -> 0.45359kg
        let w2 = Mass::from_lb(1.0);
        assert!((w2.to_lb() - 1.0).abs() < EPSILON);
        assert!((w2.to_kg() - 0.453592).abs() < EPSILON);

        // 1kg -> 2.20462lb
        let w3 = Mass::from_kg(1.0);
        assert_eq!(w3.to_kg(), 1.0);
        assert!((w3.to_lb() - 2.20462).abs() < EPSILON);

        // 1lb -> 16oz
        let w4 = Mass::from_lb(1.0);
        assert!((w4.to_lb() - 1.0).abs() < EPSILON);
        assert!((w4.to_oz() - 16.0).abs() < EPSILON);
    }


    use unit_conversion::Distance;

    #[test]
    fn test_distance_conversion() {
        // 1.0 km -> 1000.0 m
        let d_km = Distance::from_km(1.0);
        assert_eq!(d_km.to_km(), 1.0);
        assert_eq!(d_km.to_meters(), 1000.0);

        // 1.0 mile -> 1.609344 km
        let d_mile = Distance::from_mile(1.0);
        assert!((d_mile.to_mile() - 1.0).abs() < EPSILON);
        assert!((d_mile.to_km() - 1.609344).abs() < EPSILON);

        // 1.0 ft -> 12.0 inch
        let d_ft = Distance::from_feet(1.0);
        assert!((d_ft.to_feet() - 1.0).abs() < EPSILON);
        assert!((d_ft.to_inch() - 12.0).abs() < EPSILON);

        // 100.0 inch -> 2.54 m
        let d_in = Distance::from_inch(100.0);
        assert!((d_in.to_inch() - 100.0).abs() < EPSILON);
        assert!((d_in.to_meters() - 2.54).abs() < EPSILON);
    }


    use unit_conversion::Pressure;

    #[test]
    fn test_pressure_conversion() {
        let p = Pressure::from_bar(2.5);
        assert!((p.to_bar() - 2.5).abs() < EPSILON);
        assert!((p.to_kpa() - 250.0).abs() < EPSILON);
        assert!((p.to_psi() - 36.2594).abs() < EPSILON);

        let p2 = Pressure::from_kpa(250.0);
        assert!((p2.to_bar() - 2.5).abs() < EPSILON);
        assert!((p2.to_kpa() - 250.0).abs() < EPSILON);
        assert!((p2.to_psi() - 36.2594).abs() < EPSILON);

        let p3 = Pressure::from_psi(36.2594);
        assert!((p3.to_bar() - 2.5).abs() < EPSILON);
        assert!((p3.to_kpa() - 250.0).abs() < EPSILON);
        assert!((p3.to_psi() - 36.2594).abs() < EPSILON);
    }


    use unit_conversion::Torque;

    #[test]
    fn test_torque_conversion() {
        let t = Torque::from_lbft(1.0);
        assert!((t.to_lbft() - 1.0).abs() < EPSILON);
        assert!((t.to_nm() - 1.355818).abs() < EPSILON);
        assert!((t.to_kgfm() - 0.138255).abs() < EPSILON);

        let t2 = Torque::from_nm(1.355818);
        assert!((t2.to_lbft() - 1.0).abs() < EPSILON);
        assert!((t2.to_nm() - 1.355818).abs() < EPSILON);
        assert!((t2.to_kgfm() - 0.138255).abs() < EPSILON);

        let t3 = Torque::from_kgfm(0.138255);
        assert!((t3.to_lbft() - 1.0).abs() < EPSILON);
        assert!((t3.to_nm() - 1.355818).abs() < EPSILON);
        assert!((t3.to_kgfm() - 0.138255).abs() < EPSILON);
    }


    use unit_conversion::Angle;
    use std::f64::consts::PI;
    #[test]
    fn test_angle_conversion() {
        let a = Angle::from_degrees(180.0);
        assert!((a.to_degrees() - 180.0).abs() < EPSILON);
        assert!((a.to_radians() - PI).abs() < EPSILON);

        let a2 = Angle::from_radians(PI / 2.0);
        assert!((a2.to_radians() - (PI/2.0)).abs() < EPSILON);
        assert!((a2.to_degrees() - 90.0).abs() < EPSILON);
    }


    use unit_conversion::Efficiency;
    #[test]
    fn test_efficiency_conversion() {
        let e_l100km = Efficiency::from_l100km(10.0);
        assert_eq!(e_l100km.to_l100km(), 10.0);
        assert_eq!(e_l100km.to_kml(), 10.0);
        assert!((e_l100km.to_mpg() - 23.5215).abs() < EPSILON);

        let e_mpg = Efficiency::from_mpg(23.5215);
        assert!((e_mpg.to_mpg() - 23.5215).abs() < EPSILON);
        assert!((e_mpg.to_kml() - 10.0).abs() < EPSILON);
        assert!((e_mpg.to_l100km() - 10.0).abs() < EPSILON);

        let e_kml = Efficiency::from_kml(10.0);
        assert!((e_kml.to_kml() - 10.0).abs() < EPSILON);
        assert!((e_kml.to_mpg() - 23.5215).abs() < EPSILON);
        assert!((e_kml.to_l100km() - 10.0).abs() < EPSILON);
    }


    use unit_conversion::Volume;
    #[test]
    fn test_volume_conversion() {
        let v_l = Volume::from_liters(1.0);
        assert!((v_l.to_liters() - 1.0).abs() < EPSILON);
        assert!((v_l.to_ml() - 1000.0).abs() < EPSILON);
        assert!((v_l.to_us_gallons() - 0.264172).abs() < EPSILON);
        assert!((v_l.to_imp_gallons() - 0.219969).abs() < EPSILON);

        let v_ml = Volume::from_ml(100.0);
        assert!((v_ml.to_liters() - 0.1).abs() < EPSILON);
        assert!((v_ml.to_ml() - 100.0).abs() < EPSILON);
        assert!((v_ml.to_us_gallons() - 0.026417).abs() < EPSILON);
        assert!((v_ml.to_imp_gallons() - 0.021996).abs() < EPSILON);

        let v_us = Volume::from_us_gallons(1.0);
        assert!((v_us.to_us_gallons() - 1.0).abs() < EPSILON);
        assert!((v_us.to_liters() - 3.785411).abs() < EPSILON);
        assert!((v_us.to_ml() - 3785.411).abs() < EPSILON);
        assert!((v_us.to_imp_gallons() - 0.832674).abs() < EPSILON);

        let v_imp = Volume::from_imp_gallons(1.0);
        assert!((v_imp.to_imp_gallons() - 1.0).abs() < EPSILON);

        assert!((v_imp.to_us_gallons() - 1.20095).abs() < EPSILON);
        assert!((v_imp.to_liters() - 4.54609).abs() < EPSILON);
        assert!((v_imp.to_ml() - 4546.09).abs() < EPSILON);
    }

}