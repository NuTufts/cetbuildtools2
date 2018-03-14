# - Mock project name
set(PROJECT_NAME "TestCetUPS")

include(CetUPS)

# test the parts that don't need a compiler
#-----------------------------------------------------------------------
# versions: semantic and ups
set(_version_tests
  "1.2.3=v1_02_03"
  )

#-----------------------------------------------------------------------
# Flavor
# Simple translation check...

#-----------------------------------------------------------------------
# Remainder require use of the testUPSInstallDirs project to so
# compilers and build modes can be tested.

# Mark as TODO
message(FATAL_ERROR "TOBEIMPLEMENTED")
