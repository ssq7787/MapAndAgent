import QtQuick
import QtQuick.Layouts

Rectangle {
    color: "#1e1e1e"

    // 设置页面标题
    Text {
        id: settingsTitle
        text: "设置页面"
        color: "white"
        font.pixelSize: 24
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // 设置选项区域
    Rectangle {
        id: settingsArea
        anchors.top: settingsTitle.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        color: "#1a1a1a"
        border.color: "#3e3e42"
        border.width: 2
        radius: 8

        // 占位设置内容
        Text {
            text: "设置选项"
            color: "#666"
            font.pixelSize: 18
            anchors.centerIn: parent
        }
    }
}
