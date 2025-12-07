/// template variables are a c++14 language feature
template<class T>
constexpr T result = T(0);

int
main()
{
  return result<int>;
}
