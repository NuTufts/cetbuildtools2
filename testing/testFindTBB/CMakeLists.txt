# - Basic project to test FindCppUnit
cmake_minimum_required(VERSION 3.0)
project(testCetBasicPlugin)

# Mock inclusion of cetbuildtools2)
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})

# Finding without REQUIRED is just a basic syntax test...
find_package(TBB)

if(TBB_FOUND)
  if(NOT TARGET TBB::tbb)
    message(FATAL_ERROR "TBB found, but no TBB::tbb target present")
  endif()

  # Try refinding with components
  find_package(TBB REQUIRED tbbmalloc tbbmalloc_proxy)
endif()

# This is purely for visual checking that
# - refind works
# - without additional reporting to screen
find_package(TBB QUIET)


