#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec2 aTexCoords;

out vec2 coord;

void main()
{
    // Just give everything to the frag shader and set the positions, super basic
    coord = aTexCoords;
    gl_Position = vec4(aPos, 1.0);
}


#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable


// Output color
out vec4 FragColor;

// All of the textures from the GBuffer 
uniform sampler2D positionMap;
uniform sampler2D normalMap;
uniform sampler2D colorSpecularMap;
uniform sampler2D lightMap;

// Texture coordinate
in vec2 coord;

// Constants for... something
const float specularPower = 16.0f;

void main()
{             
    // Get the position value
    vec3 position = texture(positionMap, coord).rgb;
    // Get the normal value
    vec3 normal = normalize(texture(normalMap, coord).rgb);
    // Get the color
    vec3 color = texture(colorSpecularMap, coord).rgb;
    // Get the specular (combined into the colorSpecular map);
    float s = texture(colorSpecularMap, coord).a;
    // Get the light value
    vec3 light = texture(lightMap, coord).rgb;

    /* // Ambient factor ??? */
    /* vec3 ambient = color * 0.1; */

    /* vec3 v = -normalize(position); */
    /* vec3 h = normalize(v + 1); */

    /* float ndotl = dot(normal, light); */
    /* vec3 diffuse = max(0.0f, ndotl) * color; */

    /* vec3 specular = vec3(0); */
    /* if(ndotl >= 0) specular = pow(max(0.0f, dot(normal, h)), specularPower) * vec3(s); */

    /* vec3 finalColor =  (diffuse + specular); */


    FragColor = vec4(light, 1.0);

}








