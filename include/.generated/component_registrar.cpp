// TODO generate this file
#include <component_registrar.h>
#include "../components/generated/test_component.generated.h"

using namespace Vultr;
void sandbox_register_components(void *e)
{
    register_component<TestComponent>(static_cast<Engine *>(e));
}
