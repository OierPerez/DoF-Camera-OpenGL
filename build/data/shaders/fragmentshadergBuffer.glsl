#version 400

layout (location = 0) out vec4 Position;
layout (location = 1) out vec4 Normal;
layout (location = 2) out vec4 DiffuseSpec;

in vec2 uv;
in vec3 pos;
in vec3 normal;
in vec3 tangent;

uniform sampler2D texture_diffuse;
uniform sampler2D texture_specular;
uniform sampler2D texture_normal;
uniform vec4 mat_base_col;
uniform bool DrawDiffuse;
uniform bool DrawSpecular;
uniform bool DrawNormal;

void main()
{    
    // store the fragment position vector in the first gbuffer texture
    Position = vec4(pos,1);
    vec3 texNormal = normal;
    if(DrawNormal)
    {
        texNormal = (texture(texture_normal, uv).xyz - vec3(0.5,0.5,0.5)) * 2;
        vec3 bitangent = cross(normal, tangent);
        texNormal = mat3(tangent, bitangent, normal) * texNormal;
    }


    float shininess = 1.f;
    if(DrawSpecular)
    {
        shininess = max(texture(texture_specular, uv).g, 0.1f);
    }
    
    // also store the per-fragment normals into the gbuffer
    Normal = vec4(normalize(texNormal), shininess);
    
    // and the diffuse per-fragment color
    if(DrawDiffuse)
    {
        if(texture(texture_diffuse, uv).a < 0.1)
            discard;


        if(DrawSpecular)
            DiffuseSpec = vec4(texture(texture_diffuse, uv).rgb * mat_base_col.rgb, texture(texture_specular, uv).b);
        else
            DiffuseSpec = vec4(texture(texture_diffuse, uv).rgb * mat_base_col.rgb, 0.1f);

    }
    else
        DiffuseSpec = vec4(mat_base_col.rgb, 0);
    // store specular intensity in diffuses's alpha component
}  