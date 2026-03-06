import QtQuick
import QtQuick.Layouts

Rectangle {
    color: "#252526"

    // 代理页面标题
    Text {
        id: agentTitle
        text: "代理页面"
        color: "white"
        font.pixelSize: 24
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // 代理列表区域
    Rectangle {
        id: agentListArea
        anchors.top: agentTitle.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        color: "#1a1a1a"
        border.color: "#3e3e42"
        border.width: 2
        radius: 8

        // 占位代理列表内容
        Text {
            text: "代理列表"
            color: "#666"
            font.pixelSize: 18
            anchors.centerIn: parent
        }
    }
}
