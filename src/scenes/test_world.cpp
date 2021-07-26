#include <vultr.hpp>
#include <helpers/file.h>
#include <scenes/test_world.h>
#include <systems/test_system.h>

using namespace Vultr;
void TestWorld::init(Vultr::Engine *e)
{
    TestSystem::register_system(e);
    auto entity = create_entity(get_current_world(e));
    entity_add_component(e, entity, TransformComponent::Create());
    entity_add_component<StaticMeshComponent>(e, entity, {.source = ModelSource("models/cube.obj")});
    entity_add_component<Vultr::MaterialComponent>(e, entity, ForwardMaterial::Create("textures/cube/diffuse.png", "textures/cube/specular.png"));
}

void TestWorld::update(Vultr::Engine *e, const Vultr::UpdateTick &tick)
{
    TestSystem::update(e, tick);
    printf("%f ms\n", tick.m_delta_time);
}

void TestWorld::flush(Vultr::Engine *e)
{
}
