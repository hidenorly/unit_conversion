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

using System;

namespace UnitConversion
{
    public readonly struct Speed
    {
        private readonly double m_ms;
        private const double ConvertKmhMs = 3.6;
        private const double ConvertMphMs = 0.44704;

        private Speed(double ms)
        {
            if (double.IsNaN(ms) || double.IsInfinity(ms) || ms < 0.0)
                throw new ArgumentException("Speed must be a non-negative finite number");
            m_ms = ms;
        }

        public static Speed FromMs(double value) => new Speed(value);
        public static Speed FromKmH(double value) => new Speed(value / ConvertKmhMs);
        public static Speed FromMph(double value) => new Speed(value * ConvertMphMs);

        public double ToMs() => m_ms;
        public double ToKmH() => m_ms * ConvertKmhMs;
        public double ToMph() => m_ms / ConvertMphMs;

        public override string ToString() => $"{ToMs()} m/s";

        public static Speed operator +(Speed a, Speed b) => FromMs(a.m_ms + b.m_ms);
        public static Speed operator -(Speed a, Speed b) => FromMs(a.m_ms - b.m_ms);
        public static Speed operator *(Speed s, double scalar) => FromMs(s.m_ms * scalar);
        public static Speed operator *(double scalar, Speed s) => FromMs(s.m_ms * scalar);
        public static Distance operator *(Speed s, Time t) => Distance.FromMeters(s.m_ms * t.ToSeconds());
        public static Acceleration operator /(Speed s, Time t)
        {
            if (t.ToSeconds() == 0.0) throw new ArgumentException("Time cannot be zero");
            return Acceleration.FromMs2(s.m_ms / t.ToSeconds());
        }
        public static Time operator /(Speed s, Acceleration a)
        {
            if (a.ToMs2() == 0.0) throw new ArgumentException("Acceleration cannot be zero");
            return Time.FromSeconds(s.m_ms / a.ToMs2());
        }
    }

    public readonly struct Temperature
    {
        private readonly double m_celsius;
        private const double AbsoluteZeroC = -273.15;
        private const double FOffset = 32.0;
        private const double FFactor = 1.8;
        private const double KOffset = 273.15;

        private Temperature(double c)
        {
            if (double.IsNaN(c) || double.IsInfinity(c) || c < AbsoluteZeroC)
                throw new ArgumentException("Temperature below absolute zero or invalid");
            m_celsius = c;
        }

        public static Temperature FromCelsius(double v) => new Temperature(v);
        public static Temperature FromFahrenheit(double v) => new Temperature((v - FOffset) / FFactor);
        public static Temperature FromKelvin(double v) => new Temperature(v - KOffset);

        public double ToCelsius() => m_celsius;
        public double ToFahrenheit() => m_celsius * FFactor + FOffset;
        public double ToKelvin() => m_celsius + KOffset;

        public override string ToString() => $"{ToCelsius()} °C";
    }

    public readonly struct Mass
    {
        private readonly double mWeightKg;
        private const double GToKg = 0.001;
        private const double LbToKg = 0.45359237;
        private const double OzToKg = 0.0283495231;

        private Mass(double kg)
        {
            if (double.IsNaN(kg) || double.IsInfinity(kg) || kg < 0.0)
                throw new ArgumentException("Mass must be a non-negative finite number");
            mWeightKg = kg;
        }

        public static Mass FromKg(double v) => new Mass(v);
        public static Mass FromGram(double v) => new Mass(v * GToKg);
        public static Mass FromLb(double v) => new Mass(v * LbToKg);
        public static Mass FromOz(double v) => new Mass(v * OzToKg);

        public double ToKg() => mWeightKg;
        public double ToGram() => mWeightKg / GToKg;
        public double ToLb() => mWeightKg / LbToKg;
        public double ToOz() => mWeightKg / OzToKg;

        public override string ToString() => $"{ToKg()} kg";
    }

