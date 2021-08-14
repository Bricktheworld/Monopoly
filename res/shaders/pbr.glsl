#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

layout (location = 0) in vec3 v_Position;
layout (location = 1) in vec3 v_Normal;
layout (location = 2) in vec2 v_UV;
layout (location = 3) in vec3 v_Tangent;
layout (location = 4) in vec3 v_Bitangent;

out vec3 f_Normal;
out vec3 f_Position;
out vec2 f_UV;
out mat3 f_TBN;

layout (std140) uniform Camera {
    vec4 position;
    mat4 view_matrix;
    mat4 projection_matrix;
    float bloom_threshold;
} ub_Camera;

uniform mat4 u_MVP;
uniform mat4 u_Model_matrix;
uniform mat3 u_Normal_matrix;

void main() 
{
    gl_Position = u_MVP * vec4(v_Position, 1.0f);
    f_Position  = vec3(u_Model_matrix * vec4(v_Position, 1.0f));
    f_Normal  	= v_Normal;
    f_UV 	= v_UV;


    // TBN matrix calculation
    vec3 T = normalize(u_Normal_matrix * v_Tangent);
    vec3 N = normalize(u_Normal_matrix * v_Normal);

    // Re-orthogonalize T with respect to N
    T = normalize(T - dot(T, N) * N);

    vec3 B = cross(N, T);

    f_TBN = mat3(T, B, N);
}

#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

layout (location = 0) out vec4 color;
layout (location = 1) out vec4 bright_color;

in vec3 f_Position;
in vec3 f_Normal;
in vec2 f_UV;
in mat3 f_TBN;

layout (std140) uniform Camera {
    vec4 position;
    mat4 view_matrix;
    mat4 projection_matrix;
    float bloom_threshold;
} ub_Camera;

layout (std140) uniform DirectionalLight {
  vec4 direction;

  vec4 ambient;
  vec4 diffuse;
  float specular;
  float intensity;
  int exists;
} ub_Directional_light;

struct PointLight {
  vec3 position;

  float constant;
  float linear;
  float quadratic;

  vec3 ambient;
  vec3 diffuse;
  float specular;
  float intensity;
};

#define MAX_POINT_LIGHTS 256
layout (std140) uniform PointLights {
  vec4 positions[MAX_POINT_LIGHTS];

  vec4 constants[MAX_POINT_LIGHTS];
  vec4 linears[MAX_POINT_LIGHTS];
  vec4 quadratics[MAX_POINT_LIGHTS];

  vec4 ambients[MAX_POINT_LIGHTS];
  vec4 diffuses[MAX_POINT_LIGHTS];
  vec4 speculars[MAX_POINT_LIGHTS];
  vec4 intensities[MAX_POINT_LIGHTS];

  int count;
} ub_Point_lights;

uniform mat3 u_Normal_matrix;


uniform vec4 u_Albedo = vec4(1);
uniform int u_Has_albedo_map = 0;
uniform sampler2D u_Albedo_map;

uniform int u_Has_normal_map = 0;
uniform sampler2D u_Normal_map;

uniform float u_Metallic = 0;
uniform int u_Has_metallic_map = 0;
uniform sampler2D u_Metallic_map;

uniform float u_Roughness = 0;
uniform int u_Has_roughness_map = 0;
uniform sampler2D u_Roughness_map;
uniform int u_Is_smoothness_map = 0;

uniform float u_Ambient_occlusion = 0;
uniform int u_Has_ambient_occlusion_map = 0;
uniform sampler2D u_Ambient_occlusion_map;


vec3 calc_point_light(PointLight light, vec3 view_direction, vec3 normal, float roughness, float metallic, vec3 F0, vec3 albedo);
vec3 calc_directional_light(vec3 view_direction, vec3 normal, float roughness, float metallic, vec3 F0, vec3 albedo);

const float PI = 3.14159265359;

float distribution_ggx(vec3 normal, vec3 halfway_vector, float roughness);
float geometry_schlick_ggx(float NdotV, float roughness);
float geometry_smith(vec3 normal, vec3 view_direction, vec3 light_direction, float roughness);
vec3 fresnel_schlick(float cosTheta, vec3 F0);

