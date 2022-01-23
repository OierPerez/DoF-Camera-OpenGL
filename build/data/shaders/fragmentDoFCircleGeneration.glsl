#version 400

in vec2 uv;
out vec4 outputColor;

uniform sampler2D gdiffuseColTex;
uniform sampler2D gDepthTex;
uniform float DiameterOfAperture;
uniform float FocalLength;
uniform float FocalPlaneDist;
//uniform int max_CoC;
uniform float near;
uniform float far;

float linearize_depth(float original_depth) {
    return (2.0 * near) / (far + near - original_depth * (far - near));
}

void main()
{

  outputColor.xyz = texture(gdiffuseColTex, uv).rgb;

  float cur_depth = linearize_depth(texture(gDepthTex, uv).r);

  //CoC = abs(aperture * (focallength * (objectdistance - planeinfocus)) /           (objectdistance * (planeinfocus - focallength)))

  float r = abs(DiameterOfAperture * (FocalLength * (FocalPlaneDist - cur_depth))/ (cur_depth * (FocalPlaneDist - FocalLength)));
  //float r = abs(DiameterOfAperture * (FocalLength * (cur_depth - FocalPlaneDist )/ (cur_depth * (FocalPlaneDist - FocalLength))));

  r = clamp(r, 0, 41);

  outputColor.w = r;

}