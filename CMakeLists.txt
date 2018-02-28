# - Top level CMake script for cetbuildtools2
#   Though a very simple project, it requires its own functionality
#   to install natively or using the CET/UPS policy
cmake_minimum_required(VERSION 3.0)
project(cetbuildtools2 VERSION 0.4.0)

# - Install policy
# Native only for now
include(GNUInstallDirs)
set(CMAKE_INSTALL_CMAKEDIR "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/cmake")

# - Documentation
add_subdirectory(documentation)

# - Testing
enable_testing()
add_subdirectory(testing)

# - Install CMake files/modules
# - Programs
install(DIRECTORY bin/
  DESTINATION "${CMAKE_INSTALL_BINDIR}"
  PATTERN "bin/*"
  PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
              GROUP_EXECUTE GROUP_READ
              WORLD_EXECUTE WORLD_READ
  )

# - Modules
install(DIRECTORY Modules
  DESTINATION "${CMAKE_INSTALL_CMAKEDIR}"
  PATTERN "Modules/cet_exec_test"
  PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
              GROUP_EXECUTE GROUP_READ
              WORLD_EXECUTE WORLD_READ
  PATTERN "Modules/filter-output"
  PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
              GROUP_EXECUTE GROUP_READ
              WORLD_EXECUTE WORLD_READ
  )

# - find_package support
include(CMakePackageConfigHelpers)

configure_package_config_file(
  ${PROJECT_NAME}Config.cmake.in
  ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  INSTALL_DESTINATION "${CMAKE_INSTALL_CMAKEDIR}"
  PATH_VARS CMAKE_INSTALL_CMAKEDIR
  )

write_basic_package_version_file(
  ${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
  )

install(
  FILES
    ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    ${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  DESTINATION
    "${CMAKE_INSTALL_CMAKEDIR}"
  )


