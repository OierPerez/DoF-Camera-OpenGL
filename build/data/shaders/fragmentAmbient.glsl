#version 400

in vec2 uv;
out vec4 outputColor;

uniform sampler2D gdiffuseColTex;
uniform sampler2D gAOTex;
uniform vec4	  AmbientCol;


void main()
{

  outputColor.xyz = AmbientCol.rgb * texture(gdiffuseColTex, uv).rgb;// * texture(gAOTex, uv).rgb;		//Get the texture with the UV coordinates
  outputColor.w = 1.f;

}