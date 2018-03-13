cmake_minimum_required(VERSION 3.3)
project(testUPSInstallDirs VERSION 1.2.3)
# Mock prefix path
set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/test-install")

# Mock find/inclusion of cetbuildtools2
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
include(CetCMakeSettings)
include(CetCompilerSettings)
include(CetTest)
include(CetInstallDirs)

# Create a library and program for installation
add_library(foo foo.h foo.cc)
add_executable(foo-main foo-main.cc)
target_link_libraries(foo-main PRIVATE foo)

# Install targets via the standard CMAKE_INSTALL_XXX vars
install(TARGETS foo foo-main
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
install(FILES foo.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/foo)
