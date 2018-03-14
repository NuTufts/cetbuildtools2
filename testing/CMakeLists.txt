# - Create/add tests for cetbuildtools2

# Sanity
add_test(NAME sanity COMMAND ${CMAKE_COMMAND} --version)

# Utilities
# - set_ifnot
add_test(
  NAME testCetCMakeUtilities
  COMMAND ${CMAKE_COMMAND}
          -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules
          -P ${CMAKE_CURRENT_SOURCE_DIR}/testCetCMakeUtilities.cmake
  )

# - enum_option
add_test(
  NAME testEnumOption_Default
  COMMAND ${CMAKE_COMMAND}
          -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules
          -P ${CMAKE_CURRENT_SOURCE_DIR}/testEnumOption.cmake
  )
set_tests_properties(testEnumOption_Default
  PROPERTIES PASS_REGULAR_EXPRESSION "baz alice"
  )

add_test(
  NAME testEnumOption_Basic
  COMMAND ${CMAKE_COMMAND}
          -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules
          -DFOOBAR=foo
          -DCASEISALTERED=bob
          -P ${CMAKE_CURRENT_SOURCE_DIR}/testEnumOption.cmake
  )
set_tests_properties(testEnumOption_Basic
  PROPERTIES PASS_REGULAR_EXPRESSION "foo bob"
  )

add_test(
  NAME testEnumOption_OutOfSet
  COMMAND ${CMAKE_COMMAND}
          -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules
          -DFOOBAR=alice
          -P ${CMAKE_CURRENT_SOURCE_DIR}/testEnumOption.cmake
  )
set_tests_properties(testEnumOption_OutOfSet
  PROPERTIES WILL_FAIL TRUE
  )

add_test(
  NAME testEnumOption_BadCase
  COMMAND ${CMAKE_COMMAND}
          -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules
          -DFOOBAR=Foo
          -P ${CMAKE_CURRENT_SOURCE_DIR}/testEnumOption.cmake
  )
set_tests_properties(testEnumOption_BadCase
  PROPERTIES WILL_FAIL TRUE
  )

add_test(
  NAME testEnumOption_CaseInsensitive
  COMMAND ${CMAKE_COMMAND}
          -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules
          -DCASEISALTERED=AlICe
          -P ${CMAKE_CURRENT_SOURCE_DIR}/testEnumOption.cmake
  )
set_tests_properties(testEnumOption_CaseInsensitive
  PROPERTIES PASS_REGULAR_EXPRESSION "baz alice"
  )

#-----------------------------------------------------------------------
# CetInstallDirs tests
# - GNU style
add_test(
  NAME testCetInstallDirs_Basic
  COMMAND ${CMAKE_COMMAND}
          -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules
          -P ${CMAKE_CURRENT_SOURCE_DIR}/testCetInstallDirs.cmake
  )

# - UPS basics
add_test(
  NAME testCetUPS_basic
  COMMAND ${CMAKE_COMMAND}
          -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules
          -P ${CMAKE_CURRENT_SOURCE_DIR}/testCetUPS.cmake
  )


# UPS style, for now, need a project as we need to deal with binaries
# but see if above script can be adapted
# The below is just a smoke test and does not check that the files
# are installed in the right place yet...
add_test(
  NAME testUPSInstallDirs
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testUPSInstallDirs ${CMAKE_CURRENT_BINARY_DIR}/testUPSInstallDirs
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-DCET_INSTALL_UPS=ON"
          --test-command ${CMAKE_MAKE_PROGRAM} install
  )

#-----------------------------------------------------------------------
# CetWriteCXXVersionAPI test
#
add_test(
  NAME testCetWriteCXXVersionAPI_build_and_run
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetWriteCXXVersionAPI ${CMAKE_CURRENT_BINARY_DIR}/testCetWriteCXXVersionAPI
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules"
          --test-command testCetWriteCXXVersionAPI
  )

