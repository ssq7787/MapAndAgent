import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtPositioning
import QtLocation

Rectangle {
    color: "#2d2d30"

    // 定位源
    PositionSource {
        id: positionSource
        active: true

        onPositionChanged: {
            var coord = positionSource.position.coordinate;
            console.log("定位成功: " + coord.latitude + ", " + coord.longitude);
            updateMapImage(coord.latitude, coord.longitude);
        }

        onSourceErrorChanged: {
            console.log("定位错误: " + sourceError);
            statusText.text = "定位失败，请检查定位权限";
        }
    }

    // 标题栏
    Rectangle {
        id: titleBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: "#2d2d30"

        Text {
            id: mapTitle
            text: "地图"
            color: "white"
            font.pixelSize: 24
            anchors.centerIn: parent
        }

        // 刷新定位按钮
        Button {
            id: refreshBtn
            text: "刷新定位"
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                positionSource.update();
                statusText.text = "正在重新定位...";
            }
        }
    }

    // 地图显示区域
    Rectangle {
        id: mapArea
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: statusBar.top
        anchors.margins: 20
        color: "#1a1a1a"
        border.color: "#3e3e42"
        border.width: 2
        radius: 8

        // 地图图片
        Image {
            id: mapImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: ""

            onStatusChanged: {
                if (status === Image.Error) {
                    console.log("地图加载失败");
                }
            }
        }

        // 加载中提示
        Text {
            id: loadingText
            text: "正在加载地图..."
            color: "#666"
            font.pixelSize: 16
            anchors.centerIn: parent
            visible: mapImage.status !== Image.Ready
        }

        // 坐标显示
        Text {
            id: coordText
            text: "经纬度: --"
            color: "white"
            font.pixelSize: 14
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            visible: mapImage.status === Image.Ready
        }

        // 定位标记
        Rectangle {
            id: marker
            width: 20
            height: 20
            color: "#007AFF"
            border.color: "white"
            border.width: 2
            radius: 10
            anchors.centerIn: parent
            visible: mapImage.status === Image.Ready
        }
    }

    // 状态栏
    Rectangle {
        id: statusBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40
        color: "#1a1a1a"

        Text {
            id: statusText
            text: "正在获取定位..."
            color: "#888"
            font.pixelSize: 12
            anchors.centerIn: parent
        }
    }

    // 更新地图图片
    function updateMapImage(lat, lng) {
        // 高德静态地图 API
        var apiKey = "63c823b529dfe4d0766c202b93afe849";
        var zoom = 15;
        var size = "600*400";

        // 构建静态地图 URL
        var mapUrl = "https://restapi.amap.com/v3/staticmap?"
                   + "location=" + lng + "," + lat
                   + "&zoom=" + zoom
                   + "&size=" + size
                   + "&key=" + apiKey
                   + "&markers=mid,,," + lng + "," + lat;

        mapImage.source = mapUrl;
        coordText.text = "经纬度: " + lat.toFixed(6) + ", " + lng.toFixed(6);
        statusText.text = "定位成功";
        mapTitle.text = "地图 - 已定位";
    }
}
