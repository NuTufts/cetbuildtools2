#include <iostream>

#include "tbb/tbb.h"

int main() {
  std::cout << "TBB_runtime_interface_version: " << tbb::TBB_runtime_interface_version() << std::endl;
  return 0;
}
