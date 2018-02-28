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
#     cet_test(<target> [<options>] [<args>])
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
# NO_AUTO
#   Do not add the target to the auto test list.
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
# PARG_<label> <opt>[=] <args>+
#   Specify a permuted argument (multiple permitted with different
#   <label>). This allows the creation of multiple tests with arguments
#   from a set of permutations.
#
#   Labels must be unique, valid CMake identifiers. Duplicated labels
#   will cause an error.
#
#   If multiple PARG_XXX arguments are specified, then they are combined
#   linearly, with shorter permutation lists being repeated cyclically.
#
#   If the '=' is specified, then the argument lists for successive test
#   iterations will get <opt>=v1, <opt>=v2, etc., otherwise it will be
#   <opt> v1, <opt> v2, ...
#
#   Target names will have _<num> appended, where num is zero-padded to
#   give the same number of digits for each target within the set.
#
#   Permuted arguments will be placed before any specifed TEST_ARGS in
#   the order the PARG_<label> arguments were specified to cet_test().
#
#   There is no support for non-option argument toggling as yet, but
#   addition of such support should be straightforward should the use
#   case arise.
#
# REF <file
#
#  The standard output of the test will be captured and compared against
#  the specified reference file. It is an error to specify this
#  argument and either the PASS_REGULAR_EXPRESSION or
#  FAIL_REGULAR_EXPRESSION test properties to the TEST_PROPERTIES
#  argument: success is the logical AND of the exit code from execution
#  of the test as originally specified, and the success of the
#  filtering and subsequent comparison of the output (and optionally,
#  the error stream). Optionally, a second element may be specified
#  representing a reference for the error stream; otherwise, standard
#  error will be ignored.
#
#  If REF is specified, then OUTPUT_FILTERS may also be specified
#  (OUTPUT_FILTER and optionally OUTPUT_FILTER_ARGS will be accepted in
#  the alternative for historical reasons). OUTPUT_FILTER must be a
#  program which expects input on STDIN and puts the filtered output on
#  STDOUT. OUTPUT_FILTERS should be a list of filters expecting input
#  on STDIN and putting output on STDOUT. If DEFAULT is specified as a
#  filter, it will be replaced at that point in the list of filters by
#  appropriate defaults. Examples:
#
#    OUTPUT_FILTERS "filterA -x -y \"arg with spaces\"" filterB
#
#    OUTPUT_FILTERS filterA DEFAULT filterB
#
# REQUIRED_FILES <file>+
#   These files are required to be present before the test will be
#   executed. If any are missing, ctest will record NOT RUN for this
#   test.
#
# *SAN_OPTIONS (NOT IMPLEMENTED YET)
#
#   Option representing the desired value of the corresponding sanitizer
#   control environment variable for the test.
#
# SCOPED
#   Test target (but not PREBUILT not HANDBUILT executable) names will
#   be scoped by project name (<PROJECT_NAME>:...)
#
# SOURCE[S] <file>+
#   Sources to use to build the target (default is ${target}.cc).
#
# TEST_ARGS <arg>+
#   Any arguments to the test to be run.
#
# TEST_EXEC <program>
#   The executable to run (if not the target). The HANDBUILT option must
#   be specified in conjunction with this option. It should be supplied
#   as a full path to the executable or cet_test will fall back to the PATH
#   environment to find it. Generator expressions may be used, e.g. $<TARGET_FILE:name>.
#
# TEST_PROPERTIES <PROPERTY value>+
#   Properties to be added to the test. See documentation of the cmake
#   command, "set_tests_properties."
#
# Cache variables
#
# CET_DEFINED_TEST_GROUPS
#   Any test group names CMake sees will be added to this list.
#
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
#   .. code-block:: cmake
#
#     cet_test_env([CLEAR] [<env>])
#
# Configure environment in which all subsequently defined tests will run.
# If ``<env>`` is set to a list of environment variables and values in the form ``MYVAR=value``
# those environment variables will be defined while running the test.
#
# The set environment is propagated to all subsequent tests, including
# subdirectories of the call location. The currently defined environment
# can be reset using the ``CLEAR`` option, or by ``include(CetTest)``.
#
# If test-specific environment settings are required, the ``TEST_PROPERTIES``
# argument to ``cet_test`` should be preferred, using the CTest ``ENVIRONMENT``
# property. For example:
#
# .. code-block:: cmake
#
#   cet_test(MyTest TEST_PROPERTIES ENVIRONMENT "A=one;B=two")
#
# Note that System Integrity Protection on macOS will
# `strip certain variables from the environment <https://developer.apple.com/library/content/documentation/Security/Conceptual/System_Integrity_Protection_Guide/RuntimeProtections/RuntimeProtections.html>`_
# when the test is launched as a child process of a SIP-protected process.
# In particular, ``DYLD_LIBRARY_PATH`` is stripped and this may affect the running
# of tests that rely on this (such as plugins loaded at runtime).
#
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
#   cet_test() or add_test(). At least one name must be supplied.
#

