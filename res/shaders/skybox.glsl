#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

layout (location = 0) in vec3 position;

out vec3 TexCoords;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

void main() 
{
    TexCoords = position;
    vec4 pos = projection * view * vec4(position, 1.0);
    gl_Position = pos;
}

#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

in vec3 TexCoords;

out vec4 color;

uniform samplerCube skybox;

void main()
{
    color = texture(skybox, TexCoords);
}
