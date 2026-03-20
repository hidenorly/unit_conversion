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


class Distance {
private:
    double m_meters;
    static constexpr double KM_TO_M = 1000.0;
    static constexpr double MILE_TO_M = 1609.344;
    static constexpr double FT_TO_M = 0.3048;
    static constexpr double IN_TO_M = 0.0254;

    explicit Distance(double meters) : m_meters(meters) {}

public:
    static Distance fromMeters(double v) { return Distance(v); }
    static Distance fromKm(double v) { return Distance(v * KM_TO_M); }
    static Distance fromMile(double v) { return Distance(v * MILE_TO_M); }
    static Distance fromFeet(double v) { return Distance(v * FT_TO_M); }
    static Distance fromInch(double v) { return Distance(v * IN_TO_M); }

    double toMeters() const { return m_meters; }
    double toKm() const { return m_meters / KM_TO_M; }
    double toMile() const { return m_meters / MILE_TO_M; }
    double toFeet() const { return m_meters / FT_TO_M; }
    double toInch() const { return m_meters / IN_TO_M; }
};


class Pressure {
private:
    double m_kpa;
    static constexpr double BAR_TO_KPA = 100.0;
    static constexpr double PSI_TO_KPA = 6.89476;

    explicit Pressure(double kpa) : m_kpa(kpa) {}

public:
    static Pressure fromKpa(double v) { return Pressure(v); }
    static Pressure fromBar(double v) { return Pressure(v * BAR_TO_KPA); }
    static Pressure fromPsi(double v) { return Pressure(v * PSI_TO_KPA); }

    double toKpa() const { return m_kpa; }
    double toBar() const { return m_kpa / BAR_TO_KPA; }
    double toPsi() const { return m_kpa / PSI_TO_KPA; }
};

#endif // __UNIT_CONVERSION_HPP__
