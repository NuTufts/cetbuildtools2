#.rst:
# CetTest
# -------
#
# .. code-block:: cmake
#
#   include(CetTest)
#
# Declare and define tests compatible with CET testing policies.
#
# Include this module at the root of your project's testing tree or
# wherever you need to specify a test.
#
# The following functions are provided to help in declaring tests and
# defining their properties
#
# .. cmake:command:: cet_test
#
#   .. code-block:: cmake
#
#     cet_test(<target> [<options>] [<args>]
#
# Specify tests in a concise and transparent way (see also
# ``cet_test_env()`` and ``cet_test_assertion()``, below).
#
# Options:
#
# HANDBUILT
#   Do not build the target -- it will be provided. This option is
#   mutually exclusive with the PREBUILT option.
#
# PREBUILT
#   Do not build the target -- pick it up from the source dir (eg
#   scripts).  This option is mutually exclusive with the HANDBUILT
#   option and simply calls the cet_script() function with appropriate
#   options.
#
# USE_BOOST_UNIT
#   This test uses the Boost Unit Test Framework.
#
# USE_CATCH_MAIN
#   This test will use the Catch test framework
#   (https://github.com/philsquared/Catch). The specified target will be
#   built from a precompiled main program to run tests described in the
#   files specified by SOURCES.
#
#   N.B.: if you wish to use the ParseAndAddCatchTests() facility
#   contributed to the Catch system, you should specify NO_AUTO to avoid
#   generating a, "standard" test. Note also that you may have your own
#   test executables using Catch without using USE_CATCH_MAIN. However,
#   be aware that the compilation of a Catch main is quite expensive,
#   and any tests that *do* use this option will all share the same
#   compiled main.
#
#   TODO: Supply Catch directly so versions consistent? Same for
#         Parse and add?
#   Note also that client packages are responsible for making sure Catch
#   is available, such as with:
#
#     catch             <version>               -nq-    only_for_build
#
#   in product_deps.
#
# NO_AUTO
#   Do not add the target to the auto test list.
#
# INSTALL_BIN
#   Install this test's script / exec in the product's binary directory
#   (ignored for HANDBUILT).
#
# INSTALL_EXAMPLE
#   Install this test and all its data files into the examples area of the
#   product.
#
# INSTALL_SOURCE
#   Install this test's source in the source area of the product.
#
# Arguments:
#
# CONFIGURATIONS
#   Configurations (Debug, etc, etc) under which the test shall be executed.
#
# DATAFILES
#   Input and/or references files to be copied to the test area in the
#   build tree for use by the test. If there is no path, or a relative
#   path, the file is assumed to be in or under
#   ``CMAKE_CURRENT_SOURCE_DIR``.
#
# DEPENDENCIES
#   List of top-level dependencies to consider for a PREBUILT
#   target. Top-level implies a target (not file) created with
#   ADD_EXECUTABLE, ADD_LIBRARY or ADD_CUSTOM_TARGET.
#
# LIBRARIES
#   Extra libraries to link to the resulting target.
#
# OPTIONAL_GROUPS
#   Assign this test to one or more named optional groups. If the CMake
#   list variable CET_TEST_GROUPS is set (e.g. with -D on the CMake
#   command line) and there is overlap between the two lists, execute
#   the test. The CET_TEST_GROUPS cache variable may additionally
#   contain the optional values ALL or NONE.
#
# REF
#  The standard output of the test will be captured and compared against
#   the specified reference file. It is an error to specify this
#   argument and either the PASS_REGULAR_EXPRESSION or
#   FAIL_REGULAR_EXPRESSION test properties to the TEST_PROPERTIES
#   argument: success is the logical AND of the exit code from execution
#   of the test as originally specified, and the success of the
#   filtering and subsequent comparison of the output (and optionally,
#   the error stream). Optionally, a second element may be specified
#   representing a reference for the error stream; otherwise, standard
#   error will be ignored.
#
#  If REF is specified, then OUTPUT_FILTERS may also be specified
#   (OUTPUT_FILTER and optionally OUTPUT_FILTER_ARGS will be accepted in
#   the alternative for historical reasons). OUTPUT_FILTER must be a
#   program which expects input on STDIN and puts the filtered output on
#   STDOUT. OUTPUT_FILTERS should be a list of filters expecting input
#   on STDIN and putting output on STDOUT. If DEFAULT is specified as a
#   filter, it will be replaced at that point in the list of filters by
#   appropriate defaults. Examples:
#
#     OUTPUT_FILTERS "filterA -x -y \"arg with spaces\"" filterB
#
#     OUTPUT_FILTERS filterA DEFAULT filterB
#
# REQUIRED_FILES
#   These files are required to be present before the test will be
#   executed. If any are missing, ctest will record NOT RUN for this
#   test.
#
# SCOPED
#   Test target (but not script nor compiled executable) names will
#   be scoped by project name (<PROJECT_NAME>:...)
#
# SOURCES
#   Sources to use to build the target (default is ${target}.cc).
#
# TEST_ARGS
#   Any arguments to the test to be run.
#
# TEST_EXEC
#   The exec to run (if not the target). The HANDBUILT option must
#   be specified in conjunction with this option.
#
# TEST_PROPERTIES
#   Properties to be added to the test. See documentation of the cmake
#   command, "set_tests_properties."
#
# Cache variables
#
# CET_TEST_GROUPS
#   Test group names specified using the OPTIONAL_GROUPS list option are
#   compared against this list to determine whether to configure the
#   test. Default value is the special value "NONE," meaning no
#   optional tests are to be configured. Optionally CET_TEST_GROUPS may
#   contain the special value "ALL." Specify multiple values separated
#   by ";" (escape or protect with quotes) or "," See explanation of
#   the OPTIONAL_GROUPS variable above for more details.
#
# CET_DEFINED_TEST_GROUPS
#   Any test group names CMake sees will be added to this list.
#
# Notes
#
# * cet_make_exec() and art_make_exec() are more flexible than building
#   the test exec with cet_test(), and are to be preferred (use the
#   NO_INSTALL option to same as appropriate). Use
#   cet_test(... HANDBUILT TEST_EXEC ...) to use test execs built this
#   way.
#
# * The CMake properties PASS_REGULAR_EXPRESSION and
#   FAIL_REGULAR_EXPRESSION are incompatible with the REF option, but we
#   cannot check for them if you use CMake's add_tests_properties()
#   rather than cet_test(CET_TEST_PROPERTIES ...).
#
# * If you intend to set the property SKIP_RETURN_CODE, you should use
#   CET_TEST_PROPERTIES to set it rather than add_tests_properties(), as
#   cet_test() needs to take account of your preference.
#
#
# .. cmake:command:: cet_test_env
#
# set environment for all tests here specified.
#
# Usage: cet_test_env([<options] [<env>])
#
# Options:
#
# CLEAR
#   Clear the global test environment (ie anything previously set with
#   cet_test_env()) before setting <env>.
#
# Notes:
#
# * <env> may be omitted. If so and the CLEAR option is not specified,
#   then cet_test_env() is a NOP.
#
# * If cet_test_env() is called in a directory to set the environment
#   for tests then that will be propagated to tests defined in
#   subdirectories unless include(CetTest) or cet_test_env(CLEAR ...) is
#   invoked in that directory.
#
# .. cmake:command:: cet_test_assertion
#
# require assertion failure on given condition
#
# Usage: cet_test_assertion(CONDITION TARGET...)
#
# Notes:
#
# * CONDITION should be a CMake regex which should have any escaped
#   items doubly-escaped due to being passed as a string argument
#   (e.g. "\\\\(" for a literal open-parenthesis, "\\\\." for a literal
#   period).
#
# * TARGET...: the name(s) of the test target(s) as specified to
#   cet_test() or add_test() -- require at least one.
#

