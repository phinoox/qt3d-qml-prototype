!include( ../examples.pri ) {
    error( "Couldn't find the examples.pri file!" )
}

QT += 3dcore 3drender 3dinput 3dquick qml quick 3dquickextras

SOURCES += \
    main.cpp

OTHER_FILES += \
    main.qml \
    AdsMaterial.qml \
    AdsEffect.qml \
    ShadowMapLight.qml \
    ShadowMapFrameGraph.qml \
    Trefoil.qml \
    Toyplane.qml \
    SceneEffect.qml \
    SceneMaterial.qml

RESOURCES += \
    shadow-map-qml.qrc \
    obj.qrc \
    assets.qrc

DISTFILES += \
    shaders/default.vert \
    shaders/default.frag \
    SceneEffect.qml \
    SceneMaterial.qml \
    shaders/scene.vert \
    shaders/scene.frag \
    SkyBox.qml \
    shaders/skybox.vert \
    shaders/skybox.frag \
    WaterPlane.qml \
    WaterMaterial.qml \
    shaders/water.vert \
    shaders/water.frag
