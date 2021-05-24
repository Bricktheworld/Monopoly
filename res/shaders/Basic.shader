#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

// Takes in position as a vec4 to pipe into the vertex positions
uniform mat4 ViewProjection;
uniform mat4 V;
uniform mat4 M;
uniform vec3 lightposition;

layout(location = 0) in vec3 vposition;
layout(location = 1) in vec3 vnormal;
layout (location = 3) in vec2 vertexUV;

out vec3 positionworldspace;
out vec3 fnormal;
out vec3 feyedirection;
out vec3 lightdirection;


void main()
{
    gl_Position = ViewProjection * vec4(vposition, 1);
    positionworldspace = (M * vec4(vposition, 1)).xyz; 
    vec3 vposition_cameraspace = (V * M * vec4(vposition, 1)).xyz;
    feyedirection = vec3(0, 0, 0) - vposition_cameraspace;
    
    vec3 lightposition_cameraspace = (V * vec4(lightposition, 1)).xyz;
    lightdirection = lightposition_cameraspace + feyedirection;
    
    fnormal = (V * M * vec4(vnormal, 0)).xyz;
    
}

#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

in vec3 positionworldspace;
in vec3 fnormal;
in vec3 feyedirection;
in vec3 lightdirection;

uniform mat4 MV;
uniform vec3 lightposition;

// Sets an output color as a vec3
layout(location = 0) out vec3 color;

void main()
{
    // Light emission properties
    vec3 LightColor = vec3(1, 1, 1);
    float LightPower = 50.0f;
    
    // Material properties
    vec3 MaterialDiffuseColor = vec3(1, 1, 1);
    vec3 MaterialAmbientColor = vec3(0.1, 0.1, 0.1) * MaterialDiffuseColor;
    vec3 MaterialSpecularColor = vec3(0.3, 0.3, 0.3);
    
    // Distance to light
    float distance = length(lightposition - positionworldspace);
    
    // Normal of the computed fragment, in camera space
    vec3 n = normalize(fnormal);
    
    // Direction of the light (from the fragment to the light)
    vec3 l = normalize(lightdirection);
    
    // Cosine of the angle between the normal and the light direction
    float cosTheta = clamp(dot(n, l), 0, 1);
    
    // Eye vector (towards the camera)
    vec3 E = normalize(feyedirection);
    
    // Direction in which the triangle reflects the light
    vec3 R = reflect(-l, n);
    
    // Cosine of the angle between the eye vector and the reflect vector
    float cosAlpha = clamp(dot(E, R), 0, 1);
    
    color = MaterialAmbientColor + 
            MaterialDiffuseColor * LightColor * LightPower * cosTheta / (distance * distance) +
            MaterialSpecularColor * LightColor * LightPower * pow(cosAlpha, 5) / (distance * distance);


    // //Sets color to blue
    // color = vec4(1.0, 1.0, 1.0, 1.0);
}
