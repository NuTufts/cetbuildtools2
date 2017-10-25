#.rst:
# FindCppUnit
# -----------
#
# Find the native CppUnit includes and libraries
#
# Imported Targets
# ^^^^^^^^^^^^^^^^
#
# If CppUnit is found, this module defines the following :cmake:prop_tgt:`IMPORTED`
# targets::
#
#  CppUnit::CppUnit - The main CppUnit library
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module wil set the following variables in your project::
#
#  CPPUNIT_FOUND        - True if an install of SQLite is found
#  CPPUNIT_INCLUDE_DIRS - Location of SQLite header files
#  CPPUNIT_LIBRARIES    - The SQLite libraries
#
#

#=======================================================================
# Copyright (c) 2016, Ben Morgan <Ben.Morgan@warwick.ac.uk>
#
# Distributed under the OSI-approved BSD 3-Clause License (the "License");
# see accompanying file LICENSE for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=======================================================================

find_path(CPPUNIT_INCLUDE_DIR cppunit/Test.h)
find_library(CPPUNIT_LIBRARY NAMES cppunit)

# handle the QUIETLY and REQUIRED arguments and set ZLIB_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CPPUNIT REQUIRED_VARS CPPUNIT_LIBRARY CPPUNIT_INCLUDE_DIR)

if(CPPUNIT_FOUND)
  set(CPPUNIT_INCLUDE_DIRS ${CPPUNIT_INCLUDE_DIR})

  if(NOT CPPUNIT_LIBRARIES)
    set(CPPUNIT_LIBRARIES ${CPPUNIT_LIBRARY})
  endif()

  if(NOT TARGET CppUnit::CppUnit)
    add_library(CppUnit::CppUnit UNKNOWN IMPORTED)
    set_target_properties(CppUnit::CppUnit PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${CPPUNIT_INCLUDE_DIRS}"
      IMPORTED_LOCATION "${CPPUNIT_LIBRARY}"
      )
  endif()
endif()

