#include <systems/test_system.h>
#include <system_providers/test_system_provider.h>
#include <components/test_component.h>

namespace TestSystem
{
    using namespace Vultr;
    void register_system(Vultr::Engine *e)
    {
        Signature signature;
        signature.set(get_component_type<CameraComponent>(e));
        signature.set(get_component_type<TransformComponent>(e));
        world_register_system<Component>(e, signature, on_create_entity, nullptr);
    }

    void update(Vultr::Engine *e, const Vultr::UpdateTick &tick)
    {
        auto &provider = get_provider(e);
        for (auto entity : provider.entities)
        {
            auto &transform = entity_get_component<TransformComponent>(e, entity);
            transform.position.y += tick.m_delta_time;
        }
    }

    void on_create_entity(Vultr::Engine *e, Entity entity)
    {
        std::cout << "Test system on create entity" << std::endl;
    }
} // namespace TestSystem
