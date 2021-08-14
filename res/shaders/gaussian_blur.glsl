#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
layout (location = 0) in vec3 v_Position;
layout (location = 1) in vec3 v_Normal;
layout (location = 2) in vec2 v_UV;
layout (location = 3) in vec3 v_Tangent;
layout (location = 4) in vec3 v_Bitangent;

out vec2 f_UV;

void main() 
{
    gl_Position = vec4(v_Position, 1.0);
    f_UV 	= v_UV;
}

#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
in vec2 f_UV;

out vec4 color;

uniform sampler2D u_Render_texture;
uniform bool u_Horizontal;
uniform float u_Blur_radius;
uniform float u_Weights[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);

layout (std140) uniform Camera {
    vec4 position;
    mat4 view_matrix;
    mat4 projection_matrix;
    float bloom_threshold;
} ub_Camera;

void main()
{           
    vec3 color_sample = texture(u_Render_texture, f_UV).rgb;
    float brightness = dot(color_sample.rgb, vec3(0.2126, 0.7152, 0.0722));
    float radius_factor = min(brightness - ub_Camera.bloom_threshold, 0);
    vec2 tex_offset = u_Blur_radius * radius_factor / textureSize(u_Render_texture, 0);
    vec3 result = color_sample * u_Weights[0];

    if(u_Horizontal)
    {
        for(int i = 0; i < 5; i++)
        {
            result += texture(u_Render_texture, f_UV + vec2(tex_offset.x * i, 0.0)).rgb * u_Weights[i];
            result += texture(u_Render_texture, f_UV - vec2(tex_offset.x * i, 0.0)).rgb * u_Weights[i];
        }
    }
    else
    {
        for(int i = 0; i < 5; i++)
        {
            result += texture(u_Render_texture, f_UV + vec2(0.0, tex_offset.y * i)).rgb * u_Weights[i];
            result += texture(u_Render_texture, f_UV - vec2(0.0, tex_offset.y * i)).rgb * u_Weights[i];
        }
    }

    color = vec4(result, 1.0f);
}
