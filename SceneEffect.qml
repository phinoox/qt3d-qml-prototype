import Qt3D.Core 2.0
import Qt3D.Render 2.0

Effect {
    id: root

    property Texture2D colorTexture
    property Texture2D depthTexture
    property Texture2D normalTexture
    property Texture2D positionTexture
    property vector3d cameraPosition;
    property real fov;
    property real near;
    property real far;

    // These parameters act as default values for the effect. They take
    // priority over any parameters specified in the RenderPasses below
    // (none provided in this example). In turn these parameters can be
    // overwritten by specifying them in a Material that references this
    // effect.
    // The priority order is:
    //
    // Material -> Effect -> Technique -> RenderPass -> GLSL default values
    parameters: [
        Parameter { name: "colorTexture"; value: root.colorTexture },
        Parameter { name: "normalTexture"; value: root.normalTexture },
        Parameter { name: "positionTexture"; value: root.positionTexture },
        Parameter { name: "depthTexture"; value: root.depthTexture },
        Parameter { name: "cameraPosition";value:root.cameraPosition },
        Parameter { name: "fov";value:root.fov},
        Parameter { name: "near";value:root.near},
        Parameter { name: "far";value:root.far}
    ]

    techniques: [
        Technique {
            graphicsApiFilter {
                api: GraphicsApiFilter.OpenGL
                profile: GraphicsApiFilter.CoreProfile
                majorVersion: 3
                minorVersion: 2
            }

            renderPasses: [
                RenderPass {
                    filterKeys: [ FilterKey { name: "pass"; value: "final" } ]

                    shaderProgram: ShaderProgram {
                        vertexShaderCode:   loadSource("qrc:/shaders/scene.vert")
                        fragmentShaderCode: loadSource("qrc:/shaders/scene.frag")
                    }

                }
            ]
        }
    ]
}
