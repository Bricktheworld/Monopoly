#include <sandbox_test.h>
#include <scenes/test_world.h>
#include <components/test_component.h>
#include <systems/test_system.h>
#include <component_registrar.h>

using namespace Vultr;
SandboxTest::SandboxTest(void *engine)
{
}

void SandboxTest::register_components(Vultr::Engine *e)
{
    sandbox_register_components(e);
}

Scene *SandboxTest::init_scene(Vultr::Engine *e, Vultr::World *world)
{
    auto *scene = new TestWorld();
    scene->init(e);
    return scene;
}

void SandboxTest::flush(Vultr::Engine *e)
{
}

void SandboxTest::set_imgui_context(ImGuiContext *context)
{
    ImGui::SetCurrentContext(context);
}
