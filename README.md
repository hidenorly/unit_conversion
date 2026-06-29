# unit_conversion

This library provides "unit" conversion in several languages as same mental model.

## Remarkable point

* **Type-Safe**: Each physical quantity is defined as its own class, preventing logical errors such as accidentally assigning a distance value to a speed variable.
* **Intuitive API**: Easily convert units using static `fromXxx()` factory methods and `toXxx()` instance methods. (API convention depends on the language)
* **Built-in Validation**: Automatically checks for `NaN`, `Inf`, and physical constraints (e.g., temperatures below absolute zero) and throws `std::invalid_argument` exceptions.
* **Operator Overloading**: Supports intuitive mathematical operations between related physical quantities (e.g., `Speed * Time = Distance`).

## Supported Physical Quantities

Each class provides specific static factory methods and conversion methods.

| Class | Supported Units |
| --- | --- |
| **Speed** | km/h, mph, m/s |
| **Temperature** | Celsius, Fahrenheit, Kelvin |
| **Mass** | kg, g, lb, oz |
| **Distance** | m, km, mile, ft, inch, mm |
| **Pressure** | kPa, bar, psi |
| **Power** | kW, PS, HP |
| **Torque** | Nm, kgfm, lbft |
| **Angle** | Radians, Degrees |
| **Efficiency** | km/L, L/100km, MPG |
| **EvEfficiency** | km/kWh, Wh/km, kWh/100km, mile/kWh |
| **Volume** | Liters, mL, US Gallons, Imp Gallons |
| **Time** | seconds, minutes, hours |
| **Acceleration** | $m/s^2$ |

# Speed conversion

## C++

This is header only library. Then just you can use by copying the file to your project and ```#include "unit_conversion.hpp"```

### how-to use

```
#include "unit_conversion.hpp"

auto speed = Speed::fromKmH(60.0);
auto speedMph = speed.toMph();
```

### test

```
mkdir build; cd build
cmake ..
make
```

## dart

### how-to use

```
import '../lib/unit_conversion.dart';

final speed = Speed.fromKmH(60.0);
final speedMph = speed.toMph;
```

### test

```
cd dart
dart pub get
dart test
```

## rust

### how-to use

```
use unit_conversion::Speed;

// km/h -> mph
let speed = Speed::from_kmh(60.0);
let speedMph = speed.to_mph();
```

### test

```
cd rust
cargo test
```


## python

### how-to use

```
from unit_conversion import Speed

# conversion km/h -> mph
s1 = Speed.from_kmh(60.0)
print(s1.to_mph)
```

### test

```
cd python
PYTHONPATH=src python3 tests/test_unit_conversion.py
```

### install & test

```
cd python
pip install -e ".[dev]"
pytest
```


## ruby

### how-to use

```
require_relative 'unit_conversion'

speed = Speed.from_kmh(60.0)
puts speed.to_mph + " MPH"
```

### test

```
cd ruby
ruby -Ilib test/test_unit_conversion.rb
```

### install

```
cd ruby
gem build unit_conversion.gemspec
gem install ./unit_conversion-0.1.0.gem
```


# all test

```
make test
```