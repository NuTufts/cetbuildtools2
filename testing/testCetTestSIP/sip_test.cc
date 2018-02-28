#include <cstdlib>
#include <iostream>

int main() {
#ifdef __APPLE__
  const char* name = "DYLD_LIBRARY_PATH";
#else
  const char* name = "LD_LIBRARY_PATH";
#endif

  const char* ldPathValue = getenv(name);
  std::cout << ldPathValue << std::endl;

  return 0;
}
