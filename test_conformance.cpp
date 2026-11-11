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

// Conformance test: run the shared golden vectors (test_vectors.json
// at the repository root) against the C++ implementation.
//
// Every language implementation runs the same vectors; a failure here
// means this implementation disagrees with the shared specification.
// Regenerate vectors with tools/generate_test_vectors.py.

#include <cmath>
#include <cctype>
#include <cstdlib>
#include <fstream>
#include <numeric>
#include <sstream>
#include <stdexcept>
#include <string>
#include <variant>
#include <vector>

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include "unit_conversion.hpp"

using json = nlohmann::json;

using AnyQty = std::variant<Speed, Temperature, Mass, Distance, Pressure,
                            Power, Torque, Angle, Efficiency, EvEfficiency,
                            Volume, Time, Acceleration, double>;

static std::string findVectors() {
    if (const char* env = std::getenv("UNIT_CONVERSION_TEST_VECTORS")) {
        return env;
    }
#ifdef TEST_VECTORS_PATH
    return TEST_VECTORS_PATH;
#else
    return "test_vectors.json";
#endif
}

static double parseValue(const json& v) {
    if (v.is_string()) {
        const std::string s = v.get<std::string>();
        if (s == "NaN") return std::nan("");
        if (s == "Infinity") return HUGE_VAL;
        if (s == "-Infinity") return -HUGE_VAL;
        throw std::runtime_error("bad value token " + s);
    }
    return v.get<double>();
}

static AnyQty construct(const std::string& q, const std::string& u, double v) {
    if (q == "Speed") {
        if (u == "ms") return Speed::fromMs(v);
        if (u == "kmh") return Speed::fromKmH(v);
        if (u == "mph") return Speed::fromMph(v);
    } else if (q == "Temperature") {
        if (u == "celsius") return Temperature::fromCelsius(v);
        if (u == "fahrenheit") return Temperature::fromFahrenheit(v);
        if (u == "kelvin") return Temperature::fromKelvin(v);
    } else if (q == "Mass") {
        if (u == "kg") return Mass::fromKg(v);
        if (u == "gram") return Mass::fromGram(v);
        if (u == "lb") return Mass::fromLb(v);
        if (u == "oz") return Mass::fromOz(v);
    } else if (q == "Distance") {
        if (u == "meters") return Distance::fromMeters(v);
        if (u == "km") return Distance::fromKm(v);
        if (u == "mile") return Distance::fromMile(v);
        if (u == "feet") return Distance::fromFeet(v);
        if (u == "inch") return Distance::fromInch(v);
        if (u == "mm") return Distance::fromMm(v);
    } else if (q == "Pressure") {
        if (u == "kpa") return Pressure::fromKpa(v);
        if (u == "bar") return Pressure::fromBar(v);
        if (u == "psi") return Pressure::fromPsi(v);
    } else if (q == "Power") {
        if (u == "kw") return Power::fromKw(v);
        if (u == "ps") return Power::fromPs(v);
        if (u == "hp") return Power::fromHp(v);
    } else if (q == "Torque") {
        if (u == "nm") return Torque::fromNm(v);
        if (u == "kgfm") return Torque::fromKgfm(v);
        if (u == "lbft") return Torque::fromLbft(v);
    } else if (q == "Angle") {
        if (u == "radians") return Angle::fromRadians(v);
        if (u == "degrees") return Angle::fromDegrees(v);
    } else if (q == "Efficiency") {
        if (u == "kml") return Efficiency::fromKml(v);
        if (u == "l100km") return Efficiency::fromL100km(v);
        if (u == "mpg") return Efficiency::fromMpg(v);
    } else if (q == "EvEfficiency") {
        if (u == "km_per_kwh") return EvEfficiency::fromKmkWh(v);
        if (u == "wh_per_km") return EvEfficiency::fromWhkm(v);
        if (u == "kwh_per_100km") return EvEfficiency::fromKwh100km(v);
        if (u == "miles_per_kwh") return EvEfficiency::fromMpKwh(v);
    } else if (q == "Volume") {
        if (u == "liters") return Volume::fromLiters(v);
        if (u == "ml") return Volume::fromMl(v);
        if (u == "us_gallons") return Volume::fromUsGallons(v);
        if (u == "imp_gallons") return Volume::fromImpGallons(v);
    } else if (q == "Time") {
        if (u == "seconds") return Time::fromSeconds(v);
        if (u == "minutes") return Time::fromMinutes(v);
        if (u == "hours") return Time::fromHours(v);
    } else if (q == "Acceleration") {
        if (u == "ms2") return Acceleration::fromMs2(v);
    }
    throw std::runtime_error("unknown quantity/unit " + q + "/" + u);
}

