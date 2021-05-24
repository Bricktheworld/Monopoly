#pragma once
#include <vultr.hpp>

class SandboxTest : public Game
{
  public:
    SandboxTest(void *p_engine);
    void RegisterComponents() override;
    void Init() override;
    void Update(const Vultr::UpdateTick &tick) override;
    void Flush() override;
    void SetImGuiContext(ImGuiContext *context) override;


  private:
    Vultr::Engine *engine;
};
