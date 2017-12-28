
import QtQuick 2.1
import Qt3D.Core 2.0
import Qt3D.Render 2.0

Material {
    id: root
    property int depthdebug : 0
     parameters: [ Parameter { name: "depthdebug";value:root.depthdebug }]
}
