#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

layout (location = 0) in vec3 position;

// The view and projection matricies of the camera are used to render the light volumes
uniform mat4 view;
uniform mat4 projection;

// The position of the light volume
uniform vec3 worldPos;

// The radius of the volume
uniform float radius;

void main()
{
    // Get the world position of the vertex
    vec3 wPos = (position * radius) + worldPos;

    // Multiply the world position by the projection and view 
    // matricies to get the final position as a 4x4 matrix
    gl_Position = projection * view * vec4(wPos, 1.0);
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

// Size of the framebuffer
uniform vec2 screenSize;

// Position of the light in world space
uniform vec3 lightPosition;

// Color of the light
uniform vec3 lightColor;

// Light Attenuation
uniform vec3 lightAttenuation;

// View position
uniform vec3 viewPos;

// The position of the light volume
uniform vec3 worldPos;

// Constant value that should be played with
const float specularPower = 16.0f;

void main()
{             
    // Get the coordinate in the texture based on the screen size
    vec2 coord = gl_FragCoord.xy / screenSize;

    // Get the position value
    vec3 position = texture(positionMap, coord).rgb;
    // Get the normal value
    vec3 normal = normalize(texture(normalMap, coord).rgb);
    // Get the color
    vec3 color = texture(colorSpecularMap, coord).rgb;
    // Get the specular (combined into the colorSpecular map);
    float s = texture(colorSpecularMap, coord).a;

    vec3 lighting = color * 0.1;

    vec3 viewDir = normalize(viewPos - position);

    vec3 lightDir = normalize(worldPos - position);
    vec3 diffuse = max(dot(normal, lightDir), 0.0) * color * lightColor;

    vec3 halfwayDir = normalize(lightDir + viewDir);
    float spec = pow(max(dot(normal, halfwayDir), 0.0), 16.0);
    vec3 specular = lightColor * spec * s;

    /* float distance = length(lightPosition - position); */
    /* float attenuation = 1.0 / (1.0 + 0.7 * distance + 1.8 * distance * distance); */
    /* diffuse *= attenuation; */
    /* specular *= attenuation; */
    lighting += diffuse + specular;


    FragColor = vec4(lighting, 1.0);
}








