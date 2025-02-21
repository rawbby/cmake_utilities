module;

#include <ostream>

module hello;

namespace hello {

void
say(std::ostream& os)
{
  os << "hello!\n";
}

}
