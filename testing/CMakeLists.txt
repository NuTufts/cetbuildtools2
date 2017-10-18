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
add_test(
  NAME testCetInstallDirs_Basic
  COMMAND ${CMAKE_COMMAND}
          -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules
          -P ${CMAKE_CURRENT_SOURCE_DIR}/testCetInstallDirs.cmake
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
# FindCppUnit test
#
add_test(
  NAME testFindCppUnit
  COMMAND ${CMAKE_CTEST_COMMAND}
          --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testFindCppUnit ${CMAKE_CURRENT_BINARY_DIR}/testFindCppUnit
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-Dcetbuildtools2_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules"
  )


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
foreach(_cettestfailcase UNPARSED TEST_EXEC_NO_HANDBUILT EXECUTABLE_COMBINATION_HP EXECUTABLE_COMBINATION_HU EXECUTABLE_COMBINATION_PU)
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

# Test use of internal catchmain
add_test(
  NAME testCetTestCatchMain
  COMMAND ${CMAKE_CTEST_COMMAND}
  --build-and-test ${CMAKE_CURRENT_LIST_DIR}/testCetTestCatchMain ${CMAKE_CURRENT_BINARY_DIR}/testCetTestCatchMain
          --build-generator ${CMAKE_GENERATOR}
          --build-makeprogram ${CMAKE_MAKE_PROGRAM}
          --build-config $<CONFIG>
          --build-options "-DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}/Modules"
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