void main()
{    
    vec4 albedo = u_Albedo;
    if(u_Has_albedo_map == 1) 
    {
	vec4 tex_albedo = texture(u_Albedo_map, f_UV).rgba;
	albedo *= tex_albedo.rgba;
    }

    // Get normal either from normal map or from vertex
    vec3 normal;
    if(u_Has_normal_map == 0) 
    {
	normal = normalize(u_Normal_matrix * f_Normal);
    }
    else
    {
	// Get normal from normal map in range [0, 1]
	normal = texture(u_Normal_map, f_UV).rgb;

	// Map this normal to a range [-1, 1]
	normal = normal * 2.0 - 1.0;

	normal = normalize(f_TBN * normal);
    }

    // Get metallic float either from map or from uniform float
    float metallic;
    if(u_Has_metallic_map == 1) 
    {
	metallic = texture(u_Metallic_map, f_UV).r;
    }
    else
    {
	metallic = u_Metallic;
    }

    // Get the ambient occlusion float either from the map or from uniform float
    float ao;
    if(u_Has_ambient_occlusion_map == 1)
    {
	ao = texture(u_Ambient_occlusion_map, f_UV).r;
    }
    else
    {
	ao = u_Ambient_occlusion;
    }

    // Get the roughness float either from the map or from uniform float
    float roughness;
    if(u_Has_roughness_map == 1)
    {
	roughness = texture(u_Roughness_map, f_UV).r;
    }
    else
    {
	roughness = u_Roughness;
    }

    if(u_Is_smoothness_map == 1)
    {
	roughness = 1 - roughness;
    }

    vec3 view_direction = normalize(ub_Camera.position.xyz - f_Position);

    // The Fresnel-Schlick approximation expects a F0 parameter which is known as the surface reflection at zero incidence
    // or how much the surface reflects if looking directly at the surface.
    //
    // The F0 varies per material and is tinted on metals as we find in large material databases.
    // In the PBR metallic workflow we make the simplifying assumption that most dielectric surfaces look visually correct with a constant F0 of 0.04.
    vec3 F0 = vec3(0.04);
    F0      = mix(F0, albedo.rgb, metallic);

    // Output luminance accumulation
    vec3 output_luminance = calc_directional_light(view_direction, normal, roughness, metallic, F0, albedo.rgb);
    for(int i = 0; i < ub_Point_lights.count; i++) 
    {
	// Create a point light that we can use from the uniform buffer
	PointLight light = PointLight(ub_Point_lights.positions[i].xyz,
					    ub_Point_lights.constants[i].x,
					    ub_Point_lights.linears[i].x,
					    ub_Point_lights.quadratics[i].x,
					    ub_Point_lights.ambients[i].xyz,
					    ub_Point_lights.diffuses[i].xyz,
					    ub_Point_lights.speculars[i].x,
					    ub_Point_lights.intensities[i].x);

	// Add to outgoing radiance
	output_luminance += calc_point_light(light, view_direction, normal, roughness, metallic, F0, albedo.rgb); //(kD * albedo.rgb / PI + specular) * radiance * cos_theta;
    }

    vec3 ambient = vec3(0.03) * albedo.rgb * ao;
    vec3 result  = ambient + output_luminance;

    color 	 = vec4(result, albedo.a);

    // Bloom
    float brightness = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    if(brightness > ub_Camera.bloom_threshold)
        bright_color = vec4(color.rgb, 1.0);
    else
        bright_color = vec4(0.0, 0.0, 0.0, 1.0);
}

