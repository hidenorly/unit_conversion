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