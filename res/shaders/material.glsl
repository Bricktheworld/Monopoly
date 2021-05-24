#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec2 vertexUV;

out vec3 Normal;
out vec3 FragPos;
out vec2 FragUV;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform int texture;

void main() 
{
    gl_Position = projection * view * model * vec4(position, 1.0f);
    FragPos = vec3(model * vec4(position, 1.0f));
    Normal  = mat3(transpose(inverse(model))) * normal;
    FragUV = vertexUV;
}

#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

layout (location = 0) out vec3 gPosition;
layout (location = 1) out vec3 gNormal;
layout (location = 2) out vec4 gAlbedoSpec;
/* out vec4 color; */

in vec3 FragPos;
in vec3 Normal;
in vec2 FragUV;

uniform vec3 lightPos;
uniform vec3 viewPos;
uniform vec3 objectColor;
uniform vec3 lightColor;
struct Material {
    sampler2D diffuse;
    sampler2D specular;
};
uniform Material material;

void main()
{
    gPosition = FragPos;

    gNormal = normalize(Normal);

    gAlbedoSpec.rgb = texture(material.diffuse, FragUV).rgb;

    gAlbedoSpec.a = texture(material.specular, FragUV).r;
}
