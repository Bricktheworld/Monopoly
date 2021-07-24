#include <scenes/test_world.h>
#include <systems/test_system.h>

void TestWorld::init(Vultr::Engine *e)
{
    TestSystem::register_system(e);
}

void TestWorld::update(Vultr::Engine *e, const Vultr::UpdateTick &tick)
{
    TestSystem::update(e, tick);
    printf("%f ms\n", tick.m_delta_time);
}

void TestWorld::flush(Vultr::Engine *e)
{
}
