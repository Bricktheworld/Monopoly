#pragma once
#include <vultr.hpp>

class SandboxTest : public Game
{
  public:
    SandboxTest(void *p_engine);
    void RegisterComponents(Vultr::Engine *e) override;
    void Init(Vultr::Engine *e) override;
    void Update(Vultr::Engine *e, const Vultr::UpdateTick &tick) override;
    void Flush(Vultr::Engine *e) override;
    void SetImGuiContext(ImGuiContext *context) override;

  private:
    Vultr::Engine *engine;
};
