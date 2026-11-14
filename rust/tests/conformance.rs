//! Conformance test: run the shared golden vectors (test_vectors.json
//! at the repository root) against the Rust implementation.
//!
//! Every language implementation runs the same vectors; a failure here
//! means this implementation disagrees with the shared specification.
//! Regenerate vectors with tools/generate_test_vectors.py.

use serde_json::Value;
use std::path::PathBuf;
use unit_conversion::{
    Acceleration, Angle, Distance, Efficiency, EvEfficiency, Mass, Power, Pressure, Speed,
    Temperature, Time, Torque, Volume,
};

fn find_vectors() -> PathBuf {
    if let Ok(p) = std::env::var("UNIT_CONVERSION_TEST_VECTORS") {
        return PathBuf::from(p);
    }
    // rust/ is one level below the repository root.
    let cand = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../test_vectors.json");
    if cand.exists() {
        return cand;
    }
    let mut d = std::env::current_dir().unwrap();
    for _ in 0..5 {
        let c = d.join("test_vectors.json");
        if c.exists() {
            return c;
        }
        d = d.parent().unwrap().to_path_buf();
    }
    panic!("test_vectors.json not found");
}

#[derive(Clone, Copy, Debug)]
enum Qty {
    Speed(Speed),
    Temperature(Temperature),
    Mass(Mass),
    Distance(Distance),
    Pressure(Pressure),
    Power(Power),
    Torque(Torque),
    Angle(Angle),
    Efficiency(Efficiency),
    EvEfficiency(EvEfficiency),
    Volume(Volume),
    Time(Time),
    Acceleration(Acceleration),
    Scalar(f64),
}

fn parse_value(v: &Value) -> f64 {
    match v {
        Value::Number(n) => n.as_f64().unwrap(),
        Value::String(s) => match s.as_str() {
            "NaN" => f64::NAN,
            "Infinity" => f64::INFINITY,
            "-Infinity" => f64::NEG_INFINITY,
            _ => panic!("bad value token {s}"),
        },
        _ => panic!("bad value {v}"),
    }
}

fn construct(spec: &Value) -> Qty {
    let quantity = spec["quantity"].as_str().unwrap();
    let unit = spec["unit"].as_str().unwrap();
    let v = parse_value(&spec["value"]);
    match (quantity, unit) {
        ("Speed", "ms") => Qty::Speed(Speed::from_ms(v)),
        ("Speed", "kmh") => Qty::Speed(Speed::from_kmh(v)),
        ("Speed", "mph") => Qty::Speed(Speed::from_mph(v)),
        ("Temperature", "celsius") => Qty::Temperature(Temperature::from_celsius(v)),
        ("Temperature", "fahrenheit") => Qty::Temperature(Temperature::from_fahrenheit(v)),
        ("Temperature", "kelvin") => Qty::Temperature(Temperature::from_kelvin(v)),
        ("Mass", "kg") => Qty::Mass(Mass::from_kg(v)),
        ("Mass", "gram") => Qty::Mass(Mass::from_gram(v)),
        ("Mass", "lb") => Qty::Mass(Mass::from_lb(v)),
        ("Mass", "oz") => Qty::Mass(Mass::from_oz(v)),
        ("Distance", "meters") => Qty::Distance(Distance::from_meters(v)),
        ("Distance", "km") => Qty::Distance(Distance::from_km(v)),
        ("Distance", "mile") => Qty::Distance(Distance::from_mile(v)),
        ("Distance", "feet") => Qty::Distance(Distance::from_feet(v)),
        ("Distance", "inch") => Qty::Distance(Distance::from_inch(v)),
        ("Distance", "mm") => Qty::Distance(Distance::from_mm(v)),
        ("Pressure", "kpa") => Qty::Pressure(Pressure::from_kpa(v)),
        ("Pressure", "bar") => Qty::Pressure(Pressure::from_bar(v)),
        ("Pressure", "psi") => Qty::Pressure(Pressure::from_psi(v)),
        ("Power", "kw") => Qty::Power(Power::from_kw(v)),
        ("Power", "ps") => Qty::Power(Power::from_ps(v)),
        ("Power", "hp") => Qty::Power(Power::from_hp(v)),
        ("Torque", "nm") => Qty::Torque(Torque::from_nm(v)),
        ("Torque", "kgfm") => Qty::Torque(Torque::from_kgfm(v)),
        ("Torque", "lbft") => Qty::Torque(Torque::from_lbft(v)),
        ("Angle", "radians") => Qty::Angle(Angle::from_radians(v)),
        ("Angle", "degrees") => Qty::Angle(Angle::from_degrees(v)),
        ("Efficiency", "kml") => Qty::Efficiency(Efficiency::from_kml(v)),
        ("Efficiency", "l100km") => Qty::Efficiency(Efficiency::from_l100km(v)),
        ("Efficiency", "mpg") => Qty::Efficiency(Efficiency::from_mpg(v)),
        ("EvEfficiency", "km_per_kwh") => Qty::EvEfficiency(EvEfficiency::from_km_per_kwh(v)),
        ("EvEfficiency", "wh_per_km") => Qty::EvEfficiency(EvEfficiency::from_wh_per_km(v)),
        ("EvEfficiency", "kwh_per_100km") => {
            Qty::EvEfficiency(EvEfficiency::from_kwh_per_100km(v))
        }
        ("EvEfficiency", "miles_per_kwh") => {
            Qty::EvEfficiency(EvEfficiency::from_miles_per_kwh(v))
        }
        ("Volume", "liters") => Qty::Volume(Volume::from_liters(v)),
        ("Volume", "ml") => Qty::Volume(Volume::from_ml(v)),
        ("Volume", "us_gallons") => Qty::Volume(Volume::from_us_gallons(v)),
        ("Volume", "imp_gallons") => Qty::Volume(Volume::from_imp_gallons(v)),
        ("Time", "seconds") => Qty::Time(Time::from_seconds(v)),
        ("Time", "minutes") => Qty::Time(Time::from_minutes(v)),
        ("Time", "hours") => Qty::Time(Time::from_hours(v)),
        ("Acceleration", "ms2") => Qty::Acceleration(Acceleration::from_ms2(v)),
        _ => panic!("unknown quantity/unit {quantity}/{unit}"),
    }
}

