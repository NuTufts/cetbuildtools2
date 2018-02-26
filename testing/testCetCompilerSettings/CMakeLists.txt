# - Basic project to test CetCompilerSettings
cmake_minimum_required(VERSION 3.0)
project(testCetCompilerSettings)

# Mock inclusion of cetbuildtools2)
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
include(CetCMakeSettings)
include(CetCompilerSettings)

add_executable(smoke smoke.cc)
add_test(NAME smoke COMMAND smoke)
