cmake_minimum_required(VERSION 3.3)
project(testCetScript)

# Mock find/inclusion of cetbuildtools2
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
include(CetCMakeSettings)
include(CetCompilerSettings)
include(CetTest)

# As a handbuilt script
cet_test(hello HANDBUILT TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/hello-world.sh)

# As a PREBUILT
cet_test(hello-world.sh PREBUILT)
