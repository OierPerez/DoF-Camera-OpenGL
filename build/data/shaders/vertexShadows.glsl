#version 400


layout(location = 0) in vec3 position;
layout(location = 3) in vec2 UV;

out vec2 uv;

void main()
{
   gl_Position = vec4(position,1);
   uv = UV;
}