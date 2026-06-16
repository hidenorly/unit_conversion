/*
  Copyright (C) 2026 hidenorly

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtGain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import 'dart:math' as math;

class Speed {
  final double _ms;
  static const double convert_kmh_ms = 3.6;
  static const double convert_mph_ms = 0.44704;

  Speed._(this._ms);

  Speed.fromMs(double value) : _ms = value;
  Speed.fromKmH(double value) : _ms = value / convert_kmh_ms;
  Speed.fromMph(double value) : _ms = value * convert_mph_ms;

  double get toKmH => _ms * convert_kmh_ms;
  double get toMph => _ms / convert_mph_ms;
  double get toMs => _ms;
}


class Temperature {
  final double _celsius;
  static const double _fOffset = 32.0;
  static const double _fFactor = 1.8;
  static const double _kOffset = 273.15;
  static const double _absoluteZeroC = -273.15;

  Temperature._(this._celsius) {
    if (_celsius.isNaN || _celsius < _absoluteZeroC || _celsius.isInfinite) {
      throw ArgumentError('Temperature below absolute zero');
    }
  }

  Temperature.fromCelsius(double v) : this._(v);
  Temperature.fromFahrenheit(double v) : this._( (v - _fOffset) / _fFactor );
  Temperature.fromKelvin(double v) : this._( v - _kOffset );

  double get toCelsius => _celsius;
  double get toFahrenheit => _celsius * _fFactor + _fOffset;
  double get toKelvin => _celsius + _kOffset;
}


class Mass {
  final double _kg;
  static const double _gToKg = 0.001;
  static const double _lbToKg = 0.45359237;
  static const double _ozToKg = 0.0283495231;

  Mass._(this._kg);

  Mass.fromKg(double v) : _kg = v;
  Mass.fromGram(double v) : _kg = v * _gToKg;
  Mass.fromLb(double v) : _kg = v * _lbToKg;
  Mass.fromOz(double v) : _kg = v * _ozToKg;

  double get toKg => _kg;
  double get toGram => _kg / _gToKg;
  double get toLb => _kg / _lbToKg;
  double get toOz => _kg / _ozToKg;
}


class Distance {
  final double _meters;
  static const double _kmToM = 1000.0;
  static const double _mileToM = 1609.344;
  static const double _ftToM = 0.3048;
  static const double _inToM = 0.0254;
  static const double _mmToM = 0.001;

  Distance._(this._meters){
    if (_meters.isNaN || _meters < 0 || _meters.isInfinite) throw ArgumentError('Invalid distance');
  }

  Distance.fromMeters(double v) : this._(v);
  Distance.fromKm(double v) : this._(v * _kmToM);
  Distance.fromMile(double v) : this._(v * _mileToM);
  Distance.fromFeet(double v) : this._(v * _ftToM);
  Distance.fromInch(double v) : this._(v * _inToM);
  Distance.fromMm(double v) : this._(v * _mmToM);

  double get toMeters => _meters;
  double get toKm => _meters / _kmToM;
  double get toMile => _meters / _mileToM;
  double get toFeet => _meters / _ftToM;
  double get toInch => _meters / _inToM;
  double get toMm => _meters / _mmToM;
}


class Pressure {
  final double _kpa;
  static const double _barToKpa = 100.0;
  static const double _psiToKpa = 6.89476;

  Pressure._(this._kpa);

  Pressure.fromKpa(double v) : _kpa = v;
  Pressure.fromBar(double v) : _kpa = v * _barToKpa;
  Pressure.fromPsi(double v) : _kpa = v * _psiToKpa;

  double get toKpa => _kpa;
  double get toBar => _kpa / _barToKpa;
  double get toPsi => _kpa / _psiToKpa;
}


class Power {
  final double _kw;
  static const double _psToKw = 0.73549875;
  static const double _hpToKw = 0.74569987;

  Power._(this._kw) {
    if (_kw.isNaN || _kw < 0 || _kw.isInfinite) {
      throw ArgumentError('Power must be a non-negative finite number');
    }
  }

  Power.fromKw(double v) : this._(v);
  Power.fromPs(double v) : this._(v * _psToKw);
  Power.fromHp(double v) : this._(v * _hpToKw);

  double get toKw => _kw;
  double get toPs => _kw / _psToKw;
  double get toHp => _kw / _hpToKw;
}


class Torque {
  final double _nm;
  static const double _kgfmToNm = 9.80665;
  static const double _lbftToNm = 1.355817948;

  Torque._(this._nm) {
  if (_nm.isNaN || _nm < 0 || _nm.isInfinite) throw ArgumentError("Invalid torque");
  }
  Torque.fromNm(v) : this._( v );
  Torque.fromKgfm(double v) : this._( v * _kgfmToNm );
  Torque.fromLbft(double v) : this._( v * _lbftToNm );

  double get toNm => _nm;
  double get toKgfm => _nm / _kgfmToNm;
  double get toLbft => _nm / _lbftToNm;
}


class Angle {
  final double _rad;
  static const double _degToRad = math.pi / 180.0;

  Angle._(this._rad);

  Angle.fromRadians(double v) : _rad = v;
  Angle.fromDegrees(double v) : _rad = v * _degToRad;

  double get toRadians => _rad;
  double get toDegrees => _rad / _degToRad;
}


class Efficiency {
  final double _kml;
  static const double _mpgToKml = 0.425143707;

  Efficiency._(this._kml) {
    if (_kml <= 0 || _kml.isNaN || _kml.isInfinite) throw ArgumentError('Must be positive');
  }

  Efficiency.fromKml(double v) : this._(v);
  Efficiency.fromL100km(double v) : this._(100.0 / v);
  Efficiency.fromMpg(double v) : this._(v * _mpgToKml);

  double get toKml => _kml;
  double get toL100km => 100.0 / _kml;
  double get toMpg => _kml / _mpgToKml;
}


class EvEfficiency {
  final double _kmPerKwh;
  static const double _mileToKm = 1.609344;

  EvEfficiency._(this._kmPerKwh) {
    if (_kmPerKwh <= 0 || _kmPerKwh.isNaN || _kmPerKwh.isInfinite) throw ArgumentError('Must be positive');
  }

  EvEfficiency.fromKmkWh(double v) : this._(v);
  EvEfficiency.fromWhkm(double v) : this._(1000.0 / v);
  EvEfficiency.fromKwh100km(double v) : this._(100.0 / v);
  EvEfficiency.fromMpKwh(double v) : this._(v * _mileToKm);

  double get toKmkWh => _kmPerKwh;
  double get toWhkm => 1000.0 / _kmPerKwh;
  double get toKwh100km => 100.0 / _kmPerKwh;
  double get toMpKwh => _kmPerKwh / _mileToKm;
}


class Volume {
  final double _l;
  static const double _usGal = 3.785411784;
  static const double _impGal = 4.54609;

  Volume._(this._l);
  Volume.fromLiters(double v) : _l = v;
  Volume.fromMl(double v) : _l = v / 1000.0;
  Volume.fromUsGallons(double v) : _l = v * _usGal;
  Volume.fromImpGallons(double v) : _l = v * _impGal;

  double get toLiters => _l;
  double get toMl => _l * 1000.0;
  double get toUsGallons => _l / _usGal;
  double get toImpGallons => _l / _impGal;
}


class Time {
  final double _s;

  Time._(this._s) {
    if (_s.isNaN || _s < 0 || _s.isInfinite){
      throw ArgumentError();
    }
  }

  factory Time.fromSeconds(double v) => Time._(v);
  factory Time.fromMinutes(double v) => Time._(v * 60.0);
  factory Time.fromHours(double v) => Time._(v * 3600.0);

  double get toSeconds => _s;
  double get toMinutes => _s / 60.0;
  double get toHours => _s / 3600.0;
}


class Acceleration {
  final double _ms2;

  Acceleration.fromMs2(double ms2) : _ms2 = ms2 {
    if (ms2.isNaN || ms2.isInfinite) {
      throw ArgumentError('Acceleration must be finite');
    }
  }

  double get toMs2 => _ms2;

  Speed operator *(Time t) {
    return Speed.fromMs(_ms2 * t.toSeconds);
  }
}

extension AccelOps on Acceleration {
  Speed operator *(Time t) => Speed.fromMs(this.toMs2 * t.toSeconds);
}

extension PhysicsOps on Speed {
  Distance operator *(Time t) => Distance.fromMeters(this.toMs * t.toSeconds);
}

extension SpeedSub on Speed {
  Speed operator -(Speed other) => Speed.fromMs(this.toMs - other.toMs);
}

extension SpeedAdd on Speed {
  Speed operator +(Speed other) => Speed.fromMs(this.toMs + other.toMs);
}

extension SpeedDiv on Speed {
  Acceleration operator /(Time t) {
    if (t.toSeconds == 0.0) throw ArgumentError('Division by zero');
    return Acceleration.fromMs2(this.toMs / t.toSeconds);
  }
}