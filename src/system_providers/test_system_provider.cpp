#include <system_providers/test_system_provider.h>

namespace TestSystem
{
    using namespace Vultr;
    Component &get_provider()
    {
        return *world_get_system_provider<Component>();
    }
} // namespace TestSystem