static AnyQty construct(const json& spec) {
    return construct(spec["quantity"].get<std::string>(),
                     spec["unit"].get<std::string>(),
                     parseValue(spec["value"]));
}

static double readOne(const Speed& x, const std::string& u) {
    if (u == "ms") return x.toMs();
    if (u == "kmh") return x.toKmH();
    if (u == "mph") return x.toMph();
    throw std::runtime_error("bad Speed unit " + u);
}
static double readOne(const Temperature& x, const std::string& u) {
    if (u == "celsius") return x.toCelsius();
    if (u == "fahrenheit") return x.toFahrenheit();
    if (u == "kelvin") return x.toKelvin();
    throw std::runtime_error("bad Temperature unit " + u);
}
static double readOne(const Mass& x, const std::string& u) {
    if (u == "kg") return x.toKg();
    if (u == "gram") return x.toGram();
    if (u == "lb") return x.toLb();
    if (u == "oz") return x.toOz();
    throw std::runtime_error("bad Mass unit " + u);
}
static double readOne(const Distance& x, const std::string& u) {
    if (u == "meters") return x.toMeters();
    if (u == "km") return x.toKm();
    if (u == "mile") return x.toMile();
    if (u == "feet") return x.toFeet();
    if (u == "inch") return x.toInch();
    if (u == "mm") return x.toMm();
    throw std::runtime_error("bad Distance unit " + u);
}
static double readOne(const Pressure& x, const std::string& u) {
    if (u == "kpa") return x.toKpa();
    if (u == "bar") return x.toBar();
    if (u == "psi") return x.toPsi();
    throw std::runtime_error("bad Pressure unit " + u);
}
static double readOne(const Power& x, const std::string& u) {
    if (u == "kw") return x.toKw();
    if (u == "ps") return x.toPs();
    if (u == "hp") return x.toHp();
    throw std::runtime_error("bad Power unit " + u);
}
static double readOne(const Torque& x, const std::string& u) {
    if (u == "nm") return x.toNm();
    if (u == "kgfm") return x.toKgfm();
    if (u == "lbft") return x.toLbft();
    throw std::runtime_error("bad Torque unit " + u);
}
static double readOne(const Angle& x, const std::string& u) {
    if (u == "radians") return x.toRadians();
    if (u == "degrees") return x.toDegrees();
    throw std::runtime_error("bad Angle unit " + u);
}
static double readOne(const Efficiency& x, const std::string& u) {
    if (u == "kml") return x.toKml();
    if (u == "l100km") return x.toL100km();
    if (u == "mpg") return x.toMpg();
    throw std::runtime_error("bad Efficiency unit " + u);
}
static double readOne(const EvEfficiency& x, const std::string& u) {
    if (u == "km_per_kwh") return x.toKmkWh();
    if (u == "wh_per_km") return x.toWhkm();
    if (u == "kwh_per_100km") return x.toKwh100km();
    if (u == "miles_per_kwh") return x.toMpKwh();
    throw std::runtime_error("bad EvEfficiency unit " + u);
}
static double readOne(const Volume& x, const std::string& u) {
    if (u == "liters") return x.toLiters();
    if (u == "ml") return x.toMl();
    if (u == "us_gallons") return x.toUsGallons();
    if (u == "imp_gallons") return x.toImpGallons();
    throw std::runtime_error("bad Volume unit " + u);
}
static double readOne(const Time& x, const std::string& u) {
    if (u == "seconds") return x.toSeconds();
    if (u == "minutes") return x.toMinutes();
    if (u == "hours") return x.toHours();
    throw std::runtime_error("bad Time unit " + u);
}
static double readOne(const Acceleration& x, const std::string& u) {
    if (u == "ms2") return x.toMs2();
    throw std::runtime_error("bad Acceleration unit " + u);
}
static double readOne(double x, const std::string&) { return x; }

