#version 330
in vec2 texCoord0;
in vec3 position;
out vec4 fragColor;


uniform float linear;
uniform float exp;
uniform float intensity;
uniform vec4 diffuse;

uniform sampler2D colorTexture;
uniform sampler2D normalTexture;
uniform sampler2D positionTexture;
uniform vec3 eyePosition;
uniform vec2 screenSize;
uniform mat4 viewMatrix;

vec2 CalcTexCoord()
{
    return gl_FragCoord.xy / screenSize;
}

vec4 CalcLightInternal(vec3 LightDirection, vec3 Normal,vec3 wPos)
{
    vec4 AmbientColor = diffuse * intensity;
    float DiffuseFactor = dot(Normal, -LightDirection);
    float specularPower=1.0;
    vec4 DiffuseColor = vec4(0, 0, 0, 0);
    vec4 SpecularColor = vec4(0, 0, 0, 0);
    vec3 eyeView = (viewMatrix *vec4(eyePosition,1.0)).xyz;
    if (DiffuseFactor > 0) {
        DiffuseColor = diffuse * intensity;
        vec3 VertexToEye = normalize(eyePosition - wPos);
        vec3 LightReflect = normalize(reflect(LightDirection, Normal));
        float SpecularFactor = dot(VertexToEye, LightReflect);
        if (SpecularFactor > 0) {
            SpecularFactor = pow(SpecularFactor, specularPower);
            SpecularColor = vec4(diffuse * intensity * SpecularFactor);
        }
    }

    return (AmbientColor + DiffuseColor + SpecularColor);
    //return ( DiffuseColor + SpecularColor);
}


vec4 CalcPointLight(vec3 wPos,vec3 normal)
{
    float constant=0;
    vec3 LightDirection = wPos - position;
    float Distance = length(LightDirection);
    LightDirection = normalize(LightDirection);

    vec4 Color = CalcLightInternal( LightDirection, normal,wPos);
    float Attenuation = constant +
            linear * Distance +
            exp * Distance * Distance;

    return Color / Attenuation;
}

void main(void)
{
    vec2 TexCoord = CalcTexCoord();
    vec3 WorldPos = texture2D(positionTexture, TexCoord).xyz;
    vec3 Color = texture2D(colorTexture, TexCoord).xyz;
    vec3 Normal = texture2D(normalTexture, TexCoord).xyz;
    Normal = normalize(Normal);

    fragColor = vec4(Color, 1.0) + CalcPointLight(WorldPos, Normal);
}
