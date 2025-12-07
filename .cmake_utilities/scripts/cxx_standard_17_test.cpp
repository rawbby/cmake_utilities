/// nested namespaces via :: are a c++17 language feature
namespace outer::inner {
constexpr int result = 0;
}

int
main()
{
  return outer::inner::result;
}
