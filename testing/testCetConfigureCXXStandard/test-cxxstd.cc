#include <iostream>

int main() {
  if (__cplusplus == 201103L) {
    std::cout << "11\n";
  } else if (__cplusplus == 201402L) {
    std::cout << "14\n";
  } else if (__cplusplus > 201402L) {
    std::cout << "1z\n";
  } else {
    std::cout << "unsupported\n";
  }

  return 0;
}
