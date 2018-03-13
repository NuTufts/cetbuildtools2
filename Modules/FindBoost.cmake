#.rst:
# FindBoost
# ---------
#
# Find Boost include dirs and libraries
#
# This module reuses the core :cmake:module:`FindBoost module <cmake:module:FindBoost>`
# for primary Boost location functionality and you should consult :cmake:module:`its documentation <cmake:module:FindBoost>`
# for details of its main options, arguments and set variables and created imported targets.
# This module does not change nor add to this interface.
#
# After using :cmake:module:`FindBoost <cmake:module:FindBoost>` to locate Boost, this
# module creates imported targets for the Boost libraries if they do not exist. This
# works around an issue in CMake versions < 3.11 where the targets are not created
# if the found Boost version is not known to CMake. This was done to ensure link
# dependencies between the Boost librarties are declared correctly, but prevented
# easy use of new Boost versions before CMake itself was updated.
#
# Following the pattern adopted in CMake 3.11, this module creates the imported targets
# for all versions of Boost when the client is running CMake < 3.11. Link dependencies
# between Boost libraries are not declared, leaving it up to the client to link their
# targets to all needed Boost targets. CET projects generally fully declare link interfaces,
# so it is not expected this will cause an issue.
#

# Reproduce fundamental find of Boost
include(${CMAKE_ROOT}/Modules/FindBoost.cmake)

# Create binary imported targets if required
if(Boost_FOUND AND (CMAKE_VERSION VERSION_LESS "3.11") AND (NOT _Boost_IMPORTED_TARGETS))
  # Find boost will already have created Boost::boost for us.
  foreach(COMPONENT ${Boost_FIND_COMPONENTS})
    if(NOT TARGET Boost::${COMPONENT})
      string(TOUPPER ${COMPONENT} UPPERCOMPONENT)
      if(Boost_${UPPERCOMPONENT}_FOUND)
        if(Boost_USE_STATIC_LIBS)
          add_library(Boost::${COMPONENT} STATIC IMPORTED)
        else()
          # Even if Boost_USE_STATIC_LIBS is OFF, we might have static
          # libraries as a result.
          add_library(Boost::${COMPONENT} UNKNOWN IMPORTED)
        endif()
        if(Boost_INCLUDE_DIRS)
          set_target_properties(Boost::${COMPONENT} PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}")
        endif()
        if(EXISTS "${Boost_${UPPERCOMPONENT}_LIBRARY}")
          set_target_properties(Boost::${COMPONENT} PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
            IMPORTED_LOCATION "${Boost_${UPPERCOMPONENT}_LIBRARY}")
        endif()
        if(EXISTS "${Boost_${UPPERCOMPONENT}_LIBRARY_RELEASE}")
          set_property(TARGET Boost::${COMPONENT} APPEND PROPERTY
            IMPORTED_CONFIGURATIONS RELEASE)
          set_target_properties(Boost::${COMPONENT} PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
            IMPORTED_LOCATION_RELEASE "${Boost_${UPPERCOMPONENT}_LIBRARY_RELEASE}")
        endif()
        if(EXISTS "${Boost_${UPPERCOMPONENT}_LIBRARY_DEBUG}")
          set_property(TARGET Boost::${COMPONENT} APPEND PROPERTY
            IMPORTED_CONFIGURATIONS DEBUG)
          set_target_properties(Boost::${COMPONENT} PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
            IMPORTED_LOCATION_DEBUG "${Boost_${UPPERCOMPONENT}_LIBRARY_DEBUG}")
        endif()
        if(_Boost_${UPPERCOMPONENT}_DEPENDENCIES)
          unset(_Boost_${UPPERCOMPONENT}_TARGET_DEPENDENCIES)
          foreach(dep ${_Boost_${UPPERCOMPONENT}_DEPENDENCIES})
            list(APPEND _Boost_${UPPERCOMPONENT}_TARGET_DEPENDENCIES Boost::${dep})
          endforeach()
          if(COMPONENT STREQUAL "thread")
            list(APPEND _Boost_${UPPERCOMPONENT}_TARGET_DEPENDENCIES Threads::Threads)
          endif()
          set_target_properties(Boost::${COMPONENT} PROPERTIES
            INTERFACE_LINK_LIBRARIES "${_Boost_${UPPERCOMPONENT}_TARGET_DEPENDENCIES}")
        endif()
        if(_Boost_${UPPERCOMPONENT}_COMPILER_FEATURES)
          set_target_properties(Boost::${COMPONENT} PROPERTIES
            INTERFACE_COMPILE_FEATURES "${_Boost_${UPPERCOMPONENT}_COMPILER_FEATURES}")
        endif()
      endif()
    endif()
  endforeach()
endif()

