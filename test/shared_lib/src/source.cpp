#include "shared_lib_export.h"

#include <shared.h>
#include <shared_private.h>

SHARED_LIB_API void
shared_function_a()
{
}

SHARED_LIB_API void
shared_function_b()
{
  shared_function_a();
}

void
shared_function_d()
{
  shared_function_c();
}
