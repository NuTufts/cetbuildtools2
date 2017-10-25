# The MIT License (MIT)
#
# Copyright (c) 2015 Justus Calvin
# Modifications Copyright (c) 2017 Ben Morgan
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#.rst:
# FindTBB
# -------
#
# Find the TBB include directories and libraries.
#
# Use this module by invoking find_package with the form::
#
#   find_package(TBB
#     [version] [EXACT]      # Minimum or EXACT version, e.g 2017.7
#     [REQUIRED]             # Fail with error if TBB is not found
#     [COMPONENTS <libs>...] # Additional TBB libraries by their
#     )                      # name, e.g. "tbbmalloc" for "libtbbmalloc"
#
# Supported arguments to ``COMPONENTS`` are ``tbbmalloc``, ``tbbmalloc_proxy``
# and ``tbb_preview``.
#
# Imported Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following :cmake:prop_tgt:`IMPORTED` target if
# TBB has been found::
#
#  TBB::tbb - Target for main TBB library.
#  TBB::<C> - Target for TBB component ``<C>`` library, if requested in
#             ``COMPONENTS`` argument.
#
# Valid arguments to ``COMPONENTS`` are ``tbbmalloc``, ``tbbmalloc_proxy``
# and ``tbb_preview``.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module will set the following variables in your project::
#
#   TBB_FOUND               - True if TBB found.
#   TBB_INCLUDE_DIRS        - The include directory for TBB headers.
#   TBB_LIBRARIES           - The libraries to link against to use TBB.
#   TBB_LIBRARIES_RELEASE   - The release libraries to link against to use TBB.
#   TBB_LIBRARIES_DEBUG     - The debug libraries to link against to use TBB.
#                             TBB.
#   TBB_DEFINITIONS         - Definitions to use when compiling code that uses
#                             TBB
#   TBB_DEFINITIONS_RELEASE - Definitions to use when compiling code that uses
#                             the TBB release library.
#   TBB_DEFINITIONS_DEBUG   - Definitions to use when compiling code that uses
#                             the TBB debug library.
#   TBB_VERSION             - The full version string of the found TBB.
#   TBB_VERSION_MAJOR       - The major version
#   TBB_VERSION_MINOR       - The minor version
#   TBB_INTERFACE_VERSION   - The interface version number defined in
#                             tbb/tbb_stddef.h.
#   TBB_<C>_FOUND           - True if optional component <C> of TBB is found.
#   TBB_<C>_LIBRARY_RELEASE - The release library for component <C> TBB library.
#   TBB_<C>_LIBRARY_DEBUG   - The debug library for component <C> TBB library.
#
# Valid values for ``<C>`` are as described above for the Imported Targets.
#
# Hints
# ^^^^^
#
# A user may set the the CMake variable ``TBB_ROOT_DIR`` to a TBB installation
# root to tell this module where to look.
#
# A user may set the environment variables ``TBB_INSTALL_DIR`` or ``TBBROOT``
# to a TBB installation root to tell this module where to look.
#
# If a combination of these variables are set, they are used in the order
# of preference ``TBB_ROOT_DIR``, then ``TBB_INSTALL_DIR``, then ``TBBROOT``.
#

#-----------------------------------------------------------------------
# Macro to create imported targets for main TBB library and
# components
macro(_TBB_make_imported_target _target _component)
  if(NOT TARGET TBB::${_target})
    # TBB is generally (and recommended to be) a shared
    # library, so make this explicit for now. If Static
    # version need to be supported, mark lib as UNKNOWN
    # and set IMPORTED_LINK_INTERFACE_LANGUAGES as needed.
    add_library(TBB::${_target} SHARED IMPORTED)
    set_target_properties(TBB::${_target} PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${TBB_INCLUDE_DIRS}"
      )

    # See cmake-developer(7) for logic of selection/ordering
    if(TBB_${_component}LIBRARY_RELEASE)
      set_property(TARGET TBB::${_target} APPEND PROPERTY
        IMPORTED_CONFIGURATIONS RELEASE
        )
      set_target_properties(TBB::${_target} PROPERTIES
        IMPORTED_LOCATION_RELEASE "${TBB_${_component}LIBRARY_RELEASE}"
        )
    endif()
    if(TBB_${_component}LIBRARY_DEBUG)
      set_property(TARGET TBB::${_target} APPEND PROPERTY
        IMPORTED_CONFIGURATIONS DEBUG
        )
      set_target_properties(TBB::${_target} PROPERTIES
        INTERFACE_COMPILE_DEFINITIONS "$<$<CONFIG:Debug>:TBB_USE_DEBUG=1>"
        IMPORTED_LOCATION_DEBUG "${TBB_${_component}LIBRARY_DEBUG}"
        )
    endif()
    if(NOT TBB_${_component}LIBRARY_RELEASE AND NOT TBB_${_component}LIBRARY_DEBUG)
      # variable set directly
      set_target_properties(TBB::${_target} PROPERTIES
        IMPORTED_LOCATION "${TBB_${_component}LIBRARY}"
        )
    endif()
  endif()
