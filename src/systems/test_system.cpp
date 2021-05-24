#include <systems/test_system.h>
#include <system_providers/test_system_provider.h>
#include <components/test_component.h>

namespace TestSystem
{
    using namespace Vultr;
    void register_system()
    {
        Signature signature;
        signature.set(get_component_type<CameraComponent>());
        signature.set(get_component_type<TransformComponent>());
        world_register_system<Component>(signature, on_create_entity, nullptr);
    }

    void update(const Vultr::UpdateTick &tick)
    {
        auto &provider = get_provider();
        for (auto entity : provider.entities)
        {
            auto &transform = entity_get_component<TransformComponent>(entity);
            transform.position.y += tick.m_delta_time;
        }
    }

    void on_create_entity(Entity entity)
    {
        std::cout << "Test system on create entity" << std::endl;
    }
} // namespace TestSystem
