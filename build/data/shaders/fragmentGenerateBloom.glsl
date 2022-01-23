#version 400


layout (location = 0) out vec4 color;

in vec2 uv;

uniform sampler2D inTexture;

void main()
{
	vec3 FragColor = texture(inTexture, uv).rgb;

	float brightness = dot(FragColor.rgb, vec3(0.2126, 0.7152, 0.0722));
    if(brightness > 0.3)
        color = vec4(FragColor.rgb, 1.0);
    else
        color = vec4(0.0, 0.0, 0.0, 1.0);

}