endmacro()


##################################
# Set the TBB search directories
##################################
# Define search paths based on user input and environment variables
set(TBB_SEARCH_DIR ${TBB_ROOT_DIR} $ENV{TBB_INSTALL_DIR} $ENV{TBBROOT})

# Define the search directories based on the current platform
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  set(TBB_DEFAULT_SEARCH_DIR "C:/Program Files/Intel/TBB"
    "C:/Program Files (x86)/Intel/TBB")

  # Set the target architecture
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(TBB_ARCHITECTURE "intel64")
  else()
    set(TBB_ARCHITECTURE "ia32")
  endif()

  # Set the TBB search library path search suffix based on the version of VC
  if(WINDOWS_STORE)
    set(TBB_LIB_PATH_SUFFIX "lib/${TBB_ARCHITECTURE}/vc11_ui")
  elseif(MSVC14)
    set(TBB_LIB_PATH_SUFFIX "lib/${TBB_ARCHITECTURE}/vc14")
  elseif(MSVC12)
    set(TBB_LIB_PATH_SUFFIX "lib/${TBB_ARCHITECTURE}/vc12")
  elseif(MSVC11)
    set(TBB_LIB_PATH_SUFFIX "lib/${TBB_ARCHITECTURE}/vc11")
  elseif(MSVC10)
    set(TBB_LIB_PATH_SUFFIX "lib/${TBB_ARCHITECTURE}/vc10")
  endif()

  # Add the library path search suffix for the VC independent version of TBB
  list(APPEND TBB_LIB_PATH_SUFFIX "lib/${TBB_ARCHITECTURE}/vc_mt")

elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  # OS X
  set(TBB_DEFAULT_SEARCH_DIR "/opt/intel/tbb")

  # TODO: Check to see which C++ library is being used by the compiler.
  if(NOT ${CMAKE_SYSTEM_VERSION} VERSION_LESS 13.0)
    # The default C++ library on OS X 10.9 and later is libc++
    set(TBB_LIB_PATH_SUFFIX "lib/libc++" "lib")
  else()
    set(TBB_LIB_PATH_SUFFIX "lib")
  endif()
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  # Linux
  set(TBB_DEFAULT_SEARCH_DIR "/opt/intel/tbb")

  # TODO: Check compiler version to see the suffix should be <arch>/gcc4.1 or
  #       <arch>/gcc4.1. For now, assume that the compiler is more recent than
  #       gcc 4.4.x or later.
  if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(TBB_LIB_PATH_SUFFIX "lib/intel64/gcc4.4")
  elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^i.86$")
    set(TBB_LIB_PATH_SUFFIX "lib/ia32/gcc4.4")
  endif()
endif()

##################################
# Find the TBB include dir
##################################
find_path(TBB_INCLUDE_DIR tbb/tbb.h
  HINTS ${TBB_INCLUDE_DIR} ${TBB_SEARCH_DIR}
  PATHS ${TBB_DEFAULT_SEARCH_DIR}
  PATH_SUFFIXES include
  DOC "TBB include directory"
  )
mark_as_advanced(TBB_INCLUDE_DIR)

##################################
# Set version strings
##################################
if(TBB_INCLUDE_DIR)
  file(READ "${TBB_INCLUDE_DIR}/tbb/tbb_stddef.h" _tbb_version_file)
  string(REGEX REPLACE ".*#define TBB_VERSION_MAJOR ([0-9]+).*" "\\1"
    TBB_VERSION_MAJOR "${_tbb_version_file}")
  string(REGEX REPLACE ".*#define TBB_VERSION_MINOR ([0-9]+).*" "\\1"
    TBB_VERSION_MINOR "${_tbb_version_file}")
  string(REGEX REPLACE ".*#define TBB_INTERFACE_VERSION ([0-9]+).*" "\\1"
    TBB_INTERFACE_VERSION "${_tbb_version_file}")
  set(TBB_VERSION "${TBB_VERSION_MAJOR}.${TBB_VERSION_MINOR}")
endif()

