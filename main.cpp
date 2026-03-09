#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QPermissions>  // 必须引入这个头文件
#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // 1. 创建定位权限对象
    QLocationPermission locationPermission;
    locationPermission.setAccuracy(QLocationPermission::Precise); // 申请高精度定位
    locationPermission.setAvailability(QLocationPermission::WhenInUse);

    // 2. 检查并请求权限
    auto status = qApp->checkPermission(locationPermission);
    if (status == Qt::PermissionStatus::Undetermined) {
        qApp->requestPermission(locationPermission, [](const QPermission &p) {
            if (p.status() == Qt::PermissionStatus::Granted) {
                qDebug() << "用户授予了定位权限！";
            } else {
                qCritical() << "用户拒绝了定位权限，地图定位将失效。";
            }
        });
    } else if (status == Qt::PermissionStatus::Denied) {
        qCritical() << "权限之前已被拒绝，请在手机设置中手动开启。";
    }

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/MapAndAgent/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}