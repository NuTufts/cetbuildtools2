# - Basic project to test CetCMakeSettings
cmake_minimum_required(VERSION 3.0)
project(testCetConfigureCXXStandard)

# Mock inclusion of cetbuildtools2)
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})

include(CetCompilerSettings)
cet_configure_cxx_standard(11)

message(STATUS "CXX STANDARD = ${CET_COMPILER_CXX_STANDARD}")
