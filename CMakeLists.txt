cmake_minimum_required(VERSION 3.0.0)
project(Game VERSION 0.1.0)

include(CTest)
enable_testing()

file(GLOB_RECURSE Game_SRC
    "src/*.cpp"
    "include/*.cpp"
)

include_directories(include vendor GameEngine/Vultr/include GameEngine/Vultr/vendor GameEngine/VTL/include)

if(WIN32)
    if (MSVC_VERSION GREATER_EQUAL "1900")
        include(CheckCXXCompilerFlag)
        CHECK_CXX_COMPILER_FLAG("/std:c++latest" _cpp_latest_flag_supported)
        if (_cpp_latest_flag_supported)
            add_compile_options("/std:c++latest")
        endif()
    endif()
endif(WIN32)

if(UNIX)
    set(CMAKE_CXX_STANDARD 17)
    add_library(Game SHARED ${Game_SRC})
    # add_executable(Game ${Game_SRC})
    target_precompile_headers(Game PRIVATE pch.h)
    target_link_libraries(Game GL glfw3 X11 Xxf86vm Xrandr pthread Xi dl assimp)
    target_link_libraries(Game debug ${CMAKE_CURRENT_SOURCE_DIR}/GameEngine/Vultr/build/libVultrShared.so)
endif(UNIX)

if(WIN32)
    find_library(VULTR Vultr HINTS ${CMAKE_CURRENT_SOURCE_DIR}/GameEngine/Vultr/out/build/x64-Debug)
    find_library(GLFW3 glfw3 HINTS ${CMAKE_CURRENT_SOURCE_DIR}/GameEngine/Vultr/vendor/libs/WIN32)
    find_library(FREETYPE freetyped HINTS ${CMAKE_CURRENT_SOURCE_DIR}/GameEngine/Vultr/vendor/libs/WIN32)
    find_library(ASSIMP assimp HINTS ${CMAKE_CURRENT_SOURCE_DIR}/GameEngine/Vultr/vendor/libs/WIN32)
    # add_executable(Game ${Game_SRC})
    add_library(Game SHARED ${Game_SRC})
    target_link_libraries(Game ${VULTR} ${GLFW3} ${FREETYPE} ${ASSIMP} opengl32)
endif(WIN32)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/res/" DESTINATION "bin/res")

include(InstallRequiredSystemLibraries)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ftime-trace")
# set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/License.txt")
# set(CPACK_PROJECT_NAME ${PROJECT_NAME})
# set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
# include(CPack)
