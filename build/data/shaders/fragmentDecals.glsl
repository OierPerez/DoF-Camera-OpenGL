#version 400

layout (location = 0) out vec4 Position;
layout (location = 1) out vec4 Normal;
layout (location = 2) out vec4 DiffuseSpec;


in vec3 model_pos;


uniform sampler2D depthTex;
uniform sampler2D diffuseTex;
uniform sampler2D normalTex;
uniform sampler2D metallicTex;
uniform mat4 inv_model;
uniform mat4 inv_perspective;
uniform mat4 inv_camera;

uniform int width;
uniform int height;
uniform int debug_mode;
uniform float discard_angle;


bool InCube(vec4 pos)
{
	if(pos.x < -0.5 || pos.x > 0.5)
		return false;

	if(pos.y < -0.5 || pos.y > 0.5)
		return false;

	if(pos.z < -0.5 || pos.z > 0.5)
		return false;

	return true;
}

void main()
{
	if(debug_mode == 1)
	{
		DiffuseSpec.rgb = vec3(1);
		return;
	}


	vec2 cur_screen_pos = gl_FragCoord.xy / vec2(width, height);
	float depth_val = texture(depthTex, cur_screen_pos).r;

	vec4 pixel_pos = vec4(cur_screen_pos.x, cur_screen_pos.y, depth_val, 1);
	pixel_pos.xyz = (pixel_pos.xyz * 2) - 1;

	vec4 cam_pixel_pos = inv_perspective * pixel_pos;
	cam_pixel_pos /= cam_pixel_pos.w;
	vec4 model_pixel_pos = inv_model * inv_camera * cam_pixel_pos;


	if(!InCube(model_pixel_pos))
		discard;

	model_pixel_pos = (model_pixel_pos + 0.5);

	
	if(texture(diffuseTex, model_pixel_pos.xy).a < 0.01)
		discard;

	if(debug_mode == 0)
	{
		DiffuseSpec.rgb = texture(diffuseTex, model_pixel_pos.xy).rgb;
		DiffuseSpec.a = texture(metallicTex, model_pixel_pos.xy).b;

		vec3 tangent = dFdx(cam_pixel_pos.xyz);
		vec3 bitangent = dFdy(cam_pixel_pos.xyz);
		vec3 normal = cross(tangent, bitangent);

		vec3 texNormal = (texture(normalTex, model_pixel_pos.xy).xyz - vec3(0.5,0.5,0.5)) * 2;
		vec3 finalTexNormal = mat3(normalize(tangent), normalize(bitangent), normalize(normal)) * texNormal;

		//Take forward of the cube to cam space to ccompare with the normal
		vec4 forward = vec4(0,0,-1,0);
		forward = inverse(inv_camera) * inverse(inv_model) * forward;

		if(discard_angle < acos(dot(normal, vec3(forward)) / (length(vec3(forward)) * length(normal))))
			discard;

		Normal.rgb = finalTexNormal;
		Normal.a = texture(metallicTex, model_pixel_pos.xy).g;
		return;
	}
	else if(debug_mode == 2)
	{
		DiffuseSpec.rgb = vec3(1);
		return;
	}


}