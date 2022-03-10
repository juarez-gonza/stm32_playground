#include "Main.h"

#include <stddef.h>

double *mean(int *arr, size_t length) {
  long long sum = 0;

  for (size_t i = 0; i < length; ++i)
    sum += arr[i];

  double mean = (double)sum / length;
  return &mean;
}

void setup() {}
void loop() {}