fn read(q: &Qty, unit: &str) -> f64 {
    match (q, unit) {
        (Qty::Speed(x), "ms") => x.to_ms(),
        (Qty::Speed(x), "kmh") => x.to_kmh(),
        (Qty::Speed(x), "mph") => x.to_mph(),
        (Qty::Temperature(x), "celsius") => x.to_celsius(),
        (Qty::Temperature(x), "fahrenheit") => x.to_fahrenheit(),
        (Qty::Temperature(x), "kelvin") => x.to_kelvin(),
        (Qty::Mass(x), "kg") => x.to_kg(),
        (Qty::Mass(x), "gram") => x.to_gram(),
        (Qty::Mass(x), "lb") => x.to_lb(),
        (Qty::Mass(x), "oz") => x.to_oz(),
        (Qty::Distance(x), "meters") => x.to_meters(),
        (Qty::Distance(x), "km") => x.to_km(),
        (Qty::Distance(x), "mile") => x.to_mile(),
        (Qty::Distance(x), "feet") => x.to_feet(),
        (Qty::Distance(x), "inch") => x.to_inch(),
        (Qty::Distance(x), "mm") => x.to_mm(),
        (Qty::Pressure(x), "kpa") => x.to_kpa(),
        (Qty::Pressure(x), "bar") => x.to_bar(),
        (Qty::Pressure(x), "psi") => x.to_psi(),
        (Qty::Power(x), "kw") => x.to_kw(),
        (Qty::Power(x), "ps") => x.to_ps(),
        (Qty::Power(x), "hp") => x.to_hp(),
        (Qty::Torque(x), "nm") => x.to_nm(),
        (Qty::Torque(x), "kgfm") => x.to_kgfm(),
        (Qty::Torque(x), "lbft") => x.to_lbft(),
        (Qty::Angle(x), "radians") => x.to_radians(),
        (Qty::Angle(x), "degrees") => x.to_degrees(),
        (Qty::Efficiency(x), "kml") => x.to_kml(),
        (Qty::Efficiency(x), "l100km") => x.to_l100km(),
        (Qty::Efficiency(x), "mpg") => x.to_mpg(),
        (Qty::EvEfficiency(x), "km_per_kwh") => x.to_km_per_kwh(),
        (Qty::EvEfficiency(x), "wh_per_km") => x.to_wh_per_km(),
        (Qty::EvEfficiency(x), "kwh_per_100km") => x.to_kwh_per_100km(),
        (Qty::EvEfficiency(x), "miles_per_kwh") => x.to_miles_per_kwh(),
        (Qty::Volume(x), "liters") => x.to_liters(),
        (Qty::Volume(x), "ml") => x.to_ml(),
        (Qty::Volume(x), "us_gallons") => x.to_us_gallons(),
        (Qty::Volume(x), "imp_gallons") => x.to_imp_gallons(),
        (Qty::Time(x), "seconds") => x.to_seconds(),
        (Qty::Time(x), "minutes") => x.to_minutes(),
        (Qty::Time(x), "hours") => x.to_hours(),
        (Qty::Acceleration(x), "ms2") => x.to_ms2(),
        (Qty::Scalar(x), _) => *x,
        _ => panic!("read: mismatched quantity/unit {unit}"),
    }
}

