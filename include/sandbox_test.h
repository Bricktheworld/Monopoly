#pragma once
#include <vultr.hpp>

struct SandboxTest : public Game
{
    SandboxTest(void *p_engine);
    void register_components(Vultr::Engine *e) override;
    Scene *init_scene(Vultr::Engine *e, Vultr::World *world) override;
    void flush(Vultr::Engine *e) override;
    void set_imgui_context(ImGuiContext *context) override;
};
