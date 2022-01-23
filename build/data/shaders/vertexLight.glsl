#version 400


layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec3 tangent;
layout(location = 3) in vec2 UV;

out vec2 uv;
out vec3 outNormal;



void main()
{
   gl_Position = vec4(position,1);
   uv = UV;
}