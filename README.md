# unit_conversion

This library provides "unit" conversion in several languages as same mental model.

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
python test_unit_conversion.py
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
ruby test_unit_conversion.rb
```
