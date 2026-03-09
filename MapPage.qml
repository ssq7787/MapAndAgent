import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtPositioning
import QtWebView

Rectangle {
    color: "#2d2d30"

    readonly property bool isDesktop: {
        var platform = Qt.platform.os;
        return platform === "windows" || platform === "macos" || platform === "linux";
    }

    Component.onCompleted: {
        if (isDesktop) {
            statusText.text = "桌面端使用默认位置 (北京)";
            mapTitle.text = "地图 - 默认位置";
        } else {
            statusText.text = "正在获取定位...";
            mapTitle.text = "地图";
            positionSource.active = true;
        }
    }

    PositionSource {
        id: positionSource
        active: false

        onPositionChanged: {
            var coord = positionSource.position.coordinate;
            console.log("定位成功:", coord.latitude, coord.longitude);
            if (coord.latitude !== 0 && coord.longitude !== 0) {
                currentLat = coord.latitude;
                currentLng = coord.longitude;
                statusText.text = "定位成功";
                mapTitle.text = "地图 - 已定位";
                // 地图加载完成后更新中心
                if (mapLoader.item) {
                    mapLoader.item.updateCenter(coord.latitude, coord.longitude);
                }
            }
        }

        onSourceErrorChanged: {
            console.log("定位错误:", sourceError);
        }
    }

    property real currentLat: 39.9072
    property real currentLng: 116.3914

    readonly property string amapKey: "63c823b529dfe4d0766c202b93afe849"
    readonly property string amapSecurity: "4e6ec9eca9c6e7da2acb21b5cffb0250"

    function buildMapHtml(lat, lng) {
        return "<!DOCTYPE html><html><head>" +
            "<meta charset='utf-8'>" +
            "<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>" +
            "<title>高德地图</title>" +
            "<style>*{margin:0;padding:0;}html,body,#container{width:100%;height:100%;}</style>" +
            "<script>window._AMapSecurityConfig={securityJsCode:'" + amapSecurity + "'}</script>" +
            "<script src='https://webapi.amap.com/maps?v=2.0&key=" + amapKey + "'></script>" +
            "<script>" +
            "function initMap(){" +
            "var map=new AMap.Map('container',{zoom:16,center:[" + lng + "," + lat + "],mapStyle:'amap://styles/normal',viewMode:'2D'});" +
            "var marker=new AMap.Marker({position:[" + lng + "," + lat + "],title:'我的位置'});" +
            "map.add(marker);" +
            "window.updateCenter=function(lat,lng){map.setCenter([lng,lat]);marker.setPosition([lng,lat]);};" +
            "}" +
            "</script></head><body onload='initMap()'><div id='container'></div></body></html>";
    }

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

        Button {
            text: "刷新定位"
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                positionSource.active = true;
                positionSource.update();
                statusText.text = "正在定位...";
            }
        }
    }

    // 使用 Loader 异步加载地图
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

        // 加载指示器
        Rectangle {
            anchors.centerIn: parent
            width: 80
            height: 40
            radius: 8
            color: "#2d2d30"
            visible: !mapLoader.active

            Text {
                text: "地图加载中..."
                color: "#888"
                font.pixelSize: 12
                anchors.centerIn: parent
            }
        }

        Loader {
            id: mapLoader
            anchors.fill: parent
            active: false
            sourceComponent: Component {
                WebView {
                    id: webView
                    anchors.fill: parent
                    url: "data:text/html;charset=utf-8," + encodeURIComponent(buildMapHtml(currentLat, currentLng))

                    function updateCenter(lat, lng) {
                        if (available) {
                            runJavaScript("window.updateCenter(" + lat + "," + lng + ");");
                        }
                    }

                    onLoadingChanged: {
                        if (loadRequest.status === WebView.LoadSucceededStatus) {
                            console.log("地图加载成功");
                            statusText.text = "地图加载成功";
                        } else if (loadRequest.status === WebView.LoadFailedStatus) {
                            console.log("地图加载失败:", loadRequest.errorString);
                            statusText.text = "地图加载失败";
                        }
                    }
                }
            }
        }

        // 延迟加载地图，避免阻塞主线程
        Timer {
            id: loadTimer
            interval: 500
            onTriggered: {
                mapLoader.active = true;
            }
        }

        Component.onCompleted: {
            loadTimer.start();
        }
    }

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
}
