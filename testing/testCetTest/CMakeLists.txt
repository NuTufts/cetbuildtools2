cmake_minimum_required(VERSION 3.3)
project(testCetTest)

# Mock find/inclusion of cetbuildtools2
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
include(CetCMakeSettings)
include(CetCompilerSettings)
include(CetTest)

# Always on smoke test
cet_test(dummy_test)

# Test Failure Cases, activated by CMake arguments
# 1. Unparsed arguments are errors
if(__CT_FAILURE_UNPARSED)
  cet_test(unparsedargsareerror BAD_ARG)
endif()
# 2. TEST_EXEC without HANDBUILT is error
if(__CT_FAILURE_TEST_EXEC_NO_HANDBUILT)
  cet_test(no_handbuilt TEST_EXEC /bin/bash)
endif()
# 3. Cannot specify any combinations of HANDBUILT PREBUILT or USE_CATCH_MAIN
if(__CT_FAILURE_EXECUTABLE_COMBINATION_HP)
  cet_test(no_combination HANDBUILT PREBUILT)
elseif(__CT_FAILURE_EXECUTABLE_COMBINATION_HU)
  cet_test(no_combination HANDBUILT USE_CATCH_MAIN)
elseif(__CT_FAILURE_EXECUTABLE_COMBINATION_PU)
  cet_test(no_combination PREBUILT USE_CATCH_MAIN)
endif()

