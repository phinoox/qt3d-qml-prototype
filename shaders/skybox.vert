#version 330
in vec2 vertexTexCoord;
in vec3 vertexPosition;

out vec3 texCoord0;

uniform mat4 mvp;
uniform mat4 inverseProjectionMatrix;
uniform mat4 inverseModelView;
uniform float time;

void main()
{
    texCoord0 = vec3(vertexPosition.x+time,vertexPosition.y,vertexPosition.z+time);

    gl_Position = vec4(mvp * vec4(vertexPosition, 1.0)).xyww;
}