#-----------------------------------------------------------------------
# CetCMakeSettings test
#
add_test(
  NAME testCetCMakeSettings_sanity
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetCMakeSettings ${CMAKE_CURRENT_BINARY_DIR}/testCetCMakeSettings_sanity
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-Dcetbuildtools2_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules"
  )

#-----------------------------------------------------------------------
# CetCompilerSettings test
# - Simply a smoke test for now
#   1. Enable up to VIGILANT we can to check all flags are valid across tested
#      platforms (PARANOID known to be GNU specific at present)
#   2. Run once for each build mode
#
foreach(_mode "" Release Debug MinSizeRel RelWithDebInfo)
  add_test(
    NAME testCetCompilerSettings_${_mode}
    COMMAND ${CMAKE_CTEST_COMMAND}
            --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetCompilerSettings ${CMAKE_CURRENT_BINARY_DIR}/testCetCompilerSettings_${_mode}
            --build-generator ${CMAKE_GENERATOR}
            --build-makeprogram ${CMAKE_MAKE_PROGRAM}
            --build-config ${_mode}
            --build-options "-Dcetbuildtools2_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-DCET_COMPILER_DIAGNOSTIC_LEVEL=VIGILANT"
    )
endforeach()

#-----------------------------------------------------------------------
# Cet_configure_cxx_standard test
foreach(cxx_epoch IN ITEMS 11 14 17 2a)
  add_test(
    NAME testCetConfigureCXXStandard_${cxx_epoch}
    COMMAND ${CMAKE_CTEST_COMMAND}
            --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetConfigureCXXStandard ${CMAKE_CURRENT_BINARY_DIR}/testCetConfigureCXXStandard_${cxx_epoch}
            --build-generator ${CMAKE_GENERATOR}
            --build-makeprogram ${CMAKE_MAKE_PROGRAM}
            --build-config $<CONFIG>
            --build-options "-Dcetbuildtools2_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-DCET_COMPILER_CXX_STANDARD=${cxx_epoch}" "-DEXPECTED_CXX_STD=${cxx_epoch}"
            --test-command ${CMAKE_CTEST_COMMAND} -VV
     )

   # Check on expected pass/fail of test
   # May need further special cases as/when additional compilers/cmake
   # versions are supported.
   if(NOT DEFINED CMAKE_CXX${cxx_epoch}_STANDARD_COMPILE_OPTION)
     # CMake/Compiler doesn't know about this standard, test should fail
     set_tests_properties(testCetConfigureCXXStandard_${cxx_epoch} PROPERTIES WILL_FAIL TRUE)
   endif()

   # Special case for GCC < 4.9: It does not report __cplusplus correctly
   if(CMAKE_COMPILER_IS_GNUCXX AND (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.9) AND (cxx_epoch GREATER 11))
     set_tests_properties(testCetConfigureCXXStandard_${cxx_epoch} PROPERTIES WILL_FAIL TRUE)
   endif()
endforeach()

# Test that unknown min standard fails
add_test(
  NAME testCetConfigureCXXStandard_invalidminimum
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetConfigureCXXStandard ${CMAKE_CURRENT_BINARY_DIR}/testCetConfigureCXXStandard_invalidminimum
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-Dcetbuildtools2_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-DCET_COMPILER_CXX_STANDARD_MINIMUM=42" "-DEXPECTED_CXX_STD=42"
          --test-command ${CMAKE_CTEST_COMMAND} -VV
  )
set_tests_properties(testCetConfigureCXXStandard_invalidminimum PROPERTIES WILL_FAIL TRUE)

# Test that a valid min standard is also the default standard
if(DEFINED CMAKE_CXX14_STANDARD_COMPILE_OPTION)
  set(_cxxmin 14)
else()
  set(_cxxmin 11)
endif()

