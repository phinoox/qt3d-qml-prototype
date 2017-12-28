#version 330


in vec2 vertexTexCoord;
in vec3 vertexPosition;

uniform mat4 mvp;
uniform mat4 modelView;
uniform float fov;
uniform float far;
uniform float near;
out vec2 texcoord;
out vec3 position;
out vec2 v_fov_scale;

void main(void)
{
    position = vec3(modelView * vec4(vertexPosition, 1.0));
    texcoord = vertexTexCoord;
    float clipScale =(far - near);
    v_fov_scale.x = tan(fov / 2.0);
    v_fov_scale.y = tan(fov / 2.0);
    v_fov_scale *= 2.0;
    //v_fov_scale*=clipScale;
    gl_Position = mvp * vec4(vertexPosition, 1.0);

}
