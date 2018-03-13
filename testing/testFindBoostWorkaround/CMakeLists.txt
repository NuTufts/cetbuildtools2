# - Basic project to test FindCppUnit
cmake_minimum_required(VERSION 3.0)
project(testFindBoostWorkaround)

# Mock inclusion of cetbuildtools2)
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})

# Find without REQUIRED as tests may not always run on machine with Boost
# Use Components that we know should have dependencies
find_package(Boost COMPONENTS filesystem)

if(Boost_FOUND)
  # Check linking a basic target
  add_executable(testBoostImportedTargets testBoostImportedTargets.cc)
  target_link_libraries(testBoostImportedTargets PRIVATE Boost::filesystem)
  add_test(NAME testBoostImportedTargets COMMAND testBoostImportedTargets)
else()
  message(WARNING "Boost not found, testFindBoostWorkaround not run...")
endif()


