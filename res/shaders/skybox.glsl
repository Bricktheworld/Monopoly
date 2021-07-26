#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
#extension GL_ARB_explicit_uniform_location : enable

layout (location = 0) in vec3 position;

out vec3 TexCoords;

layout (location = 0) uniform mat4 VP;
layout (location = 1) uniform mat4 model;

void main() 
{
    TexCoords = position;
    vec4 pos = VP * vec4(position, 1.0);
    gl_Position = pos;
}

#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
#extension GL_ARB_explicit_uniform_location : enable

in vec3 TexCoords;

out vec4 color;

layout (location = 2) uniform samplerCube skybox;

void main()
{
    color = texture(skybox, TexCoords);
}