    public readonly struct Distance
    {
        private readonly double m_meters;
        private const double KmToM = 1000.0;
        private const double MileToM = 1609.344;
        private const double FtToM = 0.3048;
        private const double InToM = 0.0254;
        private const double MmToM = 0.001;

        private Distance(double meters)
        {
            if (double.IsNaN(meters) || double.IsInfinity(meters) || meters < 0.0)
                throw new ArgumentException("Distance must be a valid non-negative number");
            m_meters = meters;
        }

        public static Distance FromMeters(double v) => new Distance(v);
        public static Distance FromKm(double v) => new Distance(v * KmToM);
        public static Distance FromMile(double v) => new Distance(v * MileToM);
        public static Distance FromFeet(double v) => new Distance(v * FtToM);
        public static Distance FromInch(double v) => new Distance(v * InToM);
        public static Distance FromMm(double v) => new Distance(v * MmToM);

        public double ToMeters() => m_meters;
        public double ToKm() => m_meters / KmToM;
        public double ToMile() => m_meters / MileToM;
        public double ToFeet() => m_meters / FtToM;
        public double ToInch() => m_meters / InToM;
        public double ToMm() => m_meters / MmToM;

        public override string ToString() => $"{ToMeters()} m";

        public static Distance operator +(Distance a, Distance b) => FromMeters(a.m_meters + b.m_meters);
        public static Distance operator -(Distance a, Distance b) => FromMeters(a.m_meters - b.m_meters);
        public static Distance operator *(Distance d, double scalar) => FromMeters(d.m_meters * scalar);
        public static Distance operator *(double scalar, Distance d) => FromMeters(d.m_meters * scalar);
        public static Speed operator /(Distance d, Time t)
        {
            if (t.ToSeconds() == 0.0) throw new ArgumentException("Time cannot be zero");
            return Speed.FromMs(d.m_meters / t.ToSeconds());
        }
        public static Time operator /(Distance d, Speed s)
        {
            if (s.ToMs() == 0.0) throw new ArgumentException("Speed cannot be zero");
            return Time.FromSeconds(d.m_meters / s.ToMs());
        }
        public static double operator /(Distance a, Distance b)
        {
            if (b.ToMeters() == 0.0) throw new ArgumentException("Distance cannot be zero");
            return a.m_meters / b.m_meters;
        }
    }

    public readonly struct Pressure
    {
        private readonly double m_kpa;
        private const double BarToKpa = 100.0;
        private const double PsiToKpa = 6.89476;

        private Pressure(double kpa)
        {
            if (double.IsNaN(kpa) || double.IsInfinity(kpa) || kpa < 0.0)
                throw new ArgumentException("Pressure must be a non-negative finite number");
            m_kpa = kpa;
        }

        public static Pressure FromKpa(double v) => new Pressure(v);
        public static Pressure FromBar(double v) => new Pressure(v * BarToKpa);
        public static Pressure FromPsi(double v) => new Pressure(v * PsiToKpa);

        public double ToKpa() => m_kpa;
        public double ToBar() => m_kpa / BarToKpa;
        public double ToPsi() => m_kpa / PsiToKpa;

        public override string ToString() => $"{ToKpa()} kPa";
    }

    public readonly struct Power
    {
        private readonly double m_kw;
        private const double PsToKw = 0.73549875;
        private const double HpToKw = 0.74569987;

        private Power(double kw)
        {
            if (double.IsNaN(kw) || double.IsInfinity(kw) || kw < 0.0)
                throw new ArgumentException("Power must be a valid non-negative number");
            m_kw = kw;
        }

        public static Power FromKw(double v) => new Power(v);
        public static Power FromPs(double v) => new Power(v * PsToKw);
        public static Power FromHp(double v) => new Power(v * HpToKw);

        public double ToKw() => m_kw;
        public double ToPs() => m_kw / PsToKw;
        public double ToHp() => m_kw / HpToKw;

        public override string ToString() => $"{ToKw()} kW";
    }

    public readonly struct Torque
    {
        private readonly double m_nm;
        private const double KgfmToNm = 9.80665;
        private const double LbftToNm = 1.355817948;

        private Torque(double nm)
        {
            if (double.IsNaN(nm) || double.IsInfinity(nm) || nm < 0.0)
                throw new ArgumentException("Torque must be a valid non-negative number");
            m_nm = nm;
        }

        public static Torque FromNm(double v) => new Torque(v);
        public static Torque FromKgfm(double v) => new Torque(v * KgfmToNm);
        public static Torque FromLbft(double v) => new Torque(v * LbftToNm);

        public double ToNm() => m_nm;
        public double ToKgfm() => m_nm / KgfmToNm;
        public double ToLbft() => m_nm / LbftToNm;

        public override string ToString() => $"{ToNm()} Nm";
    }

    public readonly struct Angle
    {
        private readonly double m_rad;
        private const double DegToRad = Math.PI / 180.0;
        private const double TwoPi = Math.PI * 2.0;

        private Angle(double rad)
        {
            if (double.IsNaN(rad) || double.IsInfinity(rad))
                throw new ArgumentException("Angle must be finite");
            m_rad = rad;
        }

        public static Angle FromRadians(double v) => new Angle(v);
        public static Angle FromDegrees(double v) => new Angle(v * DegToRad);

        public double ToRadians() => m_rad;
        public double ToDegrees() => m_rad / DegToRad;

        public override string ToString() => $"{ToRadians()} rad";

        public Angle Normalized()
        {
            double normalized = m_rad % TwoPi;
            if (normalized < 0.0)
            {
                normalized += TwoPi;
            }
            return new Angle(normalized);
        }

        public Angle NormalizedSigned()
        {
            double r = (m_rad + Math.PI) % TwoPi;
            if (r < 0.0)
            {
                r += TwoPi;
            }
            return new Angle(r - Math.PI);
        }
    }

