#include <shared.h>
#include <shared_private.h>

void shared_function_a() {}

void shared_function_b() { shared_function_a(); }

void shared_function_d() { shared_function_c(); }
