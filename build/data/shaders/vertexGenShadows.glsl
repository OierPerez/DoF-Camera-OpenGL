#version 400


layout(location = 0) in vec3 position;
layout(location = 3) in vec2 UV;

uniform mat4 M;
uniform mat4 O;
uniform mat4 C;

void main()
{
    gl_Position = O*C*M*vec4(position, 1);
   
}