# - Basic project to test CetCMakeSettings
cmake_minimum_required(VERSION 3.0)
project(testCetBasicPlugin)

# Mock inclusion of cetbuildtools2)
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})

include(BasicPlugin)

basic_plugin(foo bar)

