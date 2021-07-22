#include <system_providers/test_system_provider.h>

namespace TestSystem
{
    using namespace Vultr;
    Component &get_provider(Engine *e)
    {
        return *world_get_system_provider<Component>(e);
    }
} // namespace TestSystem
