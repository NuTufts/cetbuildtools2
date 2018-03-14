#.rst:
# CetUPS
# ------
#
# Configure and develop project using settings obtained from CET's
# UPS configuration management tool. These settings override any set
# by the user and cannot be modified. The enforced settings include:
#
# - Installation locations
# - Build type
#
# In particular, multiconfig tools like Xcode cannot be used in
# UPS builds as UPS only understands single mode builds.
#
# UPS Project Files
# ^^^^^^^^^^^^^^^^^
#
# Projects capable of being built in UPS-mode must instrument their
# source directory with a `ups` directory holding a `product_deps`
# file and a `setup_for_development` script.
#
# UPS Setup for Development
# ^^^^^^^^^^^^^^^^^^^^^^^^^
#
# The following sequence of operations/scripts is performed (NB,
# may not be complete as yet)
#
# - It's assumed that the `ups` product is already setup
#
#   - Usually indicated by presence of `ups` program in ``PATH``
#     or setting of ``UPS_DIR`` environment variable
#
# - User creates build directory, and ``source`` s the ``ups/setup_for_development``
#   script for the project to be built, supplying the build type and
#   any further qualifiers
#
# - This script runs the ``set_dev_products`` program that reads the
#   ``ups/product_deps`` file and writes two files to the build directory:
#
#   - A shell script, "product_name-ups_version" to be sourced by ``setup_for_development`` that
#     setups needed products and sets further UPS/cetbuildtools specific
#     environment variables.
#   - A text file, "cetpkg_variable_support", that holds the UPS/cetbuildtools
#     variables as KEY VALUE pairs.
#
# - User runs CMake using the invocation ``cmake -DCMAKE_INSTALL_PREFIX=<path> -DCMAKE_BUILD_TYPE=$CETPKG_TYPE $CETPKG_SOURCE``
#   where the ``CETPKG_`` variables are those set in the environment by
#   the script.
#
#
# UPS Tools
# ^^^^^^^^^
#
# Several shell/perl scripts are installed by cetbuildtools2 that
# run setup, query the UPS system and generate install-time files
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

#.rst:
# upsify version
# convert, X.Y.Z - > vX_Y_Z
function(semantic_version_to_ups _sem_input _ups_output)
  set(${_ups_output} "${_sem_input}" PARENT_SCOPE)
endfunction()

# vX_Y_Z -> X.Y.Z
function(ups_version_to_semantic _ups_input _sem_output)
  set(${_sem_output} "${_ups_input}" PARENT_SCOPE)
endfunction()

# return the flavour
function(get_ups_flavor _output)
  # Mocked using CMake variables for now - to be properly translated
  set(${_output} "${CMAKE_SYSTEM_NAME}.${CMAKE_SYSTEM_VERSION}.${CMAKE_SYSTEM_PROCESSOR}" PARENT_SCOPE)
endfunction()

# return the primary and secondary qualifiers
# https://cdcvs.fnal.gov/redmine/projects/cet-is-public/wiki/AboutQualifiers
# e.g. e15 for gcc 6.X with c++14
function(get_ups_primary_qualifier _output)
  # Fundamentally, primary qualifier is a tag on C++ compiler id+version+cxxstd
  # 1. is empty if project doesn't use C++
  if(NOT CMAKE_CXX_COMPILER)
    set(${_output} "" PARENT_SCOPE)
    return()
  endif()

  # 2. is "UNKNOWN" (arbitrary tag for now) if C++ used, but
  #    combination unknown
  set(_pqualifier "UNKNOWN")

  # 3. Otherwise, follow table from above link
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # Only gcc 5 and better as these are the only
    # ones CBT2 needs to support
    set(_pqualifier "eX")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
    set(_pqualifier "e13")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    # Clang quals are odd because there's also a gfortran dependence
    set(_pqualifier "cX")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    set(_pqualifier "iX")
  endif()
  set(${_output} "${_pqual}" PARENT_SCOPE)
endfunction()

function(get_ups_secondary_qualifiers _output)
  # debug|opt|prof
  # map to the build mode we're in, so possibly won't work for multimode...
  set(${_output} "" PARENT_SCOPE)

  # Only other possibility is eth|ib, but not used
  # currently in cbt2 using projects (would need to
  # look at FindMPI module and its outputs to detect difference)
endfunction()
