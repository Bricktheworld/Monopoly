#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
layout (location = 0) in vec3 pos;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 tex_coords;

out vec2 UV;

void main()
{
    gl_Position = vec4(pos, 1.0);
	  UV = (pos.xy+vec2(1,1))/2.0;
}


#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable
in vec2 UV;

out vec4 FragColor;

uniform sampler2D renderedTexture;

void main()
{           
    FragColor = vec4(texture(renderedTexture, UV).xyz, 1.0);
}
