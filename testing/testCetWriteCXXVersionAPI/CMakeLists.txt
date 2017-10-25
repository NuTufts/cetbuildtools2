cmake_minimum_required(VERSION 3.3)
project(testCetWriteCXXVersionAPI VERSION "1.2.3")

include(CetWriteCXXVersionAPI)
cet_write_cxx_version_api(NAMESPACE "foo::bar"
                          TYPENAME  "myversion")

# Header must exist
if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/myversion.h")
  message(FATAL_ERROR "testCetWriteCXXVersionAPI: No header file created")
endif()

# Must compile
add_executable(testCetWriteCXXVersionAPI testCetWriteCXXVersionAPI.cc myversion.h myversion.h.cc)
target_include_directories(testCetWriteCXXVersionAPI PRIVATE "${CMAKE_CURRENT_BINARY_DIR}")

# Must run
enable_testing()
add_test(NAME testCetWriteCXXVersionAPI_runtime COMMAND testCetWriteCXXVersionAPI)


