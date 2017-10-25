#.rst:
# CetCMakeSettings
# ----------------
#
# Set defaults for CMake build settings as useful or required for
# building CET projects. Where appropriate, these settings may be
# changed via command line arguments to cmake or through ccmake/cmake-gui
# interfaces.
#

#-----------------------------------------------------------------------
# Copyright 2016 Ben Morgan <Ben.Morgan@warwick.ac.uk>
# Copyright 2016 University of Warwick
#
# Distributed under the OSI-approved BSD 3-Clause License (the "License");
# see accompanying file LICENSE for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
#.rst:
# General Build Settings
# ^^^^^^^^^^^^^^^^^^^^^^
#
# The following CMake variables and options are configured by default
# when including this module:
#
# - ``CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE`` : ON
#
#   - Force project directories to appear first in any list of include paths.
#     This applies to both full paths and those created by generator expressions.
#
set(CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE ON)


# CET projects are (universally?) laid out so that the root source and
# build directories are equivalent to the root of the include
# directory.  If we want these to be in the build/install interfaces
# automatically, can use directory property as listed below to do this
# Could also provide a macro/function to add additional paths.
#
# - Set up so these are always added to the include directories
#   property in the build interface, and that they always appear first
#   to avoid clashes with any installed.
#   Could also set the install interface using CMAKE_INSTALL_INCLUDEDIR
#   though this would only account for a single use case (e.g. if
#   a library installed both arch independent AND dependent headers)
#   However, that's a special case and could be handled by additional
#   calls to target_include_directories. Advantage of setting
#   INSTALL_INTERFACE here is that it'll always appear FIRST in the
#   interface include dirs, so avoiding one source of clashes (if
#   INTERFACE_INCLUDE_DIRS has absolute paths relating to deps. may
#   be resolved by going to fully imported targets)

#set_directory_properties(PROPERTIES
#  INCLUDE_DIRECTORIES
#  "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR};${PROJECT_BINARY_DIR}>;$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
#    )

#.rst
# - ``CMAKE_LINK_DEPENDS_NO_SHARED`` : ON
#
#   - Do not relink a target to any shared library dependencies when
#     only the shared library implementation has changed.
#
set(CMAKE_LINK_DEPENDS_NO_SHARED ON)

#.rst:
# - ``CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION`` : ON
#
#   - CET policy is to install fully relocatable packages, so install
#     directories should never be absolute. NB: This does not guarantee
#     that a package *is* relocatable.
#
set(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION ON)

#.rst:
# - ``CMAKE_INSTALL_MESSAGE`` : ``LAZY``
#
#   - Only report new or updated files installed by the ``install`` target.
#
set(CMAKE_INSTALL_MESSAGE LAZY)

#.rst:
# - ``CMAKE_EXPORT_NO_PACKAGE_REGISTRY`` : ON
# - ``CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY`` : ON
# - ``CMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY`` : ON
#
#   - These variables are set to ensure that a project never creates or searches
#     for config files in any package registry. This prevents the
#     :cmake:command:`find_package <cmake:command:find_package>`
#     command from locating potentially spurious config files.
#
set(CMAKE_EXPORT_NO_PACKAGE_REGISTRY ON)
set(CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY ON)
set(CMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY ON)

#.rst:
#
# In addition to the base setting above, configurable options are provided for
# enabling/disabling extra targets and functionality:
#
# .. cmake:variable:: CET_BUILD_NO_UNINSTALL_TARGET
#
#   Option to disable creation of an ``uninstall`` target for the project.
#   ``OFF`` by default, and marked as advanced.
#
#   See the documentation of the ``CetUninstallTarget``
#   module for more details on what this target does.
#
option(CET_BUILD_NO_UNINSTALL_TARGET "Disable creation of an `uninstall` target" OFF)
mark_as_advanced(CET_BUILD_NO_UNINSTALL_TARGET)

if(NOT CET_BUILD_NO_UNINSTALL_TARGET)
  include("${CMAKE_CURRENT_LIST_DIR}/CetUninstallTarget.cmake")
endif()



#.rst:
# CTest/Testing Settings
# ^^^^^^^^^^^^^^^^^^^^^^
#
# .. cmake:variable:: BUILD_TESTING
#
#   Option to enable test infrastructure and settings, ``ON`` by default.
#   After inclusion of this module, use CMake conditionals on ``BUILD_TESTING`` like
#
#   .. code-block:: cmake
#
#     if(BUILD_TESTING)
#       # ... code to create/build/configure tests ...
#     endif()
#
#   to only build/define tests when the variable is set.
#
#   At present, enabling testing only supports direct testing rather than
#   use of the :cmake:module:`CTest <cmake:module:CTest>` module.
#
#   .. todo::
#
#     Add support for CTest. Should be matter of checking for
#     a `CTestConfig.cmake` file in the project source dir.
#

option(BUILD_TESTING "Enable and build tests for this project" ON)

if(BUILD_TESTING)
  enable_testing()
endif()