add_test(
  NAME testCetConfigureCXXStandard_minimumisdefault
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetConfigureCXXStandard ${CMAKE_CURRENT_BINARY_DIR}/testCetConfigureCXXStandard_minimumisdefault
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-Dcetbuildtools2_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-DCET_COMPILER_CXX_STANDARD_MINIMUM=${_cxxmin}" "-DEXPECTED_CXX_STD=${_cxxmin}"
          --test-command ${CMAKE_CTEST_COMMAND} -VV
  )

# Special case for GCC < 4.9: It does not report __cplusplus correctly
if(CMAKE_COMPILER_IS_GNUCXX AND (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.9))
  set_tests_properties(testCetConfigureCXXStandard_minimumisdefault PROPERTIES WILL_FAIL TRUE)
endif()


#-----------------------------------------------------------------------
# BasicPlugin test
#
add_test(
  NAME testCetBasicPlugin
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetBasicPlugin ${CMAKE_CURRENT_BINARY_DIR}/testCetBasicPlugin
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-Dcetbuildtools2_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules"
  )

#-----------------------------------------------------------------------
# FindXXX Modules
#-----------------------------------------------------------------------
# FindCppUnit test
#
add_test(
  NAME testFindCppUnit
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testFindCppUnit ${CMAKE_CURRENT_BINARY_DIR}/testFindCppUnit
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-Dcetbuildtools2_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}"
  )

# FindTBB test
add_test(
  NAME testFindTBB
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testFindTBB ${CMAKE_CURRENT_BINARY_DIR}/testFindTBB
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-Dcetbuildtools2_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}"
  )

# Boost imported targets workaround
# On CMake < 3.11, FindBoost module won't generate imported targets for
# unknown Boost versions, as it wants to fully define the dependencies
# between them. From 3.11, imported targets will be generated for all known
# libs, just without the link dependencies. This leaves it up to the user
# to define closed set of links. In general, this is done anyway for CET
# projects. To support older Cmake clients without patching, provide a workaround
# to create imported targets on older cmakes.
add_test(
  NAME testFindBoostWorkaround
  COMMAND ${CMAKE_CTEST_COMMAND}
  --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testFindBoostWorkaround ${CMAKE_CURRENT_BINARY_DIR}/testFindBoostWorkaround
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-Dcetbuildtools2_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}"
  )



#-----------------------------------------------------------------------
# Tests of cet_test
# Basic
add_test(
  NAME testCetTest_sanity
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetTest ${CMAKE_CURRENT_BINARY_DIR}/testCetTest
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules"
          --test-command ${CMAKE_CTEST_COMMAND} -VV
  )
# Check Fail cases...
foreach(_cettestfailcase UNPARSED TEST_EXEC_NO_HANDBUILT EXECUTABLE_COMBINATION_HP EXECUTABLE_COMBINATION_HU EXECUTABLE_COMBINATION_PU NO_OUTPUTFILTERWITHOUT_REF)
  add_test(
    NAME testCetTest_${_cettestfailcase}
    COMMAND ${CMAKE_CTEST_COMMAND}
            --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetTest ${CMAKE_CURRENT_BINARY_DIR}/testCetTest_${_cettestfailcase}
            --build-generator ${CMAKE_GENERATOR}
            --build-makeprogram ${CMAKE_MAKE_PROGRAM}
            --build-config $<CONFIG>
            --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-D__CT_FAILURE_${_cettestfailcase}=1"
            --test-command ${CMAKE_CTEST_COMMAND} -VV
    )
  set_tests_properties(testCetTest_${_cettestfailcase} PROPERTIES WILL_FAIL TRUE)
endforeach()

# Test issue in 0.4.0 - Specifying REF alone is an error, but should not be
add_test(
  NAME testCetTest_refalone
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetTest ${CMAKE_CURRENT_BINARY_DIR}/testCetTest_refalone
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-D__CT_BUG_REFALONE=1"
          --test-command ${CMAKE_CTEST_COMMAND} -VV
  )


