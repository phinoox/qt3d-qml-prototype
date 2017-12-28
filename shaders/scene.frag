#version 330
uniform sampler2D colorTexture;
uniform sampler2D normalTexture;
uniform sampler2D positionTexture;
uniform sampler2D depthTexture;
uniform vec3 cameraPosition;
uniform int depthdebug;

in vec3 position;
in vec2 texcoord;
in vec2 v_fov_scale;
out vec4 fragColor;

float LinearizeDepth(in vec2 uv)
{
    float zNear = 0.1;    // TODO: Replace by the zNear of your perspective projection
    float zFar  = 100.0; // TODO: Replace by the zFar  of your perspective projection
    float depth = texture2D(depthTexture, uv).x;
    return (2.0 * zNear) / (zFar + zNear - depth * (zFar - zNear));
}

vec3 calculate_view_position(vec2 texture_coordinate, float depth, vec2 scale_factor)  // "scale_factor" is "v_fov_scale".
{
    vec2 half_ndc_position = vec2(0.5) - texture_coordinate;    // No need to multiply by two, because we already baked that into "v_tan_fov.xy".
    vec3 view_space_position = vec3(half_ndc_position * scale_factor.xy * -depth, -depth); // "-depth" because in OpenGL the camera is staring down the -z axis (and we're storing the unsigned depth).
    return(view_space_position);
}


void main(void)
{
    vec4 image = texture2D( colorTexture, texcoord.xy );
    vec3 worldPosition = texture2D( positionTexture, texcoord.xy ).xyz;
    vec4 normal = texture2D( normalTexture, texcoord.xy );
    float depth = LinearizeDepth(texcoord);// texture2D(depthTexture,texcoord.xy).r;
    vec3 light = vec3(50,100,50);
    vec3 lightDir = light - worldPosition ;

    normal = normalize(normal);
    lightDir = normalize(lightDir);
    vec3 viewSpacePos = calculate_view_position(texcoord,depth,v_fov_scale);
    vec3 eyeDir = normalize(cameraPosition-worldPosition);
    vec3 vHalfVector = normalize(lightDir.xyz+eyeDir);
    vec4 test = max(dot(normal.xyz,lightDir),0) * image +
            pow(max(dot(normal.xyz,vHalfVector),0.0), 100) * 1.5;

    fragColor=test;


}

