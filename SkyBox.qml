/****************************************************************************
**
** Copyright (C) 2015 Klaralvdalens Datakonsult AB (KDAB).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt3D module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0

Entity {

    property alias cameraPosition: transform.translation;
    property string sourceDirectory: "";
    property string extension: ".webp"

    property TextureCubeMap skyboxTexture: TextureCubeMap {
        generateMipMaps: false
        magnificationFilter: Texture.Linear
        minificationFilter: Texture.Linear
        wrapMode {
            x: WrapMode.ClampToEdge
            y: WrapMode.ClampToEdge
        }
        TextureImage {  face: Texture.CubeMapPositiveX; source: sourceDirectory + "_posx" + extension }
        TextureImage { face: Texture.CubeMapPositiveY; source: sourceDirectory + "_posy" + extension }
        TextureImage { face: Texture.CubeMapPositiveZ; source: sourceDirectory + "_posz" + extension }
        TextureImage { face: Texture.CubeMapNegativeX; source: sourceDirectory + "_negx" + extension }
        TextureImage { face: Texture.CubeMapNegativeY; source: sourceDirectory + "_negy" + extension }
        TextureImage { face: Texture.CubeMapNegativeZ; source: sourceDirectory + "_negz" + extension }
    }

    ShaderProgram {
        id: gl3SkyboxShader
        vertexShaderCode: loadSource("qrc:/shaders/skybox.vert")
        fragmentShaderCode: loadSource("qrc:/shaders/skybox.frag")
    }


    CuboidMesh {
        id: cuboidMesh
        yzMeshResolution: Qt.size(10, 10)
        xzMeshResolution: Qt.size(10, 10)
        xyMeshResolution: Qt.size(10, 10)

    }

    Transform {
        id: transform
        translation: Qt.vector3d(0,0,0)
    }

    Material {
        id: skyboxMaterial
        property real time:0
        parameters: [
        Parameter { name: "skyboxTexture"; value: skyboxTexture},
        Parameter { name: "time"; value: skyboxMaterial.time}
        ]

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
                        filterKeys: [ FilterKey { name: "pass"; value: "default" } ]

                        shaderProgram: gl3SkyboxShader
                        renderStates: [
                            // cull front faces
                            CullFace { mode: CullFace.Front },
                             DepthTest { depthFunction: DepthTest.LessOrEqual },
                            NoDepthMask {}
                        ]
                    }
                }
              ]
        }
    }

    components: [cuboidMesh, skyboxMaterial, transform]
    QQ2.SequentialAnimation {
        running: true
        loops: QQ2.Animation.Infinite
        QQ2.NumberAnimation {
            target: skyboxMaterial
            property: "time"
            from:0
            to:1
            duration: 100000

        }
    }
}
