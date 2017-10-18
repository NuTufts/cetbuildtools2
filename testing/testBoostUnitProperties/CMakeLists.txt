# - Basic project to test CetCMakeSettings
cmake_minimum_required(VERSION 3.0)
project(testBoostUnitProperties)

# Mock inclusion of cetbuildtools2)
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
include(CetTest)

if(NOT TEST_FAILCASE)
find_package(Boost REQUIRED unit_test_framework)
endif()

# Handbuilt...
add_executable(foo_handbuilt foo_cet.cc)
set_boost_unit_properties(foo_handbuilt)
add_test(NAME foo_handbuilt COMMAND foo_handbuilt)

# Use in cet_test
cet_test(foo_cet USE_BOOST_UNIT)


