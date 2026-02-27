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

#ifndef __UNIT_CONVERSION_HPP__
#define __UNIT_CONVERSION_HPP__

class Speed {
private:
    double m_ms; // internal value is based on m/s
    explicit Speed(double ms) : m_ms(ms) {}
    static constexpr float convert_kmh_ms = 3.6f;
    static constexpr float convert_mph_ms = 0.44704f;

public:
    static Speed fromKmH(double value) { return Speed(value / convert_kmh_ms); }
    static Speed fromMph(double value) { return Speed(value * convert_mph_ms); }

    double toKmH() const { return m_ms * convert_kmh_ms; }
    double toMph() const { return m_ms / convert_mph_ms; }
    double toMs() const { return m_ms; }
};

#endif // __UNIT_CONVERSION_HPP__
