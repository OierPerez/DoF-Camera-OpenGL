#version 400

out vec4 outputColor;

uniform vec4 uniform_color;

void main()
{
  outputColor = uniform_color;
}