fn apply_op(case: &Value) -> Qty {
    let op = case["op"].as_str().unwrap();
    let lhs = construct(&case["lhs"]);
    match op {
        "mul_scalar" | "div_scalar" => {
            let s = parse_value(&case["rhs"]);
            macro_rules! scalar_op {
                ($v:expr, $variant:path) => {
                    if op == "mul_scalar" {
                        $variant($v * s)
                    } else {
                        $variant($v / s)
                    }
                };
            }
            return match lhs {
                Qty::Speed(x) => scalar_op!(x, Qty::Speed),
                // The Rust implementation (like the others) defines no
                // scalar multiplication/division for Temperature.
                Qty::Temperature(_) => panic!("scalar op on Temperature is unsupported"),
                Qty::Mass(x) => scalar_op!(x, Qty::Mass),
                Qty::Distance(x) => scalar_op!(x, Qty::Distance),
                Qty::Pressure(x) => scalar_op!(x, Qty::Pressure),
                Qty::Power(x) => scalar_op!(x, Qty::Power),
                Qty::Torque(x) => scalar_op!(x, Qty::Torque),
                Qty::Angle(x) => scalar_op!(x, Qty::Angle),
                Qty::Efficiency(x) => scalar_op!(x, Qty::Efficiency),
                Qty::EvEfficiency(x) => scalar_op!(x, Qty::EvEfficiency),
                Qty::Volume(x) => scalar_op!(x, Qty::Volume),
                Qty::Time(x) => scalar_op!(x, Qty::Time),
                Qty::Acceleration(x) => scalar_op!(x, Qty::Acceleration),
                Qty::Scalar(x) => Qty::Scalar(if op == "mul_scalar" { x * s } else { x / s }),
            };
        }
        _ => {}
    }
    let rhs = construct(&case["rhs"]);
    macro_rules! same_type {
        ($variant:path, $a:expr, $b:expr) => {
            if op == "add" {
                $variant($a + $b)
            } else {
                $variant($a - $b)
            }
        };
    }
    match (op, lhs, rhs) {
        ("add" | "sub", Qty::Speed(a), Qty::Speed(b)) => same_type!(Qty::Speed, a, b),
        ("add" | "sub", Qty::Temperature(a), Qty::Temperature(b)) => {
            same_type!(Qty::Temperature, a, b)
        }
        ("add" | "sub", Qty::Mass(a), Qty::Mass(b)) => same_type!(Qty::Mass, a, b),
        ("add" | "sub", Qty::Distance(a), Qty::Distance(b)) => same_type!(Qty::Distance, a, b),
        ("add" | "sub", Qty::Pressure(a), Qty::Pressure(b)) => same_type!(Qty::Pressure, a, b),
        ("add" | "sub", Qty::Power(a), Qty::Power(b)) => same_type!(Qty::Power, a, b),
        ("add" | "sub", Qty::Torque(a), Qty::Torque(b)) => same_type!(Qty::Torque, a, b),
        ("add" | "sub", Qty::Angle(a), Qty::Angle(b)) => same_type!(Qty::Angle, a, b),
        ("add" | "sub", Qty::Volume(a), Qty::Volume(b)) => same_type!(Qty::Volume, a, b),
        ("add" | "sub", Qty::Time(a), Qty::Time(b)) => same_type!(Qty::Time, a, b),
        ("add" | "sub", Qty::Acceleration(a), Qty::Acceleration(b)) => {
            same_type!(Qty::Acceleration, a, b)
        }
        ("mul", Qty::Speed(a), Qty::Time(b)) => Qty::Distance(a * b),
        ("mul", Qty::Time(a), Qty::Speed(b)) => Qty::Distance(a * b),
        ("mul", Qty::Acceleration(a), Qty::Time(b)) => Qty::Speed(a * b),
        ("mul", Qty::Time(a), Qty::Acceleration(b)) => Qty::Speed(a * b),
        ("div", Qty::Distance(a), Qty::Time(b)) => Qty::Speed(a / b),
        ("div", Qty::Speed(a), Qty::Time(b)) => Qty::Acceleration(a / b),
        ("div", Qty::Distance(a), Qty::Speed(b)) => Qty::Time(a / b),
        ("div", Qty::Speed(a), Qty::Acceleration(b)) => Qty::Time(a / b),
        ("div", Qty::Distance(a), Qty::Distance(b)) => Qty::Scalar(a / b),
        ("div", Qty::Speed(a), Qty::Speed(b)) => Qty::Scalar(a / b),
        ("div", Qty::Time(a), Qty::Time(b)) => Qty::Scalar(a / b),
        ("div", Qty::Volume(a), Qty::Volume(b)) => Qty::Scalar(a / b),
        ("div", Qty::Acceleration(a), Qty::Acceleration(b)) => Qty::Scalar(a / b),
        ("div", Qty::Efficiency(a), Qty::Efficiency(b)) => Qty::Scalar(a / b),
        ("div", Qty::EvEfficiency(a), Qty::EvEfficiency(b)) => Qty::Scalar(a / b),
        _ => panic!("unsupported op combination: {op}"),
    }
}

