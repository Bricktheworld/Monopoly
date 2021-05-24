#pragma once
#ifdef _WIN32
extern "C" __declspec(dllexport) void *init(void *engine);
extern "C" __declspec(dllexport) void flush(void *game);
#else
extern "C" void *init(void *engine);
extern "C" void flush(void *game);
#endif
