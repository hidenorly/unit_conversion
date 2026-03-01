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

        // test mph -> km/h
        let s2 = Speed::from_mph(60.0);
        assert!((s2.to_kmh() - 96.5606).abs() < epsilon);

        // test zero
        let s3 = Speed::from_kmh(0.0);
        assert_eq!(s3.to_mph(), 0.0);

        // test identicality
        let original = 120.5;
        let s4 = Speed::from_kmh(original);
        assert!( (s4.to_kmh() - original).abs() < 0.000001);
    }
}