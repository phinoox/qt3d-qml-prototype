import QtQuick 2.1 as QQ2
import Qt3D.Core 2.3
import Qt3D.Render 2.2
import Qt3D.Extras 2.0

Entity {
    id: root
    property Material material
    property Layer layer

    PlaneMesh {
        id: quadMesh
        width: 2
        height: 2
        meshResolution: Qt.size(2, 2)

    }

    Transform {
        id: basic
        property real rollAngle: -90
        translation: Qt.vector3d(0, 0, -1)
        rotation: fromAxisAndAngle(Qt.vector3d(1.0, 0, 0),rollAngle)
    }


    components: [
        quadMesh,
        basic,
        material,
        layer
    ]
    // QQ2.NumberAnimation { target: basic; property: "rollAngle"; from: -90; to: 0; duration: 2000; easing.type: QQ2.Easing.OutInQuad;running: true;loops: QQ2.Animation.Infinite }
}
