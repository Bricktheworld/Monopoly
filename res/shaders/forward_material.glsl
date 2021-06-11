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
uniform mat4 MVP;

void main() 
{
    gl_Position = MVP * vec4(position, 1.0f);
    FragPos = vec3(model * vec4(position, 1.0f));
    Normal  = mat3(transpose(inverse(model))) * normal;
    FragUV = vertexUV;
}

#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

out vec4 color;

in vec3 FragPos;
in vec3 Normal;
in vec2 FragUV;

struct Material {
    sampler2D diffuse;
    sampler2D specular;
    float shininess;
}; 

struct DirectionalLight {
  vec3 direction;

  vec3 ambient;
  vec3 diffuse;
  vec3 specular;
};

struct PointLight {
  vec3 position;

  float constant;
  float linear;
  float quadratic;

  vec3 ambient;
  vec3 diffuse;
  vec3 specular;
};

uniform vec3 viewPos;
uniform vec4 tint;
uniform Material material;
uniform DirectionalLight directional_light;

vec3 calc_directional_light(DirectionalLight light, vec3 normal, vec3 view_direction)
{
    vec3 light_direction = normalize(-light.direction);

    // diffuse shading
    float diff = max(dot(normal, light_direction), 0.0);

    // specular shading
    vec3 reflect_direction = reflect(-light_direction, normal);
    float spec = pow(max(dot(view_direction, reflect_direction), 0.0), material.shininess);

    // combine results
    vec3 ambient  = light.ambient  * vec3(texture(material.diffuse, FragUV));
    vec3 diffuse  = light.diffuse  * diff * vec3(texture(material.diffuse, FragUV));
    vec3 specular = light.specular * spec * vec3(texture(material.specular, FragUV));
    return (ambient + diffuse + specular);
}  

void main()
{    
    vec3 view_direction = normalize(viewPos - FragPos);
    vec3 result = calc_directional_light(directional_light, Normal, view_direction);
    color = vec4(result, 1.0f);
}
