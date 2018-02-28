#include <cstdlib>
#include <string.h>
#include <iostream>

int main() {
#ifdef __APPLE__
  const char* name = "DYLD_LIBRARY_PATH";
#else
  const char* name = "LD_LIBRARY_PATH";
#endif

  const char* cetLDPathValue = getenv("CETD_LIBRARY_PATH");
  int res = setenv(name, cetLDPathValue, 1);

  if (res != 0) {
    std::cerr << "could not set " << name << std::endl;
    return 1;
  }

  const char* localLDPathValue = getenv(name);

  if(strcmp(localLDPathValue,cetLDPathValue) != 0) {
    return 1;
  }
  std::cout << localLDPathValue << std::endl;

  return 0;
}