#-----------------------------------------------------------------------
# Modifications Copyright 2015-2017 Ben Morgan <Ben.Morgan@warwick.ac.uk
# Modifications Copyright 2015-2017 University of Warwick
#
# Distributed under the OSI-approved BSD 3-Clause License (the "License");
# see accompanying file LICENSE for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#-----------------------------------------------------------------------


# Need argument parser.
include(CMakeParseArguments)

# Utilities
include(CetCMakeUtilities)

# Copy function.
include(CetCopy)
# May need Boost Unit Test Framework library.
#include(FindUpsBoost)
# Need cet_script for PREBUILT scripts
include(CetMake)

# NOT USED IN THIS MODULE
# May need to escape a string to avoid misinterpretation as regex
#include(CetRegexEscape)

#-----------------------------------------------------------------------
# Global Data
#-----------------------------------------------------------------------
# If Boost has been specified but the library hasn't, load the library.
#IF((NOT Boost_UNIT_TEST_FRAMEWORK_LIBRARY) AND BOOST_VERS)
#  find_ups_boost(${BOOST_VERS} unit_test_framework)
#ENDIF()

# Module Know Thine Self
set(CET_TEST_MODULE_DIR "${CMAKE_CURRENT_LIST_DIR}")

# Our vendored (for now) catch source
set(CET_CATCH_MAIN_SOURCE "${CMAKE_CURRENT_LIST_DIR}/catch/cet_catch_main.cpp")
set(CET_CATCH_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}")

