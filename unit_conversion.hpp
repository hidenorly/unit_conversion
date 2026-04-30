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


class Torque {
private:
    double m_nm;
    static constexpr double KGFM_TO_NM = 9.80665;
    static constexpr double LBFT_TO_NM = 1.355817948;

    explicit Torque(double nm) : m_nm(nm) {}

public:
    static Torque fromNm(double v) { return Torque(v); }
    static Torque fromKgfm(double v) { return Torque(v * KGFM_TO_NM); }
    static Torque fromLbft(double v) { return Torque(v * LBFT_TO_NM); }

    double toNm() const { return m_nm; }
    double toKgfm() const { return m_nm / KGFM_TO_NM; }
    double toLbft() const { return m_nm / LBFT_TO_NM; }
};


class Angle {
private:
    double m_rad;
    // π / 180
    static constexpr double DEG_TO_RAD = 3.14159265358979323846 / 180.0;

    explicit Angle(double rad) : m_rad(rad) {}

public:
    static Angle fromRadians(double v) { return Angle(v); }
    static Angle fromDegrees(double v) { return Angle(v * DEG_TO_RAD); }

    double toRadians() const { return m_rad; }
    double toDegrees() const { return m_rad / DEG_TO_RAD; }
};


class Efficiency {
private:
    double m_kml;
    static constexpr double MPG_TO_KML = 0.425143707;

    explicit Efficiency(double kml) : m_kml(kml) {
        if( std::isnan(kml) || (std::isinf(kml)) || m_kml <= 0.0 ){
            throw std::invalid_argument("Must be positive");
        }
    }

public:
    static Efficiency fromKml(double v) { return Efficiency(v); }
    static Efficiency fromL100km(double v) { return Efficiency(100.0 / v); }
    static Efficiency fromMpg(double v) { return Efficiency(v * MPG_TO_KML); }

    double toKml() const { return m_kml; }
    double toL100km() const { return 100.0 / m_kml; }
    double toMpg() const { return m_kml / MPG_TO_KML; }
};


class EvEfficiency {
private:
    double m_km_per_kwh;
    static constexpr double MILE_TO_KM = 1.609344;

    explicit EvEfficiency(double km_per_kwh) : m_km_per_kwh(km_per_kwh) {
        if( std::isnan(km_per_kwh) || std::isinf(km_per_kwh) || km_per_kwh <= 0.0 ){
            throw std::invalid_argument("Must be positive");
        }
    }

public:
    static EvEfficiency fromKmkWh(double v) { return EvEfficiency(v); }
    static EvEfficiency fromWhkm(double v) { return EvEfficiency(1000.0 / v); }
    static EvEfficiency fromKwh100km(double v) { return EvEfficiency(100.0 / v); }
    static EvEfficiency fromMpKwh(double v) { return EvEfficiency(v * MILE_TO_KM); }

    double toKmkWh() const { return m_km_per_kwh; }
    double toWhkm() const { return 1000.0 / m_km_per_kwh; }
    double toKwh100km() const { return 100.0 / m_km_per_kwh; }
    double toMpKwh() const { return m_km_per_kwh / MILE_TO_KM; }
};


class Volume {
private:
    double m_liters;
    static constexpr double US_GAL_TO_L = 3.785411784;
    static constexpr double IMP_GAL_TO_L = 4.54609;
    explicit Volume(double l) : m_liters(l) {}

public:
    static Volume fromLiters(double v) { return Volume(v); }
    static Volume fromMl(double v) { return Volume(v / 1000.0); }
    static Volume fromUsGallons(double v) { return Volume(v * US_GAL_TO_L); }
    static Volume fromImpGallons(double v) { return Volume(v * IMP_GAL_TO_L); }

    double toLiters() const { return m_liters; }
    double toMl() const { return m_liters * 1000.0; }
    double toUsGallons() const { return m_liters / US_GAL_TO_L; }
    double toImpGallons() const { return m_liters / IMP_GAL_TO_L; }
};

#endif // __UNIT_CONVERSION_HPP__
