# - Basic project to test FindCppUnit
cmake_minimum_required(VERSION 3.0)
project(testCetBasicPlugin)

# Mock inclusion of cetbuildtools2)
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})

# Finding without REQUIRED is just a basic syntax test...
find_package(CppUnit)

if(CPPUNIT_FOUND)
  if(NOT TARGET CppUnit::CppUnit)
    message(FATAL_ERROR "CppUnit found, but no CppUnit::CppUnit target present")
  endif()
endif()

# This is purely for visual checking that
# - refind works
# - without additional reporting to screen
find_package(CppUnit QUIET)