# Wrap the comparator so we always use ours
set(CET_RUNANDCOMPARE "${CET_TEST_MODULE_DIR}/RunAndCompare.cmake")

# Wrap the cet_test_exec so we always use ours - It means that PATH
# is not needed.
set(CET_CET_EXEC_TEST "${CET_TEST_MODULE_DIR}/cet_exec_test")

# Test groups
set(CET_TEST_GROUPS "NONE"
  CACHE STRING "List of optional test groups to be configured."
  )
mark_as_advanced(CET_TEST_GROUPS)
string(TOUPPER "${CET_TEST_GROUPS}" CET_TEST_GROUPS_UC)

# Test environment variables
set(CET_TEST_ENV ""
  CACHE INTERNAL "Environment to add to every test"
  FORCE
  )

#-----------------------------------------------------------------------
# CetTest Public API
#-----------------------------------------------------------------------


# - ??
function(_update_defined_test_groups)
  if(ARGC)
    set(TMP_LIST ${CET_DEFINED_TEST_GROUPS})
    list(APPEND TMP_LIST ${ARGN})
    list(REMOVE_DUPLICATES TMP_LIST)
    set(CET_DEFINED_TEST_GROUPS ${TMP_LIST}
      CACHE STRING "List of defined test groups."
      FORCE
      )
  endif()
endfunction()

# - ??
function(_check_want_test CET_OPTIONAL_GROUPS CET_WANT_TEST)
  if(NOT CET_OPTIONAL_GROUPS)
    set(${CET_WANT_TEST} YES PARENT_SCOPE)
    return() # Short-circuit.
  endif()

  set(${CET_WANT_TEST} NO PARENT_SCOPE)

  list(FIND CET_TEST_GROUPS_UC ALL WANT_ALL)
  list(FIND CET_TEST_GROUPS_UC NONE WANT_NONE)

  if(WANT_ALL GREATER -1)
    set(${CET_WANT_TEST} YES PARENT_SCOPE)
    return() # Short-circuit.
  elseif(WANT_NONE GREATER -1)
    return() # Short-circuit.
  else()
    foreach(item IN LISTS CET_OPTIONAL_GROUPS)
      string(TOUPPER "${item}" item_uc)
      list(FIND CET_TEST_GROUPS_UC ${item_uc} FOUND_ITEM)
      if(FOUND_ITEM GREATER -1)
        set(${CET_WANT_TEST} YES PARENT_SCOPE)
        return() # Short-circuit.
      endif()
    endforeach()
  endif()
endfunction()

####################################
# Main macro definitions.
macro(cet_test_env)
  cmake_parse_arguments(CET_TEST
    "CLEAR"
    ""
    ""
    ${ARGN}
    )

  if(CET_TEST_CLEAR)
    set(CET_TEST_ENV "")
  endif()
  list(APPEND CET_TEST_ENV ${CET_TEST_UNPARSED_ARGUMENTS})
endmacro()