static double readValue(const AnyQty& q, const std::string& unit) {
    return std::visit([&](const auto& x) { return readOne(x, unit); }, q);
}

static AnyQty applyOp(const json& c) {
    const std::string op = c["op"].get<std::string>();
    AnyQty lhs = construct(c["lhs"]);
    if (op == "mul_scalar" || op == "div_scalar") {
        const double s = parseValue(c["rhs"]);
        return std::visit(
            [&](const auto& x) -> AnyQty {
                using T = std::decay_t<decltype(x)>;
                if constexpr (std::is_same_v<T, double>) {
                    return op == "mul_scalar" ? x * s : x / s;
                } else if constexpr (requires { x * s; x / s; }) {
                    return op == "mul_scalar" ? x * s : x / s;
                } else {
                    // e.g. Temperature defines no scalar operators.
                    throw std::runtime_error("scalar op unsupported for this type");
                }
            },
            lhs);
    }
    AnyQty rhs = construct(c["rhs"]);
    if (op == "add" || op == "sub") {
        return std::visit(
            [&](const auto& a, const auto& b) -> AnyQty {
                using A = std::decay_t<decltype(a)>;
                using B = std::decay_t<decltype(b)>;
                if constexpr (std::is_same_v<A, B> && !std::is_same_v<A, double> &&
                              requires { a + b; a - b; }) {
                    return op == "add" ? a + b : a - b;
                } else {
                    throw std::runtime_error("add/sub on mismatched types");
                }
            },
            lhs, rhs);
    }
    if (op == "mul") {
        if (auto a = std::get_if<Speed>(&lhs)) {
            if (auto b = std::get_if<Time>(&rhs)) return *a * *b;
        }
        if (auto a = std::get_if<Time>(&lhs)) {
            if (auto b = std::get_if<Speed>(&rhs)) return *a * *b;
        }
        if (auto a = std::get_if<Acceleration>(&lhs)) {
            if (auto b = std::get_if<Time>(&rhs)) return *a * *b;
        }
        throw std::runtime_error("unsupported mul combination");
    }
    if (op == "div") {
        if (auto a = std::get_if<Distance>(&lhs)) {
            if (auto b = std::get_if<Time>(&rhs)) return *a / *b;
            if (auto b = std::get_if<Speed>(&rhs)) return *a / *b;
            if (auto b = std::get_if<Distance>(&rhs)) return *a / *b;
        }
        if (auto a = std::get_if<Speed>(&lhs)) {
            if (auto b = std::get_if<Time>(&rhs)) return *a / *b;
            if (auto b = std::get_if<Acceleration>(&rhs)) return *a / *b;
            if (auto b = std::get_if<Speed>(&rhs)) return *a / *b;
        }
        if (auto a = std::get_if<Time>(&lhs)) {
            if (auto b = std::get_if<Time>(&rhs)) return *a / *b;
        }
        if (auto a = std::get_if<Volume>(&lhs)) {
            if (auto b = std::get_if<Volume>(&rhs)) return *a / *b;
        }
        throw std::runtime_error("unsupported div combination");
    }
    throw std::runtime_error("unknown op " + op);
}

// ---------------------------------------------------------------------------
// One GoogleTest test per vector case (parameterized), so a failure names
// exactly the case that broke and each case can be re-run on its own with
// --gtest_filter, e.g.:
//   ./build/conformance_tests --gtest_filter='*convert_Speed_kmh*'
// Test names look like:
//   GoldenVectors/ConformanceParamTest.Case/convert_012_Speed_kmh_to_mph
//   GoldenVectors/ConformanceParamTest.Case/error_253_Speed_ms_non_negative
//   GoldenVectors/ConformanceParamTest.Case/op_262_mul_Speed_Time
// ---------------------------------------------------------------------------

static const json& vectorDoc() {
    static const json doc = [] {
        std::ifstream in(findVectors());
        if (!in.good()) return json(nullptr);
        std::stringstream ss;
        ss << in.rdbuf();
        return json::parse(ss.str());
    }();
    return doc;
}

