#pragma once
#include <vultr.hpp>

struct TestWorld : public Scene
{
    void init(Vultr::Engine *e) override;
    void update(Vultr::Engine *e, const Vultr::UpdateTick &tick) override;
    void flush(Vultr::Engine *e) override;
};
