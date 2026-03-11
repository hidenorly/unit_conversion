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


class Temperature {
private:
    double m_celsius;
    static constexpr double F_OFFSET = 32.0;
    static constexpr double F_FACTOR = 1.8;
    static constexpr double K_OFFSET = 273.15;

    explicit Temperature(double c) : m_celsius(c) {}

public:
    static Temperature fromCelsius(double v) { return Temperature(v); }
    static Temperature fromFahrenheit(double v) { return Temperature((v - F_OFFSET) / F_FACTOR); }
    static Temperature fromKelvin(double v) { return Temperature(v - K_OFFSET); }

    double toCelsius() const { return m_celsius; }
    double toFahrenheit() const { return m_celsius * F_FACTOR + F_OFFSET; }
    double toKelvin() const { return m_celsius + K_OFFSET; }
};


class Mass {
private:
    double mWeightKg;
    static constexpr double G_TO_KG = 0.001;
    static constexpr double LB_TO_KG = 0.45359237;
    static constexpr double OZ_TO_KG = 0.0283495231;

    explicit Mass(double kg) : mWeightKg(kg) {}

public:
    static Mass fromKg(double v) { return Mass(v); }
    static Mass fromGram(double v) { return Mass(v * G_TO_KG); }
    static Mass fromLb(double v) { return Mass(v * LB_TO_KG); }
    static Mass fromOz(double v) { return Mass(v * OZ_TO_KG); }

    double toKg() const { return mWeightKg; }
    double toGram() const { return mWeightKg / G_TO_KG; }
    double toLb() const { return mWeightKg / LB_TO_KG; }
    double toOz() const { return mWeightKg / OZ_TO_KG; }
};

#endif // __UNIT_CONVERSION_HPP__
