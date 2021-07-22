#pragma once
#include <vultr.hpp>

namespace TestSystem
{
    void register_system(Vultr::Engine *e);
    void update(Vultr::Engine *e, const Vultr::UpdateTick &tick);
    void on_create_entity(Vultr::Engine *e, Vultr::Entity entity);
}; // namespace TestSystem
