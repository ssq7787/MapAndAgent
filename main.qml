import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Window {
    // ==================== 窗口属性 ====================
    readonly property int desktopWidth: 1280
    readonly property int desktopHeight: 720

    width: isMobile ? Screen.desktopAvailableWidth : desktopWidth
    height: isMobile ? Screen.desktopAvailableHeight : desktopHeight

    readonly property bool isMobile: {
        var platform = Qt.platform.os;
        return platform === "android" || platform === "ios" ||
               platform === "winphone" || platform === "qnx";
    }

    property int currentIndex: 0

    visible: true
    title: qsTr("MapAndAgent")

    // ==================== 主布局 ====================
    Rectangle {
        id: mainContainer
        anchors.fill: parent
        color: "#1e1e1e"

        // 桌面端: RowLayout (左侧导航 | 右侧内容)
        RowLayout {
            id: mainLayout
            anchors.fill: parent
            spacing: 0

            // 桌面端: 左侧导航栏
            Rectangle {
                id: navBarLeft
                Layout.fillHeight: true
                Layout.fillWidth: false
                Layout.preferredWidth: 120
                color: "#2d2d30"

                visible: !isMobile

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    // 地图按钮 - 直接用 Button
                    Button {
                        text: "地图"
                        checked: currentIndex === 0
                        onClicked: currentIndex = 0
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                    }
                    Button {
                        text: "代理"
                        checked: currentIndex === 1
                        onClicked: currentIndex = 1
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                    }
                    Button {
                        text: "设置"
                        checked: currentIndex === 2
                        onClicked: currentIndex = 2
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                    }
                }
            }

            // 内容区域
            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "#1e1e1e"

                StackLayout {
                    anchors.fill: parent
                    currentIndex: currentIndex

                    PageMap {}
                    PageAgent {}
                    PageSettings {}
                }
            }
        }

        // 移动端: 底部导航栏
        Rectangle {
            id: navBarBottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60
            color: "#2d2d30"

            visible: isMobile

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Button {
                    text: "地图"
                    checked: currentIndex === 0
                    onClicked: currentIndex = 0
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 40
                }
                Button {
                    text: "代理"
                    checked: currentIndex === 1
                    onClicked: currentIndex = 1
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 40
                }
                Button {
                    text: "设置"
                    checked: currentIndex === 2
                    onClicked: currentIndex = 2
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 40
                }
            }
        }
    }

    // ==================== 页面组件 ====================
    component PageMap: Rectangle {
        color: "#2d2d30"

        Text {
            text: "地图页面"
            color: "white"
            font.pixelSize: 24
            anchors.centerIn: parent
        }
    }

    component PageAgent: Rectangle {
        color: "#252526"

        Text {
            text: "代理页面"
            color: "white"
            font.pixelSize: 24
            anchors.centerIn: parent
        }
    }

    component PageSettings: Rectangle {
        color: "#1e1e1e"

        Text {
            text: "设置页面"
            color: "white"
            font.pixelSize: 24
            anchors.centerIn: parent
        }
    }
}
