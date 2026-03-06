import QtQuick
import QtQuick.Layouts

Rectangle {
    color: "#2d2d30"

    // 地图页面标题
    Text {
        id: mapTitle
        text: "地图页面"
        color: "white"
        font.pixelSize: 24
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // 地图显示区域
    Rectangle {
        id: mapArea
        anchors.top: mapTitle.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        color: "#1a1a1a"
        border.color: "#3e3e42"
        border.width: 2
        radius: 8

        // 占位地图内容
        Text {
            text: "地图显示区域"
            color: "#666"
            font.pixelSize: 18
            anchors.centerIn: parent
        }
    }
}
