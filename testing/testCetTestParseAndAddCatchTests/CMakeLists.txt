cmake_minimum_required(VERSION 3.3)
project(testCetTestCatchMain)

# Mock find/inclusion of cetbuildtools2
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
include(CetCMakeSettings)
include(CetCompilerSettings)
include(CetTest)

# Module should be in path
include(ParseAndAddCatchTests)

# Catch test
cet_test(a_catch_test USE_CATCH_MAIN NO_AUTO)
ParseAndAddCatchTests(a_catch_test)

# Check presence of expected tests
# Note need to escape due to naming convention of ParseAndAddCatchTests
# Need CMP0064...
cmake_policy(VERSION 3.4)
if(NOT TEST \"a_catch_test:First\")
  message(FATAL_ERROR "No test named \"\"a_catch_test:First\"\" defined")
endif()

if(NOT TEST \"a_catch_test:Second\ Test\")
  message(FATAL_ERROR "No test named \"\"a_catch_test:Second Test\"\" defined")
endif()

