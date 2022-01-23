#version 400


layout (location = 0) out vec4 color;

in vec2 uv;

uniform sampler2D inTexture;
uniform sampler2D pos_texture;
uniform float sigma;
uniform bool Horizontal;

float weight[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);

float pi = 3.14159265359;

float gaussian(float x, float sigma)
{
    return 1.f / (sqrt(2 * pi) * sigma) * exp(- (x*x)/(2 * sigma * sigma));
}

void main()
{
    //Acumular weight * factor y dividir por ello para averaging
    //Depth diff = difference on the two depths

    float acummulator = weight[0] * gaussian(0, sigma);

	vec2 tex_offset = 1.0 / textureSize(inTexture, 0); // gets size of single texel
    vec3 hack = texture(inTexture, uv).rgb;
    vec3 result = texture(inTexture, uv).rgb * weight[0] * gaussian(0, sigma); // current fragment's contribution
    float depth = texture(pos_texture, uv).z;
    if(Horizontal)
    {
        for(int i = 1; i < 5; ++i)
        {
        
            float depth_diff = abs(depth - texture(pos_texture, uv + vec2(tex_offset.x * i, 0.0)).z);
            float bilateral_weight_top = weight[i] * gaussian(depth_diff, sigma);
            result += texture(inTexture, uv + vec2(tex_offset.x * i, 0.0)).rgb * bilateral_weight_top;
        
            depth_diff = abs(depth - texture(pos_texture, uv - vec2(tex_offset.x * i, 0.0)).z);
            float bilateral_weight_bot = weight[i] * gaussian(depth_diff, sigma);
            result += texture(inTexture, uv - vec2(tex_offset.x * i, 0.0)).rgb * bilateral_weight_bot;
        
            acummulator += bilateral_weight_bot + bilateral_weight_top;
        }
        
        result /= acummulator;

        //for(int i = 1; i < 5; ++i)
        //{
        //    result += texture(inTexture, uv + vec2(tex_offset.x * i, 0.0)).rgb * weight[i];
        //    result += texture(inTexture, uv - vec2(tex_offset.x * i, 0.0)).rgb * weight[i];
        //}
        


    }
    else
    {
        for(int i = 1; i < 5; ++i)
        {
            float depth_diff = abs(depth - texture(pos_texture, uv + vec2(0.0, tex_offset.y * i)).z);
            float bilateral_weight_top = weight[i] * gaussian(depth_diff, sigma);
            result += texture(inTexture, uv + vec2(0.0, tex_offset.y * i)).rgb * bilateral_weight_top;
        
        
            depth_diff = abs(depth - texture(pos_texture, uv - vec2(0.0, tex_offset.y * i)).z);
            float bilateral_weight_bot = weight[i] * gaussian(depth_diff, sigma);
            result += texture(inTexture, uv - vec2(0.0, tex_offset.y * i)).rgb * bilateral_weight_bot;
        
            acummulator += bilateral_weight_bot + bilateral_weight_top;
        }
        result /= acummulator;

        //for(int i = 1; i < 5; ++i)
        //{
        //    result += texture(inTexture, uv + vec2(0.0, tex_offset.y * i)).rgb * weight[i];
        //    result += texture(inTexture, uv - vec2(0.0, tex_offset.y * i)).rgb * weight[i];
        //}

        
    }


    color = vec4(result, 1.0);
}