#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
#extension GL_ARB_explicit_uniform_location : enable
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;
layout (location = 3) in vec3 v_Tangent;
layout (location = 4) in vec3 v_Bitangent;

layout (std140) uniform Camera {
    vec4 position;
    mat4 view_matrix;
    mat4 projection_matrix;
    float bloom_threshold;
} ub_Camera;

uniform mat4 u_MVP;
uniform mat4 u_Model_matrix;
uniform vec4 u_Color;
uniform float u_Emission = 1.0;

layout (location = 0) out vec4 f_Color;
layout (location = 1) out vec4 f_Bright_color;

void main()
{
    gl_Position = u_MVP * vec4(aPos, 1.0);


    // We do color calculations in here for performance reasons
    vec4 color = u_Color * u_Emission;

    f_Color = color;
    float brightness = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    if(brightness > ub_Camera.bloom_threshold)
	f_Bright_color = color;
    else
        f_Bright_color = vec4(0.0, 0.0, 0.0, 1.0);
}


#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
layout (location = 0) out vec4 color;
layout (location = 1) out vec4 bright_color;

layout (location = 0) in vec4 f_Color;
layout (location = 1) in vec4 f_Bright_color;

void main()
{           
    color = f_Color;
    bright_color = f_Bright_color;
}
