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

include(GoogleTest)
gtest_discover_tests(unit_tests)