#[test]
fn golden_vectors() {
    // Keep expected-panic messages out of the test log.
    std::panic::set_hook(Box::new(|_| {}));
    let text = std::fs::read_to_string(find_vectors()).unwrap();
    let doc: Value = serde_json::from_str(&text).unwrap();
    let rel_tol = doc["rel_tol"].as_f64().unwrap_or(1e-9);
    let abs_tol = doc["abs_tol"].as_f64().unwrap_or(1e-12);
    let cases = doc["cases"].as_array().unwrap();
    let mut checked = 0usize;
    for (i, case) in cases.iter().enumerate() {
        let kind = case["kind"].as_str().unwrap();
        let label = format!("case {i}: {case}");
        match kind {
            "convert" => {
                let obj = construct(&serde_json::json!({
                    "quantity": case["quantity"],
                    "unit": case["from"],
                    "value": case["value"],
                }));
                let actual = read(&obj, case["to"].as_str().unwrap());
                let expected = case["expected"].as_f64().unwrap();
                let tol = abs_tol + rel_tol * expected.abs();
                assert!(
                    actual.is_finite() && (actual - expected).abs() <= tol,
                    "{label}: got {actual}, expected {expected} (tol {tol})"
                );
            }
            "error" => {
                let spec = serde_json::json!({
                    "quantity": case["quantity"],
                    "unit": case["from"],
                    "value": case["value"],
                });
                let r = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                    construct(&spec)
                }));
                assert!(r.is_err(), "{label}: expected an error but construction succeeded");
            }
            "op" => {
                if case.get("error").is_some() {
                    let r = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                        apply_op(case)
                    }));
                    assert!(r.is_err(), "{label}: expected an error but the op succeeded");
                } else {
                    let result = apply_op(case);
                    let actual = if case["expected_quantity"].as_str() == Some("scalar") {
                        read(&result, "")
                    } else {
                        read(&result, case["expected_unit"].as_str().unwrap())
                    };
                    let expected = case["expected"].as_f64().unwrap();
                    let tol = abs_tol + rel_tol * expected.abs();
                    assert!(
                        actual.is_finite() && (actual - expected).abs() <= tol,
                        "{label}: got {actual}, expected {expected} (tol {tol})"
                    );
                }
            }
            _ => panic!("unknown kind {kind}"),
        }
        checked += 1;
    }
    assert_eq!(checked, cases.len());
    println!("conformance: all {checked} cases passed");
}
