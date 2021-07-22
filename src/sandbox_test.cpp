#include <sandbox_test.h>
#include <components/test_component.h>
#include <systems/test_system.h>
#include <component_registrar.h>

using namespace Vultr;
SandboxTest::SandboxTest(void *engine)
{
    this->engine = (Vultr::Engine *)engine;
}
void SandboxTest::RegisterComponents(Vultr::Engine *e)
{
    register_components(e);
}

void SandboxTest::Init(Vultr::Engine *e)
{
    TestSystem::register_system(e);
}

void SandboxTest::Update(Vultr::Engine *e, const Vultr::UpdateTick &tick)
{
    TestSystem::update(e, tick);
    printf("%f ms\n", tick.m_delta_time);
}

void SandboxTest::Flush(Vultr::Engine *e)
{
}

void SandboxTest::SetImGuiContext(ImGuiContext *context)
{
    ImGui::SetCurrentContext(context);
}
