#version 400

out vec4 outColor;
in vec2 uv;

uniform int neightbour;
uniform float bias;
uniform float Near;
uniform float z_1;
uniform float z_2;
uniform float z_3;
uniform float z_4;
uniform float Far;

uniform vec4 dir_color;
uniform vec3 Light_dir;
uniform mat4 O_0;
uniform mat4 O_1;
uniform mat4 O_2;
uniform mat4 L;
uniform mat4 C_inverse;
uniform sampler2D gpositionsTex;
uniform sampler2D gnormalsTex;
uniform sampler2D gdiffuseColTex;
uniform sampler2D shadowDepthTex0;
uniform sampler2D shadowDepthTex1;
uniform sampler2D shadowDepthTex2;




void main()
{

  
  float accumulatedVis = 0;
  float accumulatedVis_1 = 0;
  float accumulatedVis_2 = 0;
  int sampleCount = 0;

  vec3 pos = texture(gpositionsTex, uv).rgb;
  
  

  if(-pos.z < z_2)      //Full first
  {
    vec2 texelOffset_0 = 1.0 / textureSize(shadowDepthTex0, 0);
    vec3 cur_camera_pos = vec3(O_0 * L * C_inverse * vec4(pos, 1));
    cur_camera_pos += 1;
    cur_camera_pos /= 2;

    //Compute the smooth shadow multiplyer
    for(int x = -neightbour; x <= neightbour; x++)
    {
    	 for(int y = -neightbour; y <= neightbour; y++)
    	 {
    	 	if(texture(shadowDepthTex0, cur_camera_pos.xy + texelOffset_0 * vec2(x,y)).r > (cur_camera_pos.z - bias))
    	 	{
    	 		accumulatedVis += 1.0;
    	 	}
    	 
    	 	sampleCount++;
    	 }
    }
  }
  else if(-pos.z > z_2 && -pos.z < z_1)     //Between first and second frustum
  {

    vec2 texelOffset_0 = 1.0 / textureSize(shadowDepthTex0, 0);
    vec2 texelOffset_1 = 1.0 / textureSize(shadowDepthTex1, 0);
    vec3 cur_camera_pos_0 = vec3(O_0 * L * C_inverse * vec4(pos, 1));
    cur_camera_pos_0 += 1;
    cur_camera_pos_0 /= 2;

    vec3 cur_camera_pos_1 = vec3(O_1 * L * C_inverse * vec4(pos, 1));
    cur_camera_pos_1 += 1;
    cur_camera_pos_1 /= 2;

    float perc_z = (-pos.z - z_2) / (z_1 - z_2);

    //Compute the smooth shadow multiplyer
    for(int x = -neightbour; x <= neightbour; x++)
    {
    	 for(int y = -neightbour; y <= neightbour; y++)
    	 {
    	 	if(texture(shadowDepthTex1, cur_camera_pos_1.xy + texelOffset_1 * vec2(x,y)).r > (cur_camera_pos_1.z - bias))
    	 	{
    	 		accumulatedVis_1 += 1.0;
    	 	}

            if(texture(shadowDepthTex0, cur_camera_pos_0.xy + texelOffset_0 * vec2(x,y)).r > (cur_camera_pos_0.z - bias))
    	 	{
    	 		accumulatedVis_2 += 1.0;
    	 	}
    	 
    	 	sampleCount++;
    	 }
    }

    accumulatedVis = perc_z * accumulatedVis_1 + (1 - perc_z) * accumulatedVis_2;

  }
  else if(-pos.z > z_1 && -pos.z < z_4)             //Full second
  {
    vec2 texelOffset_1 = 1.0 / textureSize(shadowDepthTex1, 0);
    vec3 cur_camera_pos = vec3(O_1 * L * C_inverse * vec4(pos, 1));
    cur_camera_pos += 1;
    cur_camera_pos /= 2;
    //Compute the smooth shadow multiplyer
    for(int x = -neightbour; x <= neightbour; x++)
    {
    	 for(int y = -neightbour; y <= neightbour; y++)
    	 {
    	 	if(texture(shadowDepthTex1, cur_camera_pos.xy + texelOffset_1 * vec2(x,y)).r > (cur_camera_pos.z - bias))
    	 	{
    	 		accumulatedVis += 1.0;
    	 	}
    	 
    	 	sampleCount++;
    	 }
    }
  }
  else if(-pos.z > z_4 && -pos.z < z_3)         //Between second and third
  {

    vec2 texelOffset_1 = 1.0 / textureSize(shadowDepthTex1, 0);
    vec2 texelOffset_2 = 1.0 / textureSize(shadowDepthTex2, 0);
    vec3 cur_camera_pos_1 = vec3(O_1 * L * C_inverse * vec4(pos, 1));
    cur_camera_pos_1 += 1;
    cur_camera_pos_1 /= 2;
    vec3 cur_camera_pos_2 = vec3(O_2 * L * C_inverse * vec4(pos, 1));
    cur_camera_pos_2 += 1;
    cur_camera_pos_2 /= 2;

    //Compute the smooth shadow multiplyer

    float perc_z = (-pos.z - z_4) / (z_3 - z_4);

    for(int x = -neightbour; x <= neightbour; x++)
    {
    	 for(int y = -neightbour; y <= neightbour; y++)
    	 {

            if(texture(shadowDepthTex2, cur_camera_pos_2.xy + texelOffset_2 * vec2(x,y)).r > (cur_camera_pos_2.z - bias))
    	 	{
    	 		accumulatedVis_1 += 1.0;
    	 	}

            if(texture(shadowDepthTex1, cur_camera_pos_1.xy + texelOffset_1 * vec2(x,y)).r > (cur_camera_pos_1.z - bias))
    	 	{
    	 		accumulatedVis_2 += 1.0;
    	 	}
    	 
    	 	sampleCount++;
    	 }
    }

    accumulatedVis = perc_z * accumulatedVis_1 + (1 - perc_z) * accumulatedVis_2;
  }
  else
  {
  
    vec2 texelOffset_2 = 1.0 / textureSize(shadowDepthTex2, 0);
    vec3 cur_camera_pos = vec3(O_2 * L * C_inverse * vec4(pos, 1));
    cur_camera_pos += 1;
    cur_camera_pos /= 2;

    //Compute the smooth shadow multiplyer
    for(int x = -neightbour; x <= neightbour; x++)
    {
    	 for(int y = -neightbour; y <= neightbour; y++)
    	 {
    	 	if(texture(shadowDepthTex2, cur_camera_pos.xy + texelOffset_2 * vec2(x,y)).r > (cur_camera_pos.z - bias))
    	 	{
    	 		accumulatedVis += 1.0;
    	 	}
    	 
    	 	sampleCount++;
    	 }
    }
  }


  

  float shadowCoef = accumulatedVis / sampleCount;


  vec3 N = texture(gnormalsTex, uv).rgb;
  vec3 L = normalize(-Light_dir);
  vec3 V = normalize(-pos);
  vec3 R = normalize(2 * (dot(N , L) * N) - L);
  vec4 diffuse = vec4(texture(gdiffuseColTex, uv).rgb ,1) * max(0, dot(N, L));
  float specular_f = texture(gdiffuseColTex, uv).a;
  vec4 specular = vec4(specular_f, specular_f, specular_f, 1) * pow(max(dot(R, V), 0), texture(gnormalsTex, uv).a);

  outColor = shadowCoef * dir_color * (diffuse + specular);
}