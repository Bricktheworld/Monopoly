#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
#extension GL_ARB_explicit_uniform_location : enable
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

uniform mat4 MVP;

void main()
{
    gl_Position = MVP * vec4(aPos, 1.0);
}


#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
layout (location = 0) out vec4 FragColor;

uniform vec4 u_Color;

void main()
{           
    FragColor = u_Color;
}
