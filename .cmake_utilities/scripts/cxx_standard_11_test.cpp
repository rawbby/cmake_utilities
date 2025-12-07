/// constexpr functions are a c++11 language feature
constexpr unsigned
five()
{
  return 5u;
}

int
main()
{
  int const four[five()]{ 1, 1, 1, 1, 0 };
  return four[4];
}
