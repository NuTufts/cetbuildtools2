#include <iostream>

#include "myversion.h"

// Test compile time
#if FOO_BAR_VERSION_MAJOR != 1
#error "testCetWriteCXXVersionAPI:compile_file FOO_BAR_VERSION_MAJOR != 1"
#endif

#if FOO_BAR_VERSION_MINOR != 2
#error "testCetWriteCXXVersionAPI:compile_file FOO_BAR_VERSION_MINOR != 2"
#endif

#if FOO_BAR_VERSION_PATCH != 3
#error "testCetWriteCXXVersionAPI:compile_file FOO_BAR_VERSION_PATCH != 3"
#endif

#if FOO_BAR_VERSION != 10203
#error "testCetWriteCXXVersionAPI:compile_file FOO_BAR_VERSION != 10203"
#endif

#if ! FOO_BAR_VERSION_IS_AT_LEAST(1, 2, 3)
#error "testCetWriteCXXVersionAPI:compile_file FOO_BAR_VERSION_IS_AT_LEAST fails for exact version"
#endif

#if ! FOO_BAR_VERSION_IS_AT_LEAST(1, 2, 2)
#error "testCetWriteCXXVersionAPI:compile_file FOO_BAR_VERSION_IS_AT_LEAST fails for lower version"
#endif

#if FOO_BAR_VERSION_IS_AT_LEAST(1, 2, 4)
#error "testCetWriteCXXVersionAPI:compile_file FOO_BAR_VERSION_IS_AT_LEAST succeeds for higher version"
#endif

int main(int argc, const char *argv[])
{
  int majorVersion = foo::bar::myversion::get_major();
  if(majorVersion != 1) {
    std::cerr << "get_major() returns incorrect value '" << majorVersion << "'" << std::endl;
    return 1;
  }

  int minorVersion = foo::bar::myversion::get_minor();
  if(minorVersion != 2) {
    std::cerr << "get_minor() returns incorrect value '" << minorVersion << "'" << std::endl;
    return 1;
  }

  int patchVersion = foo::bar::myversion::get_patch();
  if(patchVersion != 3) {
    std::cerr << "get_patch() returns incorrect value '" << patchVersion << "'" << std::endl;
    return 1;
  }

  std::string strVersion = foo::bar::myversion::get_version();
  if(strVersion != std::string("1.2.3")) {
    std::cerr << "get_version() returns incorrect value '" << strVersion << "'" << std::endl;
    return 1;
  }

  // Boolean interface
  if(! foo::bar::myversion::is_at_least(1,2,3)) {
    std::cerr << "is_at_least() returns false for exact version match" << std::endl;
    return 1;
  }

  if(! foo::bar::myversion::is_at_least(1,2,2)) {
    std::cerr << "is_at_least() returns false for lower input version" << std::endl;
    return 1;
  }

  if(foo::bar::myversion::is_at_least(1,2,4)) {
    std::cerr << "is_at_least() returns true for higher input version" << std::endl;
    return 1;
  }

  return 0;
}
