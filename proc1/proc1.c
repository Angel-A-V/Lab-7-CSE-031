#include <stdio.h>

int SUM(int a, int b) {
    return a + b; // Function equivalent to the SUM label
}

int main() {
    int m = 10, n = 5; // Variables equivalent to m and n in the .data section
    int result = SUM(m, n); // Call the SUM function
    printf("%d\n", result); // Print the result
    return 0;
}