#-----------------------------------------------------------------------
# Modifications Copyright 2015-2018 Ben Morgan <Ben.Morgan@warwick.ac.uk
# Modifications Copyright 2015-2018 University of Warwick
#
# Distributed under the OSI-approved BSD 3-Clause License (the "License");
# see accompanying file LICENSE for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#-----------------------------------------------------------------------

# No include guard, as it's intended that CetTest may be included
# multiple times (e.g. clear env?)

include(CMakeParseArguments)
include(CetCMakeUtilities)
include(CetCopy)
include(CetMake)

#-----------------------------------------------------------------------
# Global Data
#-----------------------------------------------------------------------
# Module Know Thine Self
set(CET_TEST_MODULE_DIR "${CMAKE_CURRENT_LIST_DIR}")

# Our vendored (for now) catch source
set(CET_CATCH_MAIN_SOURCE "${CMAKE_CURRENT_LIST_DIR}/catch/cet_catch_main.cpp")
set(CET_CATCH_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}")

# - Internal Programs and Modules
# Default Comparator
set(CET_RUNANDCOMPARE "${CET_TEST_MODULE_DIR}/RunAndCompare.cmake")

# Test wrapper/driver
set(CET_CET_EXEC_TEST "${CET_TEST_MODULE_DIR}/cet_exec_test")

# - Test Environment
# Cache (DY)LD_LIBRARY_PATH on first run to avoid blanking
# path if re-cmakes run in SIP process. See also the shim
# section in `cet_test_exec`
# This means that the dynamic loader path *cannot* be changed
# post-configuration, but in general we won't to do that anyway...
if(NOT DEFINED __CETD_LIBRARY_PATH)
  # System-actual path name
  set(__CETD_LIBRARY_PATH_NAME "LD_LIBRARY_PATH")
  if(APPLE)
    set(__CETD_LIBRARY_PATH_NAME "DYLD_LIBRARY_PATH")
  endif()

  set(__CETD_LIBRARY_PATH "$ENV{${__CETD_LIBRARY_PATH_NAME}}"
    CACHE INTERNAL "Initial CMake-time Dynamic Loader Path"
    FORCE)
endif()
# Set internal, non-SIP, dynamic loader path for passthrough to
# tests. Note this is only set in the *CMake Process*, so can
# be accessed via $ENV{CETD_LIBRARY_PATH} after inclusion
# of CetTest
set(ENV{CETD_LIBRARY_PATH} ${__CETD_LIBRARY_PATH})

# Global environment to run every test in
# We always add in the passthrough dynamic loader path
# because it must be present for all tests always.
set(CET_TEST_ENV "CETD_LIBRARY_PATH=$ENV{CETD_LIBRARY_PATH}"
  CACHE INTERNAL "Environment to add to every test"
  FORCE
  )

#-----------------------------------------------------------------------
# CetTest Public API
#-----------------------------------------------------------------------
macro(cet_test_env)
  cmake_parse_arguments(CET_TEST
    "CLEAR"
    ""
    ""
    ${ARGN}
    )

  if(CET_TEST_CLEAR)
    # Retain dynamic loader passthrough
    set(CET_TEST_ENV "CETD_LIBRARY_PATH=$ENV{CETD_LIBRARY_PATH}")
  endif()
  list(APPEND CET_TEST_ENV ${CET_TEST_UNPARSED_ARGUMENTS})
endmacro()

