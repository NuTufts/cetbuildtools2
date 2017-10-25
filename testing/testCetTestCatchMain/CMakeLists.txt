cmake_minimum_required(VERSION 3.3)
project(testCetTestCatchMain)

# Mock find/inclusion of cetbuildtools2
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
include(CetCMakeSettings)
include(CetCompilerSettings)
include(CetTest)

# Catch test using CetTest's catch main
cet_test(a_catch_test USE_CATCH_MAIN)

# internal test - check that local catchmain target created
if(NOT TARGET testCetTestCatchMain_catch_main)
  message(FATAL_ERROR "Expected catch main target `testCetTestCatchMain_catch_main` does not exist")
endif()

# adding a second test should not be an error
cet_test(b_catch_test USE_CATCH_MAIN SOURCES a_catch_test.cc)


