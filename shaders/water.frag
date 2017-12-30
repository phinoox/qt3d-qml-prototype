#version 150 core

in vec3 worldPosition;
in vec3 worldNormal;
in vec4 worldTangent;
in vec2 texCoord;
in vec2 waveTexCoord;
in vec2 movtexCoord;
in vec2 multexCoord;
in vec2 skyTexCoord;

in vec3 vpos;

in vec3 color;

uniform sampler2D diffuseTexture;
uniform sampler2D specularTexture;
uniform sampler2D normalTexture;
uniform sampler2D waveTexture;
uniform sampler2D skyTexture;
uniform sampler2D foamTexture;
uniform sampler2DShadow shadowMapTexture;

in vec4 positionInLightSpace;

uniform float offsetx;
uniform float offsety;
uniform float specularity;
uniform float waveStrenght;
uniform vec4 ka;
uniform vec3 specularColor;
uniform float shininess;
uniform float normalAmount;
uniform vec3 eyePosition;



//where the hell is this shit?!?
//#pragma include phong.inc.frag
//#pragma include coordinatesystems.inc



vec4 phongFunction(vec4 ka,vec4 diffuse,vec4 specular,float shininess,vec3 worldPosition,vec3 worldView,vec3 wNormal)
{
 //return lightIntesity *(ka+kd*diffuse +ks*specular
    vec3 L = normalize(worldPosition -worldView);
      vec3 E = normalize(-worldView); // we are in Eye Coordinates, so EyePos is (0,0,0)
      vec3 R = normalize(-reflect(L,wNormal));

      //calculate Ambient Term:
      vec4 Iamb = ka;

      //calculate Diffuse Term:
      vec4 Idiff = diffuse * max(dot(wNormal,L), 0.0);
      Idiff = clamp(Idiff, 0.0, 1.0);

      // calculate Specular Term:
      vec4 Ispec = specular
                   * pow(max(dot(R,E),0.0),0.3*shininess);
      Ispec = clamp(Ispec, 0.0, 1.0);
      // write Total Color:
      return diffuse + Iamb + Idiff + Ispec;
}

void main()
{
    // Move waveTexCoords
    vec2 waveMovCoord = waveTexCoord;
    waveMovCoord.x += offsetx;
    waveMovCoord.y -= offsety;
    vec4 wave = texture2D(waveTexture, waveMovCoord);

    //Wiggle the newCoord by r and b colors of waveTexture
    vec2 newCoord = texCoord;
    newCoord.x += wave.r * waveStrenght;
    newCoord.y -= wave.b * waveStrenght;

    // Sample the textures at the interpolated texCoords
    // Use default texCoord for diffuse (it does not move on x or y, so it can be used as "ground under the water").
    vec4 diffuseTextureColor = texture2D(diffuseTexture, texCoord);
    // 2 Animated Layers of specularTexture mixed with the newCoord
    vec4 specularTextureColor = texture2D( specularTexture, multexCoord+newCoord) + (texture2D( specularTexture, movtexCoord+newCoord ));
    // 2 Animated Layers of normalTexture mixed with the newCoord
    vec3 tNormal = normalAmount * texture2D( normalTexture, movtexCoord+newCoord ).rgb - vec3( 1.0 )+(normalAmount * texture2D( normalTexture, multexCoord+newCoord ).rgb - vec3( 1.0 ));
    // Animated skyTexture layer
    vec4 skycolor = texture2D(skyTexture, skyTexCoord);
    skycolor = skycolor * 0.4;
    //Animated foamTexture layer
    vec4 foamTextureColor = texture2D(foamTexture, texCoord);

    //mat3 tangentMatrix = calcWorldSpaceToTangentSpaceMatrix(worldNormal, worldTangent);
    //mat3 invertTangentMatrix = transpose(tangentMatrix);
    mat3 invertTangentMatrix = mat3(vec3(1,0,0),vec3(0,1,0),vec3(0,0,1));
    vec3 wNormal = normalize(invertTangentMatrix * tNormal);
    vec3 worldView = normalize(eyePosition - worldPosition);

    vec4 diffuse = vec4(diffuseTextureColor.rgb, vpos.y);
    vec4 specular = vec4(specularTextureColor.a*specularity);
    vec4 outputColor = phongFunction(ka, diffuse, specular, shininess, worldPosition, worldView, wNormal);

    outputColor += vec4(skycolor.rgb, vpos.y);
    outputColor += (foamTextureColor.rgba*vpos.y);
    vec4 fragColor = vec4(outputColor.rgb,1.0);
 float shadowMapSample = textureProj(shadowMapTexture, positionInLightSpace);
 if (shadowMapSample <= 0)
    fragColor*=0.25;

 //diffuse
 gl_FragData[0]= fragColor;

 //normal
 gl_FragData[1]=vec4(wNormal,1);
 //position
 gl_FragData[2]=vec4(worldPosition,1.0);

}

