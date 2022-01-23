#version 400


out vec4 outColor;

in vec2 uv;

uniform sampler2D inBloomTexture;
uniform sampler2D LightsOutTex;


void main()
{
	outColor = texture(inBloomTexture, uv) + texture(LightsOutTex, uv);
}