    public readonly struct Efficiency
    {
        private readonly double m_kml;
        private const double MpgToKml = 0.425143707;

        private Efficiency(double kml)
        {
            if (double.IsNaN(kml) || double.IsInfinity(kml) || kml <= 0.0)
                throw new ArgumentException("Must be positive");
            m_kml = kml;
        }

        public static Efficiency FromKml(double v) => new Efficiency(v);
        public static Efficiency FromL100km(double v) => new Efficiency(100.0 / v);
        public static Efficiency FromMpg(double v) => new Efficiency(v * MpgToKml);

        public double ToKml() => m_kml;
        public double ToL100km() => 100.0 / m_kml;
        public double ToMpg() => m_kml / MpgToKml;

        public override string ToString() => $"{ToKml()} km/L";
    }

    public readonly struct EvEfficiency
    {
        private readonly double m_km_per_kwh;
        private const double MileToKm = 1.609344;

        private EvEfficiency(double kmPerKwh)
        {
            if (double.IsNaN(kmPerKwh) || double.IsInfinity(kmPerKwh) || kmPerKwh <= 0.0)
                throw new ArgumentException("Must be positive");
            m_km_per_kwh = kmPerKwh;
        }

        public static EvEfficiency FromKmkWh(double v) => new EvEfficiency(v);
        public static EvEfficiency FromWhkm(double v) => new EvEfficiency(1000.0 / v);
        public static EvEfficiency FromKwh100km(double v) => new EvEfficiency(100.0 / v);
        public static EvEfficiency FromMpKwh(double v) => new EvEfficiency(v * MileToKm);

        public double ToKmkWh() => m_km_per_kwh;
        public double ToWhkm() => 1000.0 / m_km_per_kwh;
        public double ToKwh100km() => 100.0 / m_km_per_kwh;
        public double ToMpKwh() => m_km_per_kwh / MileToKm;

        public override string ToString() => $"{ToKmkWh()} km/kWh";
    }

    public readonly struct Volume
    {
        private readonly double m_liters;
        private const double UsGalToL = 3.785411784;
        private const double ImpGalToL = 4.54609;

        private Volume(double l)
        {
            if (double.IsNaN(l) || double.IsInfinity(l) || l < 0.0)
                throw new ArgumentException("Volume must be a non-negative finite number");
            m_liters = l;
        }

        public static Volume FromLiters(double v) => new Volume(v);
        public static Volume FromMl(double v) => new Volume(v / 1000.0);
        public static Volume FromUsGallons(double v) => new Volume(v * UsGalToL);
        public static Volume FromImpGallons(double v) => new Volume(v * ImpGalToL);

        public double ToLiters() => m_liters;
        public double ToMl() => m_liters * 1000.0;
        public double ToUsGallons() => m_liters / UsGalToL;
        public double ToImpGallons() => m_liters / ImpGalToL;

        public override string ToString() => $"{ToLiters()} L";
    }

    public readonly struct Time
    {
        private readonly double m_sec;

        private Time(double s)
        {
            if (double.IsNaN(s) || double.IsInfinity(s) || s < 0.0)
                throw new ArgumentException("Invalid Time");
            m_sec = s;
        }

        public static Time FromSeconds(double v) => new Time(v);
        public static Time FromMinutes(double v) => new Time(v * 60.0);
        public static Time FromHours(double v) => new Time(v * 3600.0);

        public double ToSeconds() => m_sec;
        public double ToMinutes() => m_sec / 60.0;
        public double ToHours() => m_sec / 3600.0;

        public override string ToString() => $"{ToSeconds()} s";

        public static Time operator +(Time a, Time b) => FromSeconds(a.m_sec + b.m_sec);
        public static Time operator -(Time a, Time b) => FromSeconds(a.m_sec - b.m_sec);
        public static Time operator *(Time t, double scalar) => FromSeconds(t.m_sec * scalar);
        public static Time operator *(double scalar, Time t) => FromSeconds(t.m_sec * scalar);
    }

    public readonly struct Acceleration
    {
        private readonly double m_a;

        private Acceleration(double a)
        {
            if (double.IsNaN(a) || double.IsInfinity(a))
                throw new ArgumentException("Invalid Accel");
            m_a = a;
        }

        public static Acceleration FromMs2(double a) => new Acceleration(a);
        public static Acceleration FromSpeedAndTime(Speed s, Time t) => new Acceleration(s.ToMs() / t.ToSeconds());

        public double ToMs2() => m_a;

        public override string ToString() => $"{ToMs2()} m/s^2";

        public static Speed operator *(Acceleration a, Time t) => Speed.FromMs(a.m_a * t.ToSeconds());
        public static Acceleration operator *(Acceleration a, double scalar) => FromMs2(a.m_a * scalar);
        public static Acceleration operator *(double scalar, Acceleration a) => FromMs2(a.m_a * scalar);

        public static Speed operator /(Time t, Acceleration a)
        {
            if (a.ToMs2() == 0.0) throw new ArgumentException("Acceleration cannot be zero");
            return Speed.FromMs(t.ToSeconds() / a.ToMs2());
        }

        public static Acceleration operator /(Acceleration acc, Time t)
        {
            if (t.ToSeconds() == 0.0) throw new ArgumentException("Time cannot be zero");
            return FromMs2(acc.ToMs2() / t.ToSeconds());
        }
    }
}