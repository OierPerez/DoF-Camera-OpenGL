#version 430

out vec4 outputColor;

layout(location=0, rgba16f) uniform image3D HorizontalTex;

const int max_radius = 20;

//void main()
//{
//	
//	vec3 final_col = imageLoad(HorizontalTex, ivec3(gl_FragCoord.x, gl_FragCoord.y, 0)).rgb;
//
//	for(int i = 1; i < max_radius; ++i)
//	{
//		final_col += imageLoad(HorizontalTex, ivec3(gl_FragCoord.x, gl_FragCoord.y + i, i)).rgb;
//		final_col += imageLoad(HorizontalTex, ivec3(gl_FragCoord.x, gl_FragCoord.y - i, i)).rgb;
//	}
//
//	outputColor = vec4(final_col, 1);
//
//}



void main()
{
    vec3 final_col = imageLoad(HorizontalTex, ivec3(gl_FragCoord.x, gl_FragCoord.y, 0)).rgb;
    float count = imageLoad(HorizontalTex, ivec3(gl_FragCoord.x, gl_FragCoord.y, 0)).a;
    for(int i = 1; i < max_radius; ++i)
    {
        final_col += imageLoad(HorizontalTex, ivec3(gl_FragCoord.x, gl_FragCoord.y + i, i)).rgb;
        count += imageLoad(HorizontalTex, ivec3(gl_FragCoord.x, gl_FragCoord.y + i, i)).a;
        final_col += imageLoad(HorizontalTex, ivec3(gl_FragCoord.x, gl_FragCoord.y - i, i)).rgb;
        count += imageLoad(HorizontalTex, ivec3(gl_FragCoord.x, gl_FragCoord.y - i, i)).a;
    }
    outputColor = vec4(final_col / count, 1);
}