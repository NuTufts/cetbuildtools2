cmake_minimum_required(VERSION 3.3)
project(testCetTest)

# Mock find/inclusion of cetbuildtools2
set(CMAKE_MODULE_PATH ${cetbuildtools2_MODULE_PATH})
include(CetCMakeSettings)
include(CetCompilerSettings)

# Mock setting of system dynamic loader path
set(_path "/dev/null:/should_not_exist")

if(APPLE)
  set(ENV{DYLD_LIBRARY_PATH} "${_path}")
else()
  set(ENV{LD_LIBRARY_PATH "${_path}")
endif()

include(CetTest)

# Expect that after inclusion, ENV{CETD_LIBRARY_PATH} equals _path
if(NOT ($ENV{CETD_LIBRARY_PATH} STREQUAL _path))
  message(FATAL_ERROR "CETD_LIBRARY_PATH not set correctly: x$ENV{CETD_LIBRARY_PATH}x != x${_path}x")
endif()

# Expect that CET_TEST_ENV is "CETD_LIBRARY_PATH=${_path}"
if(NOT (CET_TEST_ENV STREQUAL "CETD_LIBRARY_PATH=${_path}"))
  message(FATAL_ERROR "CET_TEST_ENV not set correctly: x${CET_TEST_ENV}x != xCETD_LIBRARY_PATH=${_path}x")
endif()

# A basic built executable should report the dynamic path
# identical to "${_path}:" as we have overidden the environment!
cet_test(sip_test TEST_PROPERTIES PASS_REGULAR_EXPRESSION "^${_path}\:")

# This should also work for a HANDBUILT executable
cet_test(sip_test_by_hand HANDBUILT TEST_EXEC $<TARGET_FILE:sip_test>)

# A PREBUILT script will fail on Darwin because whilst the cet_exec_test
# forwards the dynamic loader path, script takes us back to square one
# At present, we don't do anything other than confirm running. Check the
# printout to confirm behaviour
cet_test(sip_test_script.sh PREBUILT)

# We should be able to set the environment in the running executable
# Again just a check that things work.
cet_test(set_ldpath)

# Reinclusion should not reset env bar CETD_LIBRARY_PATH
include(CetTest)
if(NOT (CET_TEST_ENV STREQUAL "CETD_LIBRARY_PATH=${_path}"))
  message(FATAL_ERROR "CET_TEST_ENV not set correctly after reinclusion of CetTest: x${CET_TEST_ENV}x != xCETD_LIBRARY_PATH=${_path}x")
endif()

# Clearing should not reset env bar CETD_LIBRARY_PATH
cet_test_env(CLEAR)
if(NOT (CET_TEST_ENV STREQUAL "CETD_LIBRARY_PATH=${_path}"))
  message(FATAL_ERROR "CET_TEST_ENV not set correctly after cet_test_env(CLEAR): x${CET_TEST_ENV}x != xCETD_LIBRARY_PATH=${_path}x")
endif()

# Changing value should override it in test env
cet_test_env("CETD_LIBRARY_PATH=/foo/bar")
cet_test(sip_test_change_value HANDBUILT TEST_EXEC $<TARGET_FILE:sip_test> TEST_PROPERTIES PASS_REGULAR_EXPRESSION "^/foo/bar\:")

# Should be able to extend path via existing ENV
cet_test_env("CETD_LIBRARY_PATH=/baz:$ENV{CETD_LIBRARY_PATH}")
cet_test(sip_test_extend_value HANDBUILT TEST_EXEC $<TARGET_FILE:sip_test> TEST_PROPERTIES PASS_REGULAR_EXPRESSION "^/baz:${_path}\:")

# Clearing after use/extension should reset it back to base
cet_test_env(CLEAR)
if(NOT (CET_TEST_ENV STREQUAL "CETD_LIBRARY_PATH=${_path}"))
  message(FATAL_ERROR "CET_TEST_ENV not set correctly after cet_test_env(CLEAR) following extension: x${CET_TEST_ENV}x != xCETD_LIBRARY_PATH=${_path}x")
endif()

