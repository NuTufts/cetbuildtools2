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

  # Try refinding with components tbbmalloc should be available on
  # all current versions
  find_package(TBB REQUIRED tbbmalloc)
  # Test that target created
  if(NOT TARGET TBB::tbbmalloc)
    message(FATAL_ERROR "TBB found, but TBB::tbbmalloc target not present")
  endif()

  # Check linking a basic target
  add_executable(testFindTBB testFindTBB.cc)
  target_link_libraries(testFindTBB PRIVATE TBB::tbb)

  add_test(NAME testFindTBB COMMAND testFindTBB)
endif()

# This is purely for visual checking that
# - refind works
# - without additional reporting to screen
find_package(TBB QUIET)


