# Unit Conversion Library

This library is a header-only C++ utility designed to perform safe, type-safe, and concise unit conversions for various physical quantities (Speed, Temperature, Mass, Distance, etc.).

## Features

* **Type-Safe**: Each physical quantity is defined as its own class, preventing logical errors such as accidentally assigning a distance value to a speed variable.
* **Intuitive API**: Easily convert units using static `fromXxx()` factory methods and `toXxx()` instance methods.
* **Built-in Validation**: Automatically checks for `NaN`, `Inf`, and physical constraints (e.g., temperatures below absolute zero) and throws `std::invalid_argument` exceptions.
* **Operator Overloading**: Supports intuitive mathematical operations between related physical quantities (e.g., `Speed * Time = Distance`).

## Usage

Since this is a header-only library, simply include `unit_conversion.hpp` in your source files to start using it.

```cpp
#include "unit_conversion.hpp"
#include <iostream>

int main() {
    // Example: Converting Distance
    auto dist = Distance::fromKm(10.0);
    std::cout << "10km is " << dist.toMeters() << " meters." << std::endl;

    // Example: Converting Temperature
    auto temp = Temperature::fromCelsius(25.0);
    std::cout << "25°C is " << temp.toFahrenheit() << " Fahrenheit." << std::endl;

    // Example: Using operators
    Speed speed = Speed::fromKmH(100.0);
    Time time = Time::fromHours(0.5);
    Distance d = speed * time; // Speed * Time = Distance
    
    return 0;
}
```

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

## Compile Options

By defining `NO_NEGATIVE_ALLOWED` before including the header, the library will throw an `std::invalid_argument` exception if you attempt to set negative values for the following classes:

* `Speed`, `Distance`, `Power`, `Torque`
