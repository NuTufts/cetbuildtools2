# - Basic project to test CetCMakeSettings
cmake_minimum_required(VERSION 3.0)
project(testCetConfigureCXXStandard)

# Mock inclusion of cetbuildtools2)
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
include(CetCMakeSettings)
include(CetCompilerSettings)

add_executable(test-cxxstd test-cxxstd.cc)
add_test(NAME test-cxxstd COMMAND test-cxxstd)
set_tests_properties(test-cxxstd
  PROPERTIES PASS_REGULAR_EXPRESSION "${EXPECTED_CXX_STD}"
  )
