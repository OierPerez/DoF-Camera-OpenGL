#version 400

layout (location = 0) out vec4 AmbientTex;

//uniform sampler2D gdiffuseColTex;
uniform sampler2D gPositions;
uniform mat4	  p;

uniform int WIDTH;
uniform int HEIGHT;
uniform float radius;
uniform float angle_bias;
uniform float attenuation_mult;
uniform float scale;
uniform int samples;
uniform int line_num;

float pi = 3.14159265359;

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main()
{

	vec2 uv = gl_FragCoord.xy / vec2(WIDTH, HEIGHT);	

	vec3 cam_position = texture(gPositions, uv).rgb;		//Initial fragment position
	

	vec3 tangent;
	vec3 horizon;
	
	float AO = 0.f;
	float rand_angle = rand(uv) * 2.f * pi;;
	for(int i = 0; i < line_num; i++)
	{
		vec3 horizon_point = vec3(0,0,0);
		vec3 linear_comb = normalize(vec3(cos(rand_angle + (2 * pi) / line_num * i), sin(rand_angle + (2 * pi) / line_num * i), 0));					//Compute the current vector in the random line
		tangent = dFdx(cam_position) * cos(rand_angle + (2 * pi) / line_num * i) + dFdy(cam_position) * sin(rand_angle + (2 * pi) / line_num * i);		//Compute the tangent

		for(int k = 1; k <= samples; k++)	//This should happen on every line, not just a single one
		{
			vec4 mod_cam_pos = vec4(cam_position, 1);	
			mod_cam_pos += vec4(linear_comb, 0) * radius * float(k) / samples;					//Advance on the random line
			mod_cam_pos = p * mod_cam_pos;
			mod_cam_pos /= mod_cam_pos.w;
			mod_cam_pos = (mod_cam_pos + 1) * 0.5f;												//Transform the point to UV coordinates


			vec3 new_sample = texture(gPositions, mod_cam_pos.xy).xyz;

			if(length(new_sample - cam_position) > radius)										//Check for big discrepancy between the sample points
				continue;


			if(horizon_point.z <= new_sample.z || horizon_point == vec3(0,0,0))					//Compute if the new point is closer to the camera
			{
				horizon_point = new_sample;
				horizon = new_sample - cam_position;
			}
		}

		if(horizon_point == vec3(0,0,0))
			continue; 

		//Apply the algorithm
		float H = atan(horizon.z / length(horizon.xy));
		float T = atan(tangent.z / length(tangent.xy));
		float r = length(cam_position - horizon_point) / radius;		//Attenuation factor
		float Att = clamp((1 - (r*r*attenuation_mult)) , 0,1);
		

		AO += (sin(H) - sin(T + angle_bias)) * Att;
	}

	AO /= line_num;
	AO = 1 - AO;
	
	AmbientTex = vec4(vec3(clamp(AO * scale, 0, 1)), 1);
}