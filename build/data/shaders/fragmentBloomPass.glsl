#version 400


layout (location = 0) out vec4 color;

in vec2 uv;

uniform sampler2D inTexture;
uniform int bloomOffset;
uniform bool Horizontal;

float weight[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);

void main()
{
	vec2 tex_offset = 1.0 / textureSize(inTexture, 0); // gets size of single texel
    vec3 result = texture(inTexture, uv).rgb * weight[0]; // current fragment's contribution
    if(Horizontal)
    {
        for(int i = 1; i < bloomOffset; ++i)
        {
            result += texture(inTexture, uv + vec2(tex_offset.x * i, 0.0)).rgb * weight[i];
            result += texture(inTexture, uv - vec2(tex_offset.x * i, 0.0)).rgb * weight[i];
        }
        //result /= bloomOffset;
    }
    else
    {
        for(int i = 1; i < bloomOffset; ++i)
        {
            result += texture(inTexture, uv + vec2(0.0, tex_offset.y * i)).rgb * weight[i];
            result += texture(inTexture, uv - vec2(0.0, tex_offset.y * i)).rgb * weight[i];
        }
        //result /= bloomOffset;
    }
    color = vec4(result, 1.0);
}