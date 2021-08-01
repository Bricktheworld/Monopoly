#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
layout (location = 0) in vec3 v_Position;
layout (location = 1) in vec3 v_Normal;
layout (location = 2) in vec2 v_UV;

out vec2 f_UV;

void main()
{
    gl_Position = vec4(v_Position, 1.0);
    f_UV = v_UV;
}


#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
in vec2 f_UV;

out vec4 color;

uniform sampler2D u_Render_texture;
uniform sampler2D u_Bloom_texture;
uniform float u_Exposure = 1.0;
uniform float u_Bloom_intensity = 1.0;

void main()
{           
    const float gamma = 2.2;

    vec3 hdr_color = texture(u_Render_texture, f_UV).rgb;
    vec3 bloom_color = texture(u_Bloom_texture, f_UV).rgb;
    bloom_color *= u_Bloom_intensity;
    hdr_color += bloom_color;

    // Exposure tone mapping
    //vec3 hdr_color = texture_color / (texture_color + vec3(1.0));
    vec3 result = vec3(1.0) - exp(-hdr_color * u_Exposure);

    // Gamma correction
    result = pow(result, vec3(1.0 / gamma));

    color = vec4(result, 1.0f);
}