#-----------------------------------------------------------------------
# function: cet_test
#-----------------------------------------------------------------------
function(cet_test CET_TARGET)
  # Parse arguments
  if(${CET_TARGET} MATCHES .*/.*)
    message(FATAL_ERROR "${CET_TARGET} shuld not be a path. Use a simple "
      "target name with the HANDBUILT and TEST_EXEC options instead.")
  endif()

  cmake_parse_arguments(CET
    "HANDBUILT;PREBUILT;USE_CATCH_MAIN;NO_AUTO;USE_BOOST_UNIT;INSTALL_BIN;INSTALL_EXAMPLE;INSTALL_SOURCE;SCOPED"
    "OUTPUT_FILTER;TEST_EXEC"
    "CONFIGURATIONS;DATAFILES;DEPENDENCIES;LIBRARIES;OPTIONAL_GROUPS;OUTPUT_FILTERS;OUTPUT_FILTER_ARGS;REQUIRED_FILES;SOURCES;TEST_ARGS;TEST_PROPERTIES;REF"
    ${ARGN}
    )

  if(CET_OUTPUT_FILTERS AND CET_OUTPUT_FILTER_ARGS)
    message(FATAL_ERROR "OUTPUT_FILTERS is incompatible with FILTER_ARGS:\nEither use the singular OUTPUT_FILTER or use double-quoted strings in OUTPUT_FILTERS\nE.g. OUTPUT_FILTERS \"filter1 -x -y\" \"filter2 -y -z\"")
  endif()

  # If GLOBAL is not set, prepend "${PROJECT_NAME}:" to the target name
  if(CET_SCOPED)
    set(TARGET_NAME "${PROJECT_NAME}:${CET_TARGET}")
  else()
    set(TARGET_NAME "${CET_TARGET}")
  endif()

  # Set up to handle a per-test work directory for parallel testing.
  set(CET_TEST_WORKDIR "${CMAKE_CURRENT_BINARY_DIR}/${CET_TARGET}.d")
  file(MAKE_DIRECTORY "${CET_TEST_WORKDIR}")

  # - Actual program to run as the test
  if(CET_TEST_EXEC)
    if(NOT CET_HANDBUILT)
      message(FATAL_ERROR "cet_test: target ${CET_TARGET} cannot specify "
        "TEST_EXEC without HANDBUILT")
    endif()
  else()
    set(CET_TEST_EXEC ${CMAKE_CURRENT_BINARY_DIR}/${CET_TARGET})
  endif()

  if(CET_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "cet_test: Unparsed (non-option) arguments detected: \"${CET_UNPARSED_ARGUMENTS}\"
Check for missing keyword(s) in the definition of test ${CET_TARGET} in your CMakeLists.txt.")
  endif()

  # - Collect datafiles
  if(DEFINED CET_DATAFILES)
    list(REMOVE_DUPLICATES CET_DATAFILES)
    set(datafiles_tmp)

    foreach(df ${CET_DATAFILES})
      get_filename_component(dfd ${df} DIRECTORY)
      if(dfd)
        list(APPEND datafiles_tmp ${df})
      else()
        list(APPEND datafiles_tmp ${CMAKE_CURRENT_SOURCE_DIR}/${df})
      endif()
    endforeach()

    set(CET_DATAFILES ${datafiles_tmp})
  endif()

  #-----------------------------
  # - Define the test executable
  if((CET_HANDBUILT AND CET_PREBUILT) OR
    (CET_HANDBUILT AND CET_USE_CATCH_MAIN) OR
    (CET_PREBUILT AND CET_USE_CATCH_MAIN))
    # HANDBUILT/PREBUILT/USE_CATCH_MAIN are mutually exclusive
    message(FATAL_ERROR "cet_test: target ${CET_TARGET} must have only one of the HANDBUILT, PREBUILT, or USE_CATCH_MAIN options set.")
  elseif(CET_PREBUILT)
    # eg scripts.
    if(NOT CET_INSTALL_BIN)
      set(CET_NO_INSTALL "NO_INSTALL")
    endif()

    cet_script(
      ${CET_TARGET}
      ${CET_NO_INSTALL}
      DEPENDENCIES ${CET_DEPENDENCIES}
      )
  elseif(NOT CET_HANDBUILT)
    # Normal build
    # Build the executable
    if(NOT CET_SOURCES) # Useful default.
      set(CET_SOURCES ${CET_TARGET}.cc)
    endif()

    add_executable(${CET_TARGET} ${CET_SOURCES})
    # -- !! It's this that *should* allow running without explicit paths!!
    set(CET_TEST_EXEC $<TARGET_FILE:${CET_TARGET}>)

    if(CET_USE_CATCH_MAIN)
      # Create the catch-main target on demand
      # Link it to testing target
      add_catch_main_library(${PROJECT_NAME}_catch_main)
      target_link_libraries("${CET_TARGET}" PRIVATE ${PROJECT_NAME}_catch_main)
    endif()

    # Boost.Unit-ify
    if(CET_USE_BOOST_UNIT)
      set_boost_unit_properties(${CET_TARGET})
    endif()

    # TBB.offload-ify
    set_tbb_offload_properties(${CET_TARGET})

    # Link to any required libs
    if(CET_LIBRARIES)
      # Gonna ignore this section for now and see if it makes any difference
      # In any case, LIBRARIES should always be a list of valid things
      # CMake can link - full paths or target names
      #set(link_lib_list "")
      #foreach(lib ${CET_LIBRARIES})
      #  # ?? What is the intent of this path matching or uppercasing ??
      #  string(REGEX MATCH [/] has_path "${lib}")
      #  if(has_path)
      #    list(APPEND link_lib_list ${lib})
      #  else()
      #    string(TOUPPER ${lib} ${lib}_UC)
      #
      #    if(${${lib}_UC})
      #      _cet_debug_message( "changing ${lib} to ${${${lib}_UC}}")
      #      list(APPEND link_lib_list ${${${lib}_UC}})
      #    else()
      #      list(APPEND link_lib_list ${lib})
      #    endif()
      #  endif()
      #endforeach()
      target_link_libraries(${CET_TARGET} PRIVATE ${CET_LIBRARIES})
    endif()
  endif()

  # Setup Data, Configurations, Groups
  cet_copy(${CET_DATAFILES} DESTINATION ${CET_TEST_WORKDIR} WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

  if(CET_CONFIGURATIONS)
    set(CONFIGURATIONS_CMD CONFIGURATIONS)
  endif()

  _update_defined_test_groups(${CET_OPTIONAL_GROUPS})
  _check_want_test("${CET_OPTIONAL_GROUPS}" WANT_TEST)

  # Configure Properties and Behaviour
  if(NOT CET_NO_AUTO AND WANT_TEST)
    list(FIND CET_TEST_PROPERTIES SKIP_RETURN_CODE skip_return_code)

    if(skip_return_code GREATER -1)
      math(EXPR skip_return_code "${skip_return_code} + 1")
      list(GET CET_TEST_PROPERTIES ${skip_return_code} skip_return_code)
    else()
      set(skip_return_code 247)
      list(APPEND CET_TEST_PROPERTIES SKIP_RETURN_CODE ${skip_return_code})
    endif()

    if(CET_REF)
      list(FIND CET_TEST_PROPERTIES PASS_REGULAR_EXPRESSION has_pass_exp)
      list(FIND CET_TEST_PROPERTIES FAIL_REGULAR_EXPRESSION has_fail_exp)

      if(has_pass_exp GREATER -1 OR has_fail_exp GREATER -1)
        message(FATAL_ERROR "Cannot specify REF option for test ${CET_TARGET} in conjunction with (PASS|FAIL)_REGULAR_EXPESSION.")
      endif()

      list(LENGTH CET_REF CET_REF_LEN)
      if(CET_REF_LEN EQUAL 1)
        set(OUTPUT_REF ${CET_REF})
      else()
        list(GET CET_REF 0 OUTPUT_REF)
        list(GET CET_REF 1 ERROR_REF)
        set(DEFINE_ERROR_REF "-DTEST_REF_ERR=${ERROR_REF}")
        set(DEFINE_TEST_ERR "-DTEST_ERR=${CET_TARGET}.err")
      endif()

      separate_arguments(TEST_ARGS UNIX_COMMAND "${CET_TEST_ARGS}")

      if(CET_OUTPUT_FILTER)
        set(DEFINE_OUTPUT_FILTER "-DOUTPUT_FILTER=${CET_OUTPUT_FILTER}")
        if(CET_OUTPUT_FILTER_ARGS)
          separate_arguments(FILTER_ARGS UNIX_COMMAND "${CET_OUTPUT_FILTER_ARGS}")
          set(DEFINE_OUTPUT_FILTER_ARGS "-DOUTPUT_FILTER_ARGS=${FILTER_ARGS}")
        endif()
      elseif(CET_OUTPUT_FILTERS)
        string(REPLACE ";" "::" DEFINE_OUTPUT_FILTERS "${CET_OUTPUT_FILTERS}")
        set(DEFINE_OUTPUT_FILTERS "-DOUTPUT_FILTERS=${DEFINE_OUTPUT_FILTERS}")
      endif()


      # ADD_TEST
      add_test(NAME "${TARGET_NAME}"
        ${CONFIGURATIONS_CMD} ${CET_CONFIGURATIONS}
        COMMAND ${CET_CET_EXEC_TEST} --wd ${CET_TEST_WORKDIR}
        --required-files "${CET_REQUIRED_FILES}"
        --datafiles "${CET_DATAFILES}"
        --skip-return-code ${skip_return_code}
        ${CMAKE_COMMAND}
        -DTEST_EXEC=${CET_TEST_EXEC}
        -DTEST_ARGS=${TEST_ARGS}
        -DTEST_REF=${OUTPUT_REF}
        ${DEFINE_ERROR_REF}
        ${DEFINE_TEST_ERR}
        -DTEST_OUT=${CET_TARGET}.out
        ${DEFINE_OUTPUT_FILTER} ${DEFINE_OUTPUT_FILTER_ARGS} ${DEFINE_OUTPUT_FILTERS}
        -P ${CET_RUNANDCOMPARE}
        )
    else()
      # Add the test.
      add_test(NAME "${TARGET_NAME}"
        ${CONFIGURATIONS_CMD} ${CET_CONFIGURATIONS}
        COMMAND
        ${CET_CET_EXEC_TEST} --wd ${CET_TEST_WORKDIR}
        --required-files "${CET_REQUIRED_FILES}"
        --datafiles "${CET_DATAFILES}"
        --skip-return-code ${skip_return_code}
        ${CET_TEST_EXEC} ${CET_TEST_ARGS}
        )
    endif()

    # Collate and apply directly known properties
    # -- CMake 2.8 and higher, but that's o.k. as we rely 2.8 anyway
    set_tests_properties("${TARGET_NAME}"
      PROPERTIES WORKING_DIRECTORY ${CET_TEST_WORKDIR}
      )

    if(CET_TEST_PROPERTIES)
      set_tests_properties("${TARGET_NAME}" PROPERTIES ${CET_TEST_PROPERTIES})
    endif()

    # Prepend local ENV/Append local REQ to any global settings
    if(CET_TEST_ENV)
      get_test_property("${TARGET_NAME}" ENVIRONMENT CET_TEST_ENV_TMP)
      set_property(TEST "${TARGET_NAME}"
        PROPERTY ENVIRONMENT "${CET_TEST_ENV}"
        )
      if(CET_TEST_ENV_TMP)
        set_property(TEST "${TARGET_NAME}"
          APPEND PROPERTY ENVIRONMENT "${CET_TEST_ENV_TMP}"
          )
      endif()
    endif()

    if(CET_REF)
      set_property(TEST ${CET_TARGET}
        APPEND PROPERTY REQUIRED_FILES "${CET_REF}"
        )
    endif()
  else()
    if(CET_OUTPUT_FILTER OR CET_OUTPUT_FILTER_ARGS)
      message(FATAL_ERROR "OUTPUT_FILTER and OUTPUT_FILTER_ARGS are not accepted if REF is not specified.")
    endif()
  endif()

  if(CET_INSTALL_BIN OR CET_INSTALL_EXAMPLE OR CET_INSTALL_SOURCE)
    message(WARNING "Install of tests not supported in cetbuildtools2::cet_test")
  endif()
endfunction()

# - Checks test output for existance of specific assert()?
function(cet_test_assertion CONDITION FIRST_TARGET)
  if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set_tests_properties(${FIRST_TARGET} ${ARGN} PROPERTIES
      PASS_REGULAR_EXPRESSION
      "Assertion failed: \\(${CONDITION}\\), "
      )
  else()
    set_tests_properties(${FIRST_TARGET} ${ARGN} PROPERTIES
      PASS_REGULAR_EXPRESSION
      "Assertion `${CONDITION}' failed\\."
      )
  endif()
endfunction()

# - Build local catch main
# Scope the name with "PROJECT_NAME"
function(add_catch_main_library _target_name)
  if(NOT TARGET "${_target_name}")
    add_library(${_target_name} STATIC "${CET_CATCH_MAIN_SOURCE}")
    target_include_directories(${_target_name}
      PUBLIC "${CET_CATCH_INCLUDE_DIRS}"
      )
  endif()
endfunction()
