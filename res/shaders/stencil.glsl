#shader vertex
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

in vec3 position;

uniform mat4 view;
uniform mat4 projection;

uniform vec3 worldPos;
uniform float radius;

void main() {
	vec3 wPos = (position * radius) + worldPos;
	gl_Position = projection * view * vec4(wPos, 1.0);
}

#shader fragment
#version 330 core
#extension GL_ARB_separate_shader_objects: enable

void main() {}
