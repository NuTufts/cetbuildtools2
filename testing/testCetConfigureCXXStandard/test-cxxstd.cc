#include <iostream>

int main() {
  // These need review as are likely not accurate
  // across all compilers. For example, compiler
  // might partially support a standard, but not
  // mark __cplusplus with that epoch
  if (__cplusplus == 201103L) {
    std::cout << "11\n";
  } else if (__cplusplus == 201402L) {
    std::cout << "14\n";
  } else if (__cplusplus > 201402L) {
    std::cout << "17\n";
  } else {
    std::cout << "unsupported\n";
  }

  return 0;
}
