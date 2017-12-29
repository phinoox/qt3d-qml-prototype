#version 330
in vec3 texCoord0;
uniform samplerCube skyboxTexture;

void main()
{
    gl_FragData[0] = textureCube(skyboxTexture, texCoord0);
}