vec3 calc_directional_light(vec3 view_direction, vec3 normal, float roughness, float metallic, vec3 F0, vec3 albedo)
{ 
    // The light direction from the fragment position
    vec3 light_direction = normalize(-ub_Directional_light.direction.xyz);
    vec3 halfway_vector  = normalize(view_direction + light_direction);
    
    // Add the radiance
    vec3 radiance 	     = ub_Directional_light.diffuse.rgb * ub_Directional_light.intensity; // calc_point_light(point_light);
    
    // Cook torrance BRDF
    float D 	     = distribution_ggx(normal, halfway_vector, roughness);
    float G 	     = geometry_smith(normal, view_direction, light_direction, roughness);
    vec3  F 	     = fresnel_schlick(clamp(dot(halfway_vector, view_direction), 0.0, 1.0), F0);
    
    vec3 kS 	     = F;
    vec3 kD 	     = vec3(1.0) - kS;
    kD     		    *= 1.0 - metallic;
    
    vec3 numerator       = D * G * F;
    float denominator    = 4.0 * max(dot(normal, view_direction), 0.0) * max(dot(normal, light_direction), 0.0);
    vec3 specular        = numerator / max(denominator, 0.001);
    
    // Get the cosine theta of the light against the normal
    float cos_theta      = max(dot(normal, light_direction), 0.0);

    return (kD * albedo.rgb / PI + specular) * radiance * cos_theta;
}

vec3 calc_point_light(PointLight light, vec3 view_direction, vec3 normal, float roughness, float metallic, vec3 F0, vec3 albedo) 
{
    // The light direction from the fragment position
    vec3 light_direction = normalize(light.position.xyz - f_Position);
    vec3 halfway_vector  = normalize(view_direction + light_direction);
    
    // Point light attenuation
    float distance       = length(light.position.xyz - f_Position);
    float attenuation    = 1.0 / (light.constant + light.linear * distance + light.quadratic * distance);
    
    // Add the radiance
    vec3 radiance 	     = light.diffuse.rgb * light.intensity * attenuation; // calc_point_light(point_light);
    
    // Cook torrance BRDF
    float D 	     = distribution_ggx(normal, halfway_vector, roughness);
    float G 	     = geometry_smith(normal, view_direction, light_direction, roughness);
    vec3  F 	     = fresnel_schlick(clamp(dot(halfway_vector, view_direction), 0.0, 1.0), F0);
    
    vec3 kS 	     = F;
    vec3 kD 	     = vec3(1.0) - kS;
    kD     		    *= 1.0 - metallic;
    
    vec3 numerator       = D * G * F;
    float denominator    = 4.0 * max(dot(normal, view_direction), 0.0) * max(dot(normal, light_direction), 0.0);
    vec3 specular        = numerator / max(denominator, 0.001);
    
    // Get the cosine theta of the light against the normal
    float cos_theta      = max(dot(normal, light_direction), 0.0);

    return (kD * albedo.rgb / PI + specular) * radiance * cos_theta;
}

float distribution_ggx(vec3 normal, vec3 halfway_vector, float roughness) 
{
    float a      = roughness * roughness;
    float a2     = a * a;
    float NdotH  = max(dot(normal, halfway_vector), 0.0);
    float NdotH2 = NdotH * NdotH;
	
    float nom    = a2;
    float denom  = (NdotH2 * (a2 - 1.0) + 1.0);
    denom 	 = PI * denom * denom;
	
    return nom / max(denom, 0.0000001);
}

float geometry_schlick_ggx(float NdotV, float roughness) 
{
    float r 	= (roughness + 1.0);
    float k 	= (r * r) / 8.0;

    float nom   = NdotV;
    float denom = NdotV * (1.0 - k) + k;
	
    return nom / denom;
}

float geometry_smith(vec3 normal, vec3 view_direction, vec3 light_direction, float roughness) 
{
    float NdotV = max(dot(normal, view_direction), 0.0);
    float NdotL = max(dot(normal, light_direction), 0.0);
    float ggx2  = geometry_schlick_ggx(NdotV, roughness);
    float ggx1  = geometry_schlick_ggx(NdotL, roughness);
	
    return ggx1 * ggx2;
}

vec3 fresnel_schlick(float cos_theta, vec3 F0)
{
    return F0 + (1.0 - F0) * pow(max(1.0 - cos_theta, 0.0), 5.0);
}  
