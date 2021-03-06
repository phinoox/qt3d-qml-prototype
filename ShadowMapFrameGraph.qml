/****************************************************************************
**
** Copyright (C) 2014 Klaralvdalens Datakonsult AB (KDAB).
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt3D module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0

RenderSettings {
    id: root

    property alias viewCamera: viewCameraSelector.camera
    property alias sceneCamera: sceneCameraSelector.camera
    property alias lightCamera:lightCameraSelector.camera
    property int width:1024;
    property int height:1024;

    readonly property Texture2D colorTexture: colorTexture
    readonly property Texture2D normalTexture: normalTexture
    readonly property Texture2D positionTexture: positionTexture
    readonly property Texture2D depthTexture: depthTexture
    readonly property Texture2D shadowDepthTexture: shadowDepthTexture
    readonly property Layer viewLayer : viewLayer

    activeFrameGraph: Viewport {
        normalizedRect: Qt.rect(0.0, 0.0, 1.0, 1.0)

        RenderSurfaceSelector {
            RenderPassFilter {
                matchAny: [ FilterKey { name: "pass"; value: "shadowmap" } ]

                RenderTargetSelector {
                    target: RenderTarget {
                        attachments: [
                            RenderTargetOutput {
                                objectName: "depth"
                                attachmentPoint: RenderTargetOutput.Depth
                                texture: Texture2D {
                                    id: shadowDepthTexture
                                    width: 1024
                                    height: 1024
                                    format: Texture.DepthFormat
                                    generateMipMaps: false
                                    magnificationFilter: Texture.Linear
                                    minificationFilter: Texture.Linear
                                    wrapMode {
                                        x: WrapMode.ClampToEdge
                                        y: WrapMode.ClampToEdge
                                    }
                                    comparisonFunction: Texture.CompareLessEqual
                                    comparisonMode: Texture.CompareRefToTexture
                                }
                            }
                        ]
                    }

                    ClearBuffers {
                        buffers: ClearBuffers.ColorDepthBuffer

                        CameraSelector {
                            id: lightCameraSelector
                        }
                    }
                }
            }


        RenderPassFilter {
            matchAny: [ FilterKey { name: "pass"; value: "default" } ]

            RenderTargetSelector {
                target: RenderTarget {
                    attachments: [
                        RenderTargetOutput {
                            objectName: "colorTexture"
                            attachmentPoint: RenderTargetOutput.Color0
                            texture: Texture2D {
                                id: colorTexture
                                width: root.width
                                height: root.height
                                format: Texture.RGBA32F
                                generateMipMaps: false
                                magnificationFilter: Texture.Linear
                                minificationFilter: Texture.Linear
                                wrapMode {
                                    x: WrapMode.ClampToEdge
                                    y: WrapMode.ClampToEdge
                                }
                                comparisonFunction: Texture.CompareLessEqual
                                comparisonMode: Texture.CompareRefToTexture
                            }
                        },
                        RenderTargetOutput {
                            objectName: "normalTexture"
                            attachmentPoint: RenderTargetOutput.Color1
                            texture: Texture2D {
                                id: normalTexture
                                width: root.width
                                height: root.height
                                format: Texture.RGBA32F
                                generateMipMaps: false
                                magnificationFilter: Texture.Linear
                                minificationFilter: Texture.Linear
                                wrapMode {
                                    x: WrapMode.ClampToEdge
                                    y: WrapMode.ClampToEdge
                                }
                                comparisonFunction: Texture.CompareLessEqual
                                comparisonMode: Texture.CompareRefToTexture
                            }
                        },
                        RenderTargetOutput {
                            objectName: "positionTexture"
                            attachmentPoint: RenderTargetOutput.Color2
                            texture: Texture2D {
                                id: positionTexture
                                width: root.width
                                height: root.height
                                format: Texture.RGB32F
                                generateMipMaps: false
                                magnificationFilter: Texture.Linear
                                minificationFilter: Texture.Linear
                                wrapMode {
                                    x: WrapMode.ClampToEdge
                                    y: WrapMode.ClampToEdge
                                }
                                comparisonFunction: Texture.CompareLessEqual
                                comparisonMode: Texture.CompareRefToTexture
                            }
                        },
                        RenderTargetOutput {
                            objectName: "depthTexture"
                            attachmentPoint: RenderTargetOutput.Depth
                            texture: Texture2D {
                                id: depthTexture
                                width: root.width
                                height: root.height
                                format: Texture.DepthFormat
                                generateMipMaps: false
                                magnificationFilter: Texture.Linear
                                minificationFilter: Texture.Linear
                                wrapMode {
                                    x: WrapMode.ClampToEdge
                                    y: WrapMode.ClampToEdge
                                }
                                comparisonFunction: Texture.CompareLessEqual
                                comparisonMode: Texture.CompareRefToTexture

                            }
                        }
                    ]
                }

                ClearBuffers {
                    buffers: ClearBuffers.ColorDepthBuffer
                    clearColor: Qt.rgba(1.0,0,0,1)
                    CameraSelector {
                        id: sceneCameraSelector
                        LayerFilter {
                            layers: [viewLayer]
                            filterMode: LayerFilter.DiscardAnyMatchingLayers
                        }
                        FrustumCulling {}

                    }
                }
            }
        }




        RenderPassFilter {
            matchAny: [ FilterKey { name: "pass"; value: "final" } ]

            ClearBuffers {
                clearColor: Qt.rgba(0.0, 0.0, 1.0, 1.0)
                buffers: ClearBuffers.ColorDepthBuffer

                CameraSelector {
                    id: viewCameraSelector
                    camera: sceneCameraSelector.camera
                    LayerFilter {
                        layers:[
                            Layer {
                                id:viewLayer
                            }
                        ]
                    }
                }
            }
        }
    }
}
}