static std::string sanitize(const std::string& s) {
    std::string out = s;
    for (char& ch : out) {
        if (!std::isalnum(static_cast<unsigned char>(ch))) ch = '_';
    }
    return out;
}

static std::string caseName(int index) {
    const json& c = vectorDoc()["cases"].at(index);
    const std::string kind = c.value("kind", "");
    std::string name = kind + "_" + std::to_string(index);
    if (kind == "convert") {
        name += "_" + sanitize(c.value("quantity", "")) + "_" +
                sanitize(c.value("from", "")) + "_to_" + sanitize(c.value("to", ""));
    } else if (kind == "error") {
        name += "_" + sanitize(c.value("quantity", "")) + "_" +
                sanitize(c.value("from", "")) + "_" + sanitize(c.value("error", ""));
    } else if (kind == "op") {
        name += "_" + sanitize(c.value("op", ""));
        if (c["lhs"].is_object()) name += "_" + sanitize(c["lhs"].value("quantity", ""));
        if (c["rhs"].is_object()) name += "_" + sanitize(c["rhs"].value("quantity", ""));
    }
    return name;
}

static std::vector<int> caseIndices() {
    const json& doc = vectorDoc();
    std::vector<int> idx;
    if (doc.is_object() && doc.contains("cases")) {
        idx.resize(doc["cases"].size());
        std::iota(idx.begin(), idx.end(), 0);
    }
    return idx;
}

class ConformanceParamTest : public testing::TestWithParam<int> {};

TEST_P(ConformanceParamTest, Case) {
    const int index = GetParam();
    const json& doc = vectorDoc();
    ASSERT_TRUE(doc.is_object()) << "cannot open/parse test_vectors.json";
    const json& c = doc["cases"].at(index);
    const double relTol = doc.value("rel_tol", 1e-9);
    const double absTol = doc.value("abs_tol", 1e-12);
    const std::string kind = c["kind"].get<std::string>();
    const std::string label = "case " + std::to_string(index) + ": " + c.dump();
    if (kind == "convert") {
        AnyQty obj = construct(c["quantity"].get<std::string>(),
                               c["from"].get<std::string>(),
                               parseValue(c["value"]));
        const double actual = readValue(obj, c["to"].get<std::string>());
        const double expected = c["expected"].get<double>();
        const double tol = absTol + relTol * std::abs(expected);
        EXPECT_TRUE(std::isfinite(actual) && std::abs(actual - expected) <= tol)
            << label << " got " << actual << " expected " << expected;
    } else if (kind == "error") {
        EXPECT_THROW(
            construct(c["quantity"].get<std::string>(),
                      c["from"].get<std::string>(), parseValue(c["value"])),
            std::exception)
            << label;
    } else if (kind == "op") {
        if (c.contains("error")) {
            EXPECT_THROW(applyOp(c), std::exception) << label;
        } else {
            AnyQty result = applyOp(c);
            const double actual =
                c["expected_quantity"].get<std::string>() == "scalar"
                    ? readValue(result, "")
                    : readValue(result, c["expected_unit"].get<std::string>());
            const double expected = c["expected"].get<double>();
            const double tol = absTol + relTol * std::abs(expected);
            EXPECT_TRUE(std::isfinite(actual) && std::abs(actual - expected) <= tol)
                << label << " got " << actual << " expected " << expected;
        }
    } else {
        FAIL() << "unknown kind " << kind;
    }
}

INSTANTIATE_TEST_SUITE_P(GoldenVectors, ConformanceParamTest,
                         testing::ValuesIn(caseIndices()),
                         [](const testing::TestParamInfo<int>& info) {
                             return caseName(info.param);
                         });

// Guard: the vector file itself must be present and parseable. Without
// this, a missing file would silently instantiate zero parameterized
// tests above and the run would look green.
TEST(ConformanceFile, LoadsAndIsNotEmpty) {
    const json& doc = vectorDoc();
    ASSERT_TRUE(doc.is_object()) << "cannot open/parse test_vectors.json";
    ASSERT_TRUE(doc.contains("cases"));
    EXPECT_GT(static_cast<int>(doc["cases"].size()), 0)
        << "test_vectors.json contains no cases";
}
