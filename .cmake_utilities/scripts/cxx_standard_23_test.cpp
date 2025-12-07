consteval int
f(int i)
{
  return i;
}

/// if consteval is a c++23 language feature
constexpr int
g(int i)
{
  if consteval {
    return f(i) - 1;
  }
  return 1;
}

int
main()
{
  constexpr int result = g(1);
  return result;
}
