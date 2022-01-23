#version 400

out vec4 outColor;
in vec2 uv;

uniform float z_1;
uniform float z_2;
uniform float z_3;
uniform float z_4;

uniform sampler2D gpositionsTex;




void main()
{


  vec3 pos = texture(gpositionsTex, uv).rgb;
  
  if(-pos.z < z_2)      //Full first
  {
    outColor = vec4(1,0,0,1);
  }
  else if(-pos.z > z_2 && -pos.z < z_1)     //Between first and second frustum
  {

    float perc_z = (-pos.z - z_2) / (z_1 - z_2);

    outColor = perc_z * vec4(1,0,0,1) + (1 - perc_z) * vec4(0,1,0,1);

  }
  else if(-pos.z > z_1 && -pos.z < z_4)             //Full second
  {
    outColor = vec4(0,1,0,1);
  }
  else if(-pos.z > z_4 && -pos.z < z_3)         //Between second and third
  {

    float perc_z = (-pos.z - z_4) / (z_3 - z_4);

    outColor = perc_z * vec4(0,1,0,1) + (1 - perc_z) * vec4(0,0,1,1);
  }
  else
  {
    outColor = vec4(0,0,1,1);
  }
}