/// concepts are a c++20 language feature
template<typename T>
concept four_bytes = sizeof(T) == 4;

int
main()
{
  static_assert(four_bytes<int>);
  return 0;
}
