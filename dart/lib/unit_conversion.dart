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

import 'dart:math' as math;

class Speed {
  final double _ms;
  static const double convert_kmh_ms = 3.6;
  static const double convert_mph_ms = 0.44704;

  Speed._(this._ms);

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

  Temperature._(this._celsius);

  Temperature.fromCelsius(double v) : _celsius = v;
  Temperature.fromFahrenheit(double v) : _celsius = (v - _fOffset) / _fFactor;
  Temperature.fromKelvin(double v) : _celsius = v - _kOffset;

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

  Distance._(this._meters);

  Distance.fromMeters(double v) : _meters = v;
  Distance.fromKm(double v) : _meters = v * _kmToM;
  Distance.fromMile(double v) : _meters = v * _mileToM;
  Distance.fromFeet(double v) : _meters = v * _ftToM;
  Distance.fromInch(double v) : _meters = v * _inToM;

  double get toMeters => _meters;
  double get toKm => _meters / _kmToM;
  double get toMile => _meters / _mileToM;
  double get toFeet => _meters / _ftToM;
  double get toInch => _meters / _inToM;
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


class Torque {
  final double _nm;
  static const double _kgfmToNm = 9.80665;
  static const double _lbftToNm = 1.355817948;

  Torque._(this._nm);

  Torque.fromNm(double v) : _nm = v;
  Torque.fromKgfm(double v) : _nm = v * _kgfmToNm;
  Torque.fromLbft(double v) : _nm = v * _lbftToNm;

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