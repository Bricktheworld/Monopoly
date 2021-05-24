#include <sandbox_test.h>
#include <components/test_component.h>
#include <systems/test_system.h>
#include <component_registrar.h>

using namespace Vultr;
SandboxTest::SandboxTest(void *engine)
{
    this->engine = (Vultr::Engine*) engine;
    engine_global() = this->engine;
}
void SandboxTest::RegisterComponents()
{
    register_components();
}

void SandboxTest::Init()
{
    TestSystem::register_system();
}

void SandboxTest::Update(const Vultr::UpdateTick &tick)
{
    TestSystem::update(tick);
    printf("%f ms\n", tick.m_delta_time);
}

void SandboxTest::Flush()
{
}
void SandboxTest::SetImGuiContext(ImGuiContext *context)
{
    ImGui::SetCurrentContext(context);
}

