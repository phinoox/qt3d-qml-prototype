import QtQuick 2.0

import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import QtQuick 2.0 as QQ2


Entity {
    id:root
    property Material material
    property Layer layer
    property alias position :transform.translation
    property real linear:1;
    property real exp:1;
    property real intensity:1;
    property color diffuse:Qt.rgba(1,1,1,1);
    property alias radius: transform.scale
    property Texture2D colorTexture
    property Texture2D normalTexture
    property Texture2D positionTexture
    property size screenSize;
    onLinearChanged: root.radius=calcPointLightBSphere(root.linear,root.exp,root.intensity,root.diffuse)
    onExpChanged: root.radius=calcPointLightBSphere(root.linear,root.exp,root.intensity,root.diffuse)
    onIntensityChanged: root.radius=calcPointLightBSphere(root.linear,root.exp,root.intensity,root.diffuse)

    Material {
        id: pointLightMaterial

        parameters: [
            Parameter { name: "linear"; value: root.linear},
            Parameter { name: "exp"; value: root.exp},
            Parameter { name: "intensity"; value: root.intensity},
            Parameter { name: "diffuse"; value: root.diffuse},
            Parameter { name: "screenSize"; value: root.screenSize},

            Parameter { name: "colorTexture"; value: root.colorTexture },
            Parameter { name: "normalTexture"; value: root.normalTexture },
            Parameter { name: "positionTexture"; value: root.positionTexture }

        ]
        ShaderProgram {
            id: gl3PointLightShader
            vertexShaderCode: loadSource("qrc:/shaders/pointlight.vert")
            fragmentShaderCode: loadSource("qrc:/shaders/pointlight.frag")
        }


        effect: Effect {

            techniques: [
                // GL3 Technique
                Technique {
                    graphicsApiFilter {
                        api: GraphicsApiFilter.OpenGL
                        profile: GraphicsApiFilter.CoreProfile
                        majorVersion: 3
                        minorVersion: 2
                    }
                    renderPasses: RenderPass {
                        filterKeys: [ FilterKey { name: "pass"; value: "light" } ]

                        shaderProgram: gl3PointLightShader
                        renderStates: [
                            DepthTest { depthFunction: DepthTest.LessOrEqual },
                            NoDepthMask {}
                        ]
                    }
                }
            ]
        }



    }
    Transform {
        id: transform
        translation: Qt.vector3d(0,1,0)
        scale: 1
    }
   /* Mesh {
        id: smoothSphereMesh
        source: "assets/obj/smoothsphere.obj"
    }*/

    SphereMesh {
        id: smoothSphereMesh
        rings: 36
        slices:36
    }

    components: [
        smoothSphereMesh,
        pointLightMaterial,
        transform,
        layer
    ]

    function calcPointLightBSphere( linear, exp, intensity, diffuse)
    {
        var MaxChannel = Math.max(Math.max(diffuse.r,diffuse.g), diffuse.b);

        var ret = (-linear + Math.sqrt(linear * linear -
            4 * exp * (exp - 256 * MaxChannel * intensity)))
                /
            (2 * exp);
        return ret;
    }
    QQ2.SequentialAnimation {
        running: true
        loops: QQ2.Animation.Infinite
        QQ2.NumberAnimation {
            target: root
            property: "intensity"
            from:1
            to:5
            duration: 10000
             easing.type: QQ2.Easing.OutQuad
        }
        QQ2.NumberAnimation {
            target: root
            property: "intensity"
            from:5
            to:1
            duration: 10000
             easing.type: QQ2.Easing.OutQuad
        }
    }



}
