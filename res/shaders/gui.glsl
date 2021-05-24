#shader vertex
#version 410 core
#extension GL_ARB_separate_shader_objects: enable

layout(location = 0) in vec3 vposition;
layout(location = 1) in vec4 color;
layout(location = 2) in vec2 uv;
layout(location = 3) in float texture; 
layout(location = 4) in vec4 borders;
layout(location = 5) in vec4 border_color;

out vec4 fColor;
out vec2 fTextCoord;
out float fTexture;
out vec4 fBorders;
out vec4 fBorder_color;

void main()
{
    gl_Position = vec4(vposition, 1);
    fTextCoord = uv;
    fColor = color;
    fTexture = texture;
    fBorders = borders;
    fBorder_color = border_color;
}

#shader fragment
#version 410 core
#extension GL_ARB_separate_shader_objects: enable

out vec4 FragColor;

in vec4 fColor;
in vec2 fTextCoord;
in float fTexture;
in vec4 fBorders;
in vec4 fBorder_color;

uniform sampler2D u_Textures[16];

void main()
{
  if (fBorders != vec4(0) && (fTextCoord.x > fBorders.z || fTextCoord.x < fBorders.x ||
    fTextCoord.y > fBorders.w || fTextCoord.y < fBorders.y)) {
    FragColor = fBorder_color;
  } else if(fTexture > -1) {
    int index = int(fTexture);
    FragColor = vec4(1, 1, 1, texture(u_Textures[index], fTextCoord).r) * fColor;
  } else {
    FragColor = fColor;
  }
}
