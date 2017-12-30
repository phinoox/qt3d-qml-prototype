#version 330
in vec2 vertexTexCoord;
in vec3 vertexPosition;

out vec2 texCoord0;
out vec3 position;
uniform mat4 mvp;
uniform mat4 modelMatrix;

void main(void)
{
    position = vec4(modelMatrix * vec4(vertexPosition, 1.0)).xyz;
    gl_Position = vec4(mvp * vec4(vertexPosition, 1.0));
    texCoord0 = vertexTexCoord;
}