########################################
# Find TBB library and requested components
##################################
if(NOT TBB_LIBRARY)
  find_library(TBB_LIBRARY_RELEASE
    NAMES tbb
    HINTS ${TBB_LIBRARY} ${TBB_SEARCH_DIR}
    PATHS ${TBB_DEFAULT_SEARCH_DIR} ENV LIBRARY_PATH
    PATH_SUFFIXES ${TBB_LIB_PATH_SUFFIX}
    DOC "TBB library (release)"
    )
  find_library(TBB_LIBRARY_DEBUG
    NAMES tbb_debug
    HINTS ${TBB_LIBRARY} ${TBB_SEARCH_DIR}
    PATHS ${TBB_DEFAULT_SEARCH_DIR} ENV LIBRARY_PATH
    PATH_SUFFIXES ${TBB_LIB_PATH_SUFFIX}
    DOC "TBB library (debug)"
    )
  mark_as_advanced(TBB_LIBRARY_RELEASE TBB_LIBRARY_DEBUG)
  include(SelectLibraryConfigurations)
  select_library_configurations(TBB)
endif()

#-----------------------------------------------------------------------
# Check/Search components as requested
if(TBB_VERSION VERSION_LESS 4.3)
  set(_TBB_KNOWN_COMPONENTS tbb_preview tbbmalloc)
else()
  set(_TBB_KNOWN_COMPONENTS tbb_preview tbbmalloc tbbmalloc_proxy)
endif()

foreach(_comp ${TBB_FIND_COMPONENTS})
  if(NOT TBB_${_comp}_LIBRARY)
    list(FIND _TBB_KNOWN_COMPONENTS ${_comp} _tbb_comp_index)
    if(_tbb_comp_index LESS 0)
      message(FATAL_ERROR "Find of TBB component '${_comp}' requested, but it is not a known component of TBB\n"
        "Known components of TBB: ${_TBB_KNOWN_COMPONENTS}"
        )
    endif()

    find_library(TBB_${_comp}_LIBRARY_RELEASE ${_comp}
      HINTS ${TBB_LIBRARY} ${TBB_SEARCH_DIR}
      PATHS ${TBB_DEFAULT_SEARCH_DIR} ENV LIBRARY_PATH
      PATH_SUFFIXES ${TBB_LIB_PATH_SUFFIX}
      DOC "TBB ${_comp} library (release)"
      )

    find_library(TBB_${_comp}_LIBRARY_DEBUG ${_comp}_debug
      HINTS ${TBB_LIBRARY} ${TBB_SEARCH_DIR}
      PATHS ${TBB_DEFAULT_SEARCH_DIR} ENV LIBRARY_PATH
      PATH_SUFFIXES ${TBB_LIB_PATH_SUFFIX}
      DOC "TBB ${_comp} library (debug)"
      )

    mark_as_advanced(TBB_${_comp}_LIBRARY_RELEASE TBB_${_comp}_LIBRARY_DEBUG)
    select_library_configurations(TBB_${_comp})
    if(TBB_${_comp}_LIBRARY)
      set(TBB_${_comp}_FOUND TRUE)
    endif()
  endif()
endforeach()

# Need compile definitions for release/debug modes
# Use "SelectLibraryConfigurations" logic to set a suitable TBB_DEFINITIONS?
# Difficult though because add_definitions doesn't support generator expressions!
# May just need to set TBB_DEFINITIONS appropriately and document multimode
# case
set(TBB_DEFINITIONS_RELEASE "")
set(TBB_DEFINITIONS_DEBUG "-DTBB_USE_DEBUG=1")

#-----------------------------------------------------------------------
# Handle the QUIETLY/REQUIRED arguments and set TBB_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TBB
  FOUND_VAR
    TBB_FOUND
  REQUIRED_VARS
    TBB_INCLUDE_DIR
    TBB_LIBRARY
  HANDLE_COMPONENTS
  VERSION_VAR
    TBB_VERSION
  )

if(TBB_FOUND)
  set(TBB_INCLUDE_DIRS "${TBB_INCLUDE_DIR}")
  set(TBB_LIBRARIES "${TBB_LIBRARIES}")

  # Add any requested components to LIBRARIES
  foreach(_comp ${TBB_FIND_COMPONENTS})
    if(TBB_${_comp}_FOUND)
      set(TBB_LIBRARIES "${TBB_LIBRARIES} ${TBB_${_comp}_LIBRARIES}")
    endif()
  endforeach()

  _TBB_make_imported_target(tbb "")
  foreach(_rcomp ${TBB_FIND_COMPONENTS})
    _TBB_make_imported_target(${_rcomp} "${_rcomp}_")
  endforeach()
endif()


unset(TBB_ARCHITECTURE)
unset(TBB_BUILD_TYPE)
unset(TBB_LIB_PATH_SUFFIX)
unset(TBB_DEFAULT_SEARCH_DIR)