#-----------------------------------------------------------------------
# function: cet_test
#-----------------------------------------------------------------------
function(cet_test CET_TARGET)
  # Parse arguments
  if(${CET_TARGET} MATCHES .*/.*)
    message(FATAL_ERROR "${CET_TARGET} should not be a path. Use a simple "
      "target name with the HANDBUILT and TEST_EXEC options instead.")
  endif()

  cmake_parse_arguments(CET
    "HANDBUILT;PREBUILT;USE_CATCH_MAIN;NO_AUTO;USE_BOOST_UNIT;INSTALL_BIN;INSTALL_EXAMPLE;INSTALL_SOURCE;NO_OPTIONAL_GROUPS;SCOPED"
    "OUTPUT_FILTER;TEST_EXEC;TEST_WORKDIR"
    "CONFIGURATIONS;DATAFILES;DEPENDENCIES;LIBRARIES;OPTIONAL_GROUPS;OUTPUT_FILTERS;OUTPUT_FILTER_ARGS;REQUIRED_FILES;SOURCE;SOURCES;TEST_ARGS;TEST_PROPERTIES;REF"
    ${ARGN}
    )

  # - Check for mutually exclusive arguments
  # 1. Refs and Filters
  if(CET_OUTPUT_FILTERS AND CET_OUTPUT_FILTER_ARGS)
    message(FATAL_ERROR "OUTPUT_FILTERS is incompatible with FILTER_ARGS:\nEither use the singular OUTPUT_FILTER or use double-quoted strings in OUTPUT_FILTERS\nE.g. OUTPUT_FILTERS \"filter1 -x -y\" \"filter2 -y -z\"")
  endif()

  if((CET_OUTPUT_FILTER OR CET_OUTPUT_FILTER_ARGS) AND NOT CET_REF)
    message(FATAL_ERROR "OUTPUT_FILTER and OUTPUT_FILTER_ARGS are not accepted if REF is not specified.")
  endif()

  # 2. Specification of executable
  if(CET_TEST_EXEC AND NOT CET_HANDBUILT)
    message(FATAL_ERROR "cet_test: ${CET_TARGET} cannot specify TEST_EXEC without HANDBUILT option")
  endif()

  if((CET_HANDBUILT AND CET_PREBUILT) OR
     (CET_HANDBUILT AND CET_USE_CATCH_MAIN) OR
     (CET_PREBUILT AND CET_USE_CATCH_MAIN))
    message(FATAL_ERROR "cet_test: ${CET_TARGET} must have only one of the HANDBUILT, PREBUILT, or USE_CATCH_MAIN options set.")
  endif()

  # 3. Testing framework
  if(CET_USE_CATCH_MAIN AND CET_USE_BOOST_UNIT)
    message(FATAL_ERROR "cet_test: ${CET_TARGET} must only use one of USE_CATCH_MAIN and USE_BOOST_UNIT")
  endif()

  # 4. Handle NO_AUTO additional args
  if(CET_NO_AUTO)
    if(CET_CONFIGURATIONS OR CET_DATAFILES OR CET_NO_OPTIONAL_GROUPS OR
       CET_OPTIONAL_GROUPS OR CET_OUTPUT_FILTER OR CET_OUTPUT_FILTERS OR
       CET_OUTPUT_FILTER_ARGS OR CET_REF OR CET_REQUIRED_FILES OR
       CET_SCOPED OR CET_TEST_ARGS OR CET_TEST_PROPERTIES OR
       CET_TEST_WORKDIR OR NPARG_LABELS)
      message(FATAL_ERROR "The following arguments are not meaningful in the presence of NO_AUTO:
CONFIGURATIONS DATAFILES NO_OPTIONAL_GROUPS_OPTIONAL_GROUPS OUTPUT_FILTER OUTPUT_FILTERS OUTPUT_FILTER_ARGS PARG_<label> REF REQUIRED_FILES SCOPED TEST_ARGS TEST_PROPERTIES TEST_WORKDIR")
    endif()
  endif()

  # 5. Warnings on non-supported args
  if(CET_INSTALL_BIN)
    message(WARNING "cet_test: test executables should use install(TARGETS ...) directly if installation is required")
  endif()

  if(CET_INSTALL_EXAMPLE OR CET_INSTALL_SOURCE)
    message(WARNING "cet_test: test source(s)/datafiles should use install(FILES ..) directly if installation is required")
  endif()

  # - Manage Permuted arguments
  foreach (OPT ${CET_UNPARSED_ARGUMENTS})
    if (OPT MATCHES "^PARG_([A-Za-z_][A-Za-z0-9_]*)$")
      if (OPT IN_LIST parg_option_names)
        message(FATAL_ERROR "For test ${TEST_TARGET_NAME}, permuted argument label ${CMAKE_MATCH_1} specified multiple times.")
      endif()
      list(APPEND parg_option_names ${OPT})
      list(APPEND parg_labels ${CMAKE_MATCH_1})
    elseif (OPT MATCHES "SAN_OPTIONS$")
      if (OPT IN_LIST san_option_names)
        message(FATAL_ERROR "For test ${TEST_TARGET_NAME}, ${OPT} specified multiple times")
      endif()
      list(APPEND san_option_names ${OPT})
    endif()
  endforeach()

  set(cetp_list_options PERMUTE_OPTS ${parg_option_names})
  set(cetp_onearg_options PERMUTE ${san_option_names})
  cmake_parse_arguments(CETP ""
    "${cetp_onearg_options}"
    "${cetp_list_options}"
    "${CET_UNPARSED_ARGUMENTS}")
  if (CETP_PERMUTE)
    message(FATAL_ERROR "PERMUTE is a keyword reserved for future functionality.")
  elseif (CETP_PERMUTE_OPTS)
    message(FATAL_ERROR "PERMUTE_OPTS is a keyword reserved for future functionality.")
  endif()
  list(LENGTH parg_labels NPARG_LABELS)
  _cet_process_pargs(NTESTS "${parg_labels}")
  if (CETP_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "cet_test: Unparsed (non-option) arguments detected: \"${CETP_UNPARSED_ARGUMENTS}.\" Check for missing keyword(s) in the definition of test ${CET_TARGET} in your CMakeLists.txt.")
  endif()

  # - Determine how to build/run test

  # HANDBUILT case provides default
  if(CET_PREBUILT)
    cet_script(${CET_TARGET} NO_INSTALL DEPENDENCIES ${CET_DEPENDENCIES})
    # *Don't* rely on PATH setting, run exactly what we want
    set(CET_TEST_EXEC "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${CET_TARGET}")
  elseif(NOT CET_HANDBUILT)
    # We will build the executable
    # CET_SOURCES is obsolete, adapt args.
    if(CET_SOURCES)
      list(APPEND CET_SOURCE ${CET_SOURCES})
      unset(CET_SOURCES)
    endif()

    if(NOT CET_SOURCE)
      set(CET_SOURCE ${CET_TARGET}.cc)
    endif()

    # Define build of exe, and use a genex to use it, and only it, is run.
    add_executable(${CET_TARGET} ${CET_SOURCE})
    set(CET_TEST_EXEC $<TARGET_FILE:${CET_TARGET}>)

    # Link as a Catch/Boost test exe
    if(CET_USE_CATCH_MAIN)
      add_catch_main_library(${PROJECT_NAME}_catch_main)
      target_link_libraries("${CET_TARGET}" PRIVATE ${PROJECT_NAME}_catch_main)
    elseif(CET_USE_BOOST_UNIT)
      set_boost_unit_properties(${CET_TARGET})
    endif()

    # Link any additional libraries
    if(CET_LIBRARIES)
      target_link_libraries(${CET_TARGET} PRIVATE ${CET_LIBRARIES})
    endif()

    # Apply TBB offload if available
    set_tbb_offload_properties(${CET_TARGET})
  endif()

  # - If NO_AUTO isn't specified, add an actual CTest (i.e. add_test)
  if(NOT CET_NO_AUTO)
    set(TEST_TARGET_NAME "${CET_TARGET}")
    if(CET_SCOPED)
      set(TEST_TARGET_NAME "${PROJECT_NAME}:${CET_TARGET}")
    endif()

    # For which configurations should this test (set) be valid?
    if(CET_CONFIGURATIONS)
      set(CONFIGURATIONS_CMD CONFIGURATIONS)
    endif()

    # Print configured permuted arguments.
    _cet_print_pargs("${parg_labels}")

    # Set up to handle a per-test work directory for parallel testing.
    if(NOT CET_TEST_WORKDIR)
      set(CET_TEST_WORKDIR "${CMAKE_CURRENT_BINARY_DIR}/${CET_TARGET}.d")
    endif()
    file(MAKE_DIRECTORY "${CET_TEST_WORKDIR}")

    # Deal with specified data files.
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

    list(FIND CET_TEST_PROPERTIES SKIP_RETURN_CODE skip_return_code)
    if(skip_return_code GREATER -1)
      math(EXPR skip_return_code "${skip_return_code} + 1")
      list(GET CET_TEST_PROPERTIES ${skip_return_code} skip_return_code)
    else()
      set(skip_return_code 247)
      list(APPEND CET_TEST_PROPERTIES SKIP_RETURN_CODE ${skip_return_code})
    endif()

    # - Configure Test References
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
      _cet_add_ref_test(${CET_TEST_ARGS})
    else()
      _cet_add_test(${CET_TEST_ARGS})
    endif()

    if(NOT (CET_OPTIONAL_GROUPS OR CET_NO_OPTIONAL_GROUPS))
      set(CET_OPTIONAL_GROUPS DEFAULT RELEASE)
    endif()

    if(NTESTS GREATER 1)
      list(APPEND CET_OPTIONAL_GROUPS ${TEST_TARGET_NAME})
    endif()

    _update_defined_test_groups(${CET_OPTIONAL_GROUPS})

    set_tests_properties(${ALL_TEST_TARGETS} PROPERTIES LABELS "${CET_OPTIONAL_GROUPS}")

    if(CET_TEST_PROPERTIES)
      set_tests_properties(${ALL_TEST_TARGETS} PROPERTIES ${CET_TEST_PROPERTIES})
    endif()

    # Sanitizer - needs support in CetCompilerSettings
    #if(CETB_SANITIZER_PRELOADS)
    #  set_property(TEST ${ALL_TEST_TARGETS} APPEND PROPERTY
    #    ENVIRONMENT "LD_PRELOAD=$ENV{LD_PRELOAD} ${CETB_SANITIZER_PRELOADS}")
    #endif()

    #foreach(san_env
    #    ASAN_OPTIONS MSAN_OPTIONS LSAN_OPTIONS TSAN_OPTIONS UBSAN_OPTIONS)
    #  if(CETP_${san_env})
    #    set_property(TEST ${ALL_TEST_TARGETS} APPEND PROPERTY
    #      ENVIRONMENT "${san_env}=${CETP_${san_env}}")
    #  elseif(DEFINED ENV{${san_env}})
    #    set_property(TEST ${ALL_TEST_TARGETS} APPEND PROPERTY
    #      ENVIRONMENT "${san_env}=$ENV{${san_env}}")
    #  endif()
    #endforeach()

    foreach(target ${ALL_TEST_TARGETS})
      if(CET_TEST_ENV)
        # Prepend global environment.
        get_test_property(${target} ENVIRONMENT CET_TEST_ENV_TMP)
        if(CET_TEST_ENV_TMP)
          set_tests_properties(${target} PROPERTIES
            ENVIRONMENT "${CET_TEST_ENV};${CET_TEST_ENV_TMP}")
        else()
          set_tests_properties(${target} PROPERTIES
            ENVIRONMENT "${CET_TEST_ENV}")
        endif()
      endif()

      if(CET_REF)
        get_test_property(${target} REQUIRED_FILES REQUIRED_FILES_TMP)
        if(REQUIRED_FILES_TMP)
          set_tests_properties(${target} PROPERTIES REQUIRED_FILES "${REQUIRED_FILES_TMP};${CET_REF}")
        else()
          set_tests_properties(${target} PROPERTIES REQUIRED_FILES "${CET_REF}")
        endif()
      endif()
    endforeach()
  endif()
endfunction()


# - Checks test output for existance of specific assert()
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
function(add_catch_main_library _target_name)
  if(NOT TARGET "${_target_name}")
    add_library(${_target_name} STATIC "${CET_CATCH_MAIN_SOURCE}")
    target_include_directories(${_target_name}
      PUBLIC "${CET_CATCH_INCLUDE_DIRS}"
      )
    # Always strip to minimize space (we don't need to debug catch!)
    add_custom_command(TARGET ${_target_name}
      POST_BUILD COMMAND strip -S $<TARGET_FILE:${_target_name}>
      )
  endif()
endfunction()


#-----------------------------------------------------------------------
# CetTest Private API
#-----------------------------------------------------------------------
# - DESCRIPTION GOES HERE
function(_update_defined_test_groups)
  set(TMP_LIST ${CET_DEFINED_TEST_GROUPS} ${ARGN})
  list(REMOVE_DUPLICATES TMP_LIST)
  set(CET_DEFINED_TEST_GROUPS ${TMP_LIST}
    CACHE STRING "List of defined test groups."
    FORCE
    )
endfunction()

# - DESCRIPTION GOES HERE
function(_cet_process_pargs NTEST_VAR)
  set(NTESTS 1)
  foreach (label ${ARGN})
    list(LENGTH CETP_PARG_${label} ${label}_length)
    math(EXPR ${label}_length "${${label}_length} - 1")
    if (NOT ${label}_length)
      message(FATAL_ERROR "For test ${TEST_TARGET_NAME}: Permuted options are not yet supported.")
    endif()
    if (${label}_length GREATER NTESTS)
      set(NTESTS ${${label}_length})
    endif()
    list(GET CETP_PARG_${label} 0 ${label}_arg)
    set(${label}_arg ${${label}_arg} PARENT_SCOPE)
    list(REMOVE_AT CETP_PARG_${label} 0)
    set(CETP_PARG_${label} ${CETP_PARG_${label}} PARENT_SCOPE)
    set(${label}_length ${${label}_length} PARENT_SCOPE)
  endforeach()
  foreach (label ${ARGN})
    if (${label}_length LESS NTESTS)
      # Need to pad
      math(EXPR nextra "${NTESTS} - ${${label}_length}")
      set(nind 0)
      while (nextra)
        math(EXPR lind "${nind} % ${${label}_length}")
        list(GET CETP_PARG_${label} ${lind} item)
        list(APPEND CETP_PARG_${label} ${item})
        math(EXPR nextra "${nextra} - 1")
        math(EXPR nind "${nind} + 1")
      endwhile()
      set(CETP_PARG_${label} ${CETP_PARG_${label}} PARENT_SCOPE)
    endif()
  endforeach()
  set(${NTEST_VAR} ${NTESTS} PARENT_SCOPE)
endfunction()

# - DESCRIPTION GOES HERE
function(_cet_print_pargs)
  string(TOUPPER "${CMAKE_BUILD_TYPE}" BTYPE_UC)
  if (NOT BTYPE_UC STREQUAL "DEBUG")
    return()
  endif()
  list(LENGTH ARGN nlabels)
  if (NOT nlabels)
    return()
  endif()
  message(STATUS "Test ${TEST_TARGET_NAME}: found ${nlabels} labels for permuted test arguments")
  foreach (label ${ARGN})
    message(STATUS "  Label: ${label}, arg: ${${label}_arg}, # vals: ${${label}_length}, vals: ${CETP_PARG_${label}}")
  endforeach()
  message(STATUS "  Calculated ${NTESTS} tests")
endfunction()

# - DESCRIPTION GOES HERE
# NB: A function, but takes variables from calling scope
function(_cet_test_pargs VAR)
  foreach (label ${parg_labels})
    list(GET CETP_PARG_${label} ${tid} arg)
    if (${label}_arg MATCHES "=\$")
      list(APPEND test_args "${${label}_arg}${arg}")
    else()
      list(APPEND test_args ${${label}_arg} ${arg})
    endif()
  endforeach()
  set(${VAR} ${test_args} ${ARGN} PARENT_SCOPE)
endfunction()

# - DESCRIPTION GOES HERE
# NB: A function, but takes variables from calling scope
function(_cet_add_test_detail TNAME TEST_WORKDIR)
  _cet_test_pargs(test_args ${ARGN})
  add_test(NAME "${TNAME}"
    ${CONFIGURATIONS_CMD} ${CET_CONFIGURATIONS}
    COMMAND
    ${CET_CET_EXEC_TEST} --wd ${TEST_WORKDIR}
    --required-files "${CET_REQUIRED_FILES}"
    --datafiles "${CET_DATAFILES}"
    --skip-return-code ${skip_return_code}
    ${CET_TEST_EXEC} ${test_args})
endfunction()

# - DESCRIPTION GOES HERE
# NB: A function, but takes variables from calling scope
function(_cet_add_test)
  if (${NTESTS} EQUAL 1)
    _cet_add_test_detail(${TEST_TARGET_NAME} ${CET_TEST_WORKDIR} ${ARGN})
    list(APPEND ALL_TEST_TARGETS ${TEST_TARGET_NAME})
    file(MAKE_DIRECTORY "${CET_TEST_WORKDIR}")
    set_tests_properties(${TEST_TARGET_NAME} PROPERTIES WORKING_DIRECTORY ${CET_TEST_WORKDIR})
    cet_copy(${CET_DATAFILES} DESTINATION ${CET_TEST_WORKDIR} WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
  else()
    math(EXPR tidmax "${NTESTS} - 1")
    string(LENGTH "${tidmax}" nd)
    foreach (tid RANGE ${tidmax})
      execute_process(COMMAND printf "_%0${nd}d" ${tid}
        OUTPUT_VARIABLE tnum
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
      set(tname "${TEST_TARGET_NAME}${tnum}")
      string(REGEX REPLACE "\\.d\$" "${tnum}.d" test_workdir "${CET_TEST_WORKDIR}")
      _cet_add_test_detail(${tname} ${test_workdir} ${ARGN})
      list(APPEND ALL_TEST_TARGETS ${tname})
      file(MAKE_DIRECTORY "${test_workdir}")
      set_tests_properties(${tname} PROPERTIES WORKING_DIRECTORY ${test_workdir})
      cet_copy(${CET_DATAFILES} DESTINATION ${test_workdir} WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endforeach()
  endif()
  set(ALL_TEST_TARGETS ${ALL_TEST_TARGETS} PARENT_SCOPE)
endfunction()

# - DESCRIPTION GOES HERE
# NB: A function, but takes variables from calling scope
function(_cet_add_ref_test_detail TNAME TEST_WORKDIR)
  _cet_test_pargs(tmp_args ${ARGN})
  separate_arguments(test_args UNIX_COMMAND "${tmp_args}")
  add_test(NAME "${TNAME}"
    ${CONFIGURATIONS_CMD} ${CET_CONFIGURATIONS}
    COMMAND ${CET_CET_EXEC_TEST} --wd ${TEST_WORKDIR}
    --required-files "${CET_REQUIRED_FILES}"
    --datafiles "${CET_DATAFILES}"
    --skip-return-code ${skip_return_code}
    ${CMAKE_COMMAND}
    -DTEST_EXEC=${CET_TEST_EXEC}
    -DTEST_ARGS=${test_args}
    -DTEST_REF=${OUTPUT_REF}
    ${DEFINE_ERROR_REF}
    ${DEFINE_TEST_ERR}
    -DTEST_OUT=${CET_TARGET}.out
    ${DEFINE_OUTPUT_FILTER} ${DEFINE_OUTPUT_FILTER_ARGS} ${DEFINE_OUTPUT_FILTERS}
    ${DEFINE_ART_COMPAT}
    -P ${CET_RUNANDCOMPARE}
    )
endfunction()

# - DESCRIPTION GOES HERE
function(_cet_add_ref_test)
  if (${NTESTS} EQUAL 1)
    _cet_add_ref_test_detail(${TEST_TARGET_NAME} ${CET_TEST_WORKDIR} ${ARGN})
    list(APPEND ALL_TEST_TARGETS ${TEST_TARGET_NAME})
    file(MAKE_DIRECTORY "${CET_TEST_WORKDIR}")
    set_tests_properties(${TEST_TARGET_NAME} PROPERTIES WORKING_DIRECTORY ${CET_TEST_WORKDIR})
    cet_copy(${CET_DATAFILES} DESTINATION ${CET_TEST_WORKDIR} WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
  else()
    math(EXPR tidmax "${NTESTS} - 1")
    string(LENGTH "${tidmax}" nd)
    foreach (tid RANGE ${tidmax})
      execute_process(COMMAND printf "_%0${nd}d" ${tid}
        OUTPUT_VARIABLE tnum
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
      set(tname "${TEST_TARGET_NAME}${tnum}")
      string(REGEX REPLACE "\\.d\$" "${tnum}.d" test_workdir "${CET_TEST_WORKDIR}")
      _cet_add_ref_test_detail(${tname} ${test_workdir} ${ARGN})
      list(APPEND ALL_TEST_TARGETS ${tname})
      file(MAKE_DIRECTORY "${test_workdir}")
      set_tests_properties(${tname} PROPERTIES WORKING_DIRECTORY ${test_workdir})
      cet_copy(${CET_DATAFILES} DESTINATION ${test_workdir} WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    endforeach()
  endif()
  set(ALL_TEST_TARGETS ${ALL_TEST_TARGETS} PARENT_SCOPE)
endfunction()


