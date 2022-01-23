#version 430

layout(local_size_x=20, local_size_y=1, local_size_z=1) in;


layout(location=0, rgba16f) uniform image3D HorizontalTex;
layout(location=1)uniform int width;
layout(location=2)uniform int height;
layout(location=3)uniform sampler2D RadiiTex;
layout(location=4)uniform bool show_only_focused;

const float pi = 3.14159265359f;

shared vec4 textureData[gl_WorkGroupSize.x + 20*2];

void main()
{
	//Put each of the current values into the shared memory
	textureData[gl_LocalInvocationID.x + 20] = texture(RadiiTex, gl_GlobalInvocationID.xy / vec2(width, height));

	//Put the previous max radius values into the shared memory
	if(gl_LocalInvocationID.xy == uvec2(0,0))
	{
		for(int i = 0; i < 20; i++)
		{
			textureData[i] = texture(RadiiTex, (gl_GlobalInvocationID.xy - vec2(20 - i,0)) / vec2(width, height));
		}
	}
	else if(gl_LocalInvocationID.xy == uvec2(19,0))		//Put the next max radius values into the shared memory
	{
		for(int i = 0; i < 20; i++)
		{
			textureData[40 + i] = texture(RadiiTex, (gl_GlobalInvocationID.xy + vec2(i,0)) / vec2(width, height));
		}
	}

	memoryBarrier();
	barrier();

	const int gather_size = 41;
	const int iterator = gather_size / 2;

	//Initialize the tmp array to black
	vec4 tmparray[41];
	for(int i = 0; i < gather_size; i++)
	{
		tmparray[i] = vec4(0.f);
	}

	
	float cur_r = textureData[gl_LocalInvocationID.x + 20].a;

	tmparray[0] =  vec4(textureData[gl_LocalInvocationID.x + 20].rgb, 1.f) / max(pi * cur_r * cur_r, 1);
	//tmparray[0] =  vec4(texture(RadiiTex, vec2(float(gl_GlobalInvocationID.x) / width_with_a_name, float(gl_GlobalInvocationID.y) / height)).rgb, 1.0f) /  (pi * cur_r * cur_r);
	
	
	for(int j = 1; j <= iterator; j++)
	{
		if(!show_only_focused)
		{
			//Get the samples
			vec4 SampleLeft = textureData[gl_LocalInvocationID.x + 6 - j];
			vec4 SampleRight= textureData[gl_LocalInvocationID.x + 6 + j];
			
			//Get the radius
			float r_l = clamp(SampleLeft.a, 0, 41);
			float r_r = clamp(SampleRight.a, 0, 41);
			
			//Compute if it is a valid index
			float left_val = r_l*r_l - j*j;
			float right_val = r_r*r_r - j*j;
	
			//Fill the tmp array with  the rgb value divided by the area of the CoC
			if(left_val >= 0.f)
				tmparray[int(((sqrt(left_val))))] += vec4(SampleLeft.rgb, 1.f) / (pi * r_l * r_l);
			if(right_val >= 0.f)
				tmparray[int(((sqrt(right_val))))] += vec4(SampleRight.rgb, 1.f) / (pi * r_r * r_r);
		}
		else				//Debug example
		{
			//Get the samples
			vec4 SampleLeft = textureData[gl_LocalInvocationID.x + 6 - j];
			vec4 SampleRight= textureData[gl_LocalInvocationID.x + 6 + j];
			
			//Get the radius
			float r_l = clamp(SampleLeft.a, 0, 41);
			float r_r = clamp(SampleRight.a, 0, 41);
			
			//Compute if it is a valid index
			float left_val = r_l*r_l - j*j;
			float right_val = r_r*r_r - j*j;
	
			//Fill the tmp array with  the rgb value divided by the area of the CoC
			if(left_val >= 0.f)
				tmparray[int(((sqrt(left_val))))] += vec4(0.f, 0.f,0.f, 1.f) / (pi * r_l * r_l);
			if(right_val >= 0.f)
				tmparray[int(((sqrt(right_val))))] += vec4(0.f, 0.f,0.f, 1.f) / (pi * r_r * r_r);
		}
			
	}
	
	
	//Accumulate the tmp array in the set of Z values
	vec4 acumm = vec4(0.f, 0.f, 0.f, 0.f);
	for(int i = iterator; i >= 0; i--)
	{
		acumm += tmparray[i];
		
		imageStore(HorizontalTex, ivec3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y, i), acumm);
	}
	

}