# Test boost.unit
find_package(Boost QUIET)
if(Boost_FOUND)
  add_test(
    NAME testBoostUnitProperties
    COMMAND ${CMAKE_CTEST_COMMAND}
            --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testBoostUnitProperties ${CMAKE_CURRENT_BINARY_DIR}/testBoostUnitProperties
            --build-generator ${CMAKE_GENERATOR}
            --build-makeprogram ${CMAKE_MAKE_PROGRAM}
            --build-config $<CONFIG>
            --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}" "-DBOOST_ROOT=${BOOST_ROOT}"
    )
else()
  message(STATUS "System Boost install not found, disabling testBoostUnitProperties")
endif()

# Test fail case of Boost not found deliberately
add_test(
  NAME testBoostUnitProperties_FailCase
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testBoostUnitProperties ${CMAKE_CURRENT_BINARY_DIR}/testBoostUnitProperties_FailCase
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules" "-DTEST_FAILCASE=ON"
  )
# Test will fail to configure, PASS condition is that this failure output matches error
# message expected from set_boost_unit_properties
set_tests_properties(testBoostUnitProperties_FailCase
  PROPERTIES
   PASS_REGULAR_EXPRESSION "set_boost_unit_properties: Boost not found"
  )

# Test catch tests
# Test use of internal catchmain
# Test modes explicitly because we strip the library so confirm this works
# in non-Debug and Debug modes
foreach(_catchmode Release Debug)
  add_test(
    NAME testCetTestCatchMain-${_catchmode}
    COMMAND ${CMAKE_CTEST_COMMAND}
            --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetTestCatchMain ${CMAKE_CURRENT_BINARY_DIR}/testCetTestCatchMain-${_catchmode}
            --build-generator ${CMAKE_GENERATOR}
            --build-makeprogram ${CMAKE_MAKE_PROGRAM}
            --build-config ${_catchmode}
            --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules"
            --test-command ${CMAKE_CTEST_COMMAND} -VV
  )
endforeach()

# Test use of ParseAndAddCatchTests
add_test(
  NAME testCetTestParseAndAddCatchTests
  COMMAND ${CMAKE_CTEST_COMMAND}
    --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetTestParseAndAddCatchTests ${CMAKE_CURRENT_BINARY_DIR}/testCetTestParseAndAddCatchTests
    --build-generator ${CMAKE_GENERATOR}
    --build-makeprogram ${CMAKE_MAKE_PROGRAM}
    --build-config ${_catchmode}
    --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules"
    --test-command ${CMAKE_CTEST_COMMAND} -VV
  )

# Test pass through of dynamic loader path via CETD_LIBRARY_PATH
# NB: on MacOS, assumes that CMake is in a non-SIP area
add_test(
  NAME testCetTestSIP
  COMMAND ${CMAKE_CTEST_COMMAND}
    --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetTestSIP ${CMAKE_CURRENT_BINARY_DIR}/testCetTestSIP
    --build-generator ${CMAKE_GENERATOR}
    --build-makeprogram ${CMAKE_MAKE_PROGRAM}
    --build-two-config # Because re-cmakeing shouldn't change things
    --build-config $<CONFIG>
    --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules"
    --test-command ${CMAKE_CTEST_COMMAND} -VV
  )

# Test use of a multimode generator, only Xcode for now, but should
# be generic enough.
# Check that tests run appropriate executable and set paths correctly
# for multimode outputs without needing to know details
#if(APPLE AND EXISTS "/usr/bin/xcodebuild")
#  add_test(...)
# how to build-and-test all configs?
#endif()

#-----------------------------------------------------------------------
# Test CetScript
add_test(
  NAME testCetScript
  COMMAND ${CMAKE_CTEST_COMMAND}
  --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetScript ${CMAKE_CURRENT_BINARY_DIR}/testCetScript
    --build-generator ${CMAKE_GENERATOR}
    --build-makeprogram ${CMAKE_MAKE_PROGRAM}
    --build-config $<CONFIG>
    --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules"
    --test-command ${CMAKE_CTEST_COMMAND} -VV
  )

