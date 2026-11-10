cmake_minimum_required(VERSION 3.10)
project(unit_conversion)

set(CMAKE_CXX_STANDARD 20)

include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/heads/main.zip
)
FetchContent_MakeAvailable(googletest)

add_executable(unit_tests test_unit_conversion.cpp)
target_link_libraries(unit_tests gtest_main)

FetchContent_Declare(
  nlohmann_json
  URL https://github.com/nlohmann/json/releases/download/v3.11.3/json.tar.xz
)
FetchContent_MakeAvailable(nlohmann_json)

add_executable(conformance_tests test_conformance.cpp)
target_link_libraries(conformance_tests gtest_main nlohmann_json::nlohmann_json)
target_compile_definitions(conformance_tests PRIVATE
  TEST_VECTORS_PATH="${CMAKE_CURRENT_SOURCE_DIR}/test_vectors.json")

include(GoogleTest)
gtest_discover_tests(unit_tests)
gtest_discover_tests(conformance_tests)