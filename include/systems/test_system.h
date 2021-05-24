#pragma once
#include <vultr.hpp>

namespace TestSystem
{
    void register_system();
    void update(const Vultr::UpdateTick &tick);
    void on_create_entity(Vultr::Entity entity);
}; // namespace TestSystem
