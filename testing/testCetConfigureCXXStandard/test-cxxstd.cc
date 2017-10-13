#include <iostream>

int main() {
  // These need review as are likely not accurate
  // across all compilers. For example, compiler
  // might partially support a standard, but not
  // mark __cplusplus with that epoch
  if (__cplusplus == 201103L) {
    std::cout << "11\n";
  }
  // Compilers may mark C++14 partial support with intermediate numbers
  else if ((__cplusplus > 201103L) && (__cplusplus <= 201402L)) {
    std::cout << "14\n";
  }
  // Anything greater than 14 should be partial or full C++17
  // Actual ISO value TBD
  else if (__cplusplus > 201402L) {
    std::cout << "17\n";
  } else {
    std::cout << "unsupported\n";
  }

  return 0;
}
