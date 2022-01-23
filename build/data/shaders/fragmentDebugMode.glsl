#version 400


in vec2 uv;
out vec4 outputColor;

uniform sampler2D gpositionsTex;
uniform sampler2D gnormalsTex;
uniform sampler2D gdiffuseColTex;
uniform sampler2D gDepthTex;
uniform sampler2D gShadowTex1;
uniform sampler2D gShadowTex2;
uniform sampler2D gShadowTex3;
uniform sampler2D gAOambient;
uniform sampler2D CoCTex;
uniform sampler2D LightOut;
uniform int mode;
uniform float near;
uniform float far;

float linearize_depth(float original_depth) {
    return (2.0 * near) / (far + near - original_depth * (far - near));
}

void main()
{
  if(mode == 1)
  {
    vec3 pos = texture(gpositionsTex, uv).rgb;
    outputColor = vec4(pos, 1);
  }
  else if(mode == 2)
  {
    vec3 N = texture(gnormalsTex, uv).rgb;
    outputColor = vec4(N, 1);
  }
  else if(mode == 3)
  {
    outputColor = vec4(texture(gdiffuseColTex, uv).rgb ,1);
  }
  else if(mode == 4)
  {
    float depth = linearize_depth(texture(gDepthTex, uv).r);
    
    outputColor = vec4(depth,depth,depth,1);
  }
  else if(mode == 5)
  {
     outputColor = vec4(texture(CoCTex, uv).w);
     //outputColor = vec4(1);
     //outputColor = vec4(texture(gAOambient, uv).rgb ,1);
    //outputColor = vec4(texture(gShadowTex1, uv).rgb ,1);
  }
  else if(mode == 6)
  {
    //outputColor = vec4(texture(gShadowTex2, uv).rgb ,1);

    outputColor = texture(LightOut, uv);
  }
  else if(mode == 7)
  {
    outputColor = vec4(texture(gShadowTex3, uv).rgb ,1);
  }
  else if(mode == 8)
  {
    outputColor = vec4(texture(gAOambient, uv).rgb ,1);
  }

}