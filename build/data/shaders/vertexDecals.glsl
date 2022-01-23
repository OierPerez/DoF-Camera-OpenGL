#version 400


layout(location = 0) in vec3 position;
layout(location = 1) in vec3 in_normal;
layout(location = 2) in vec4 in_tangent;
layout(location = 3) in vec2 UV;
layout(location = 4) in vec4 joints;
layout(location = 5) in vec4 weights;

uniform mat4 M;
uniform mat4 P;
uniform mat4 C;

out vec3 model_pos;

void main()
{

    gl_Position = P*C*M* vec4(position, 1);
}