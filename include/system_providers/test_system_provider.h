#pragma once
#include <vultr.hpp>

namespace TestSystem
{
    VSYSTEM()
    struct Component : public Vultr::SystemProvider
    {
        VPROPERTY()
        double test_prop = 0.0;
    };

    Component &get_provider();

} // namespace TestSystem
