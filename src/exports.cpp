#include <sandbox_test.h>
#include <exports.h>
#include <imgui/imgui.h>
void *init(void *engine)
{
    return static_cast<void *>(new SandboxTest(static_cast<Vultr::Engine *>(engine)));
}
void flush(void *game)
{
    delete (Game *)game;
}
