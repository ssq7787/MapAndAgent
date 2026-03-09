cmake_minimum_required(VERSION 3.16)

project(MapAndAgent VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 检测平台，选择对应的 Qt 模块
find_package(Qt6 6.8 COMPONENTS Quick Positioning WebView REQUIRED)
set(QT_LIBRARIES Qt6::Quick Qt6::Positioning Qt6::WebView)

# Android 配置 - 必须在这里设置
if(CMAKE_SYSTEM_NAME STREQUAL "Android")
    set(ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android CACHE PATH "Android package source directory")
endif()

qt_add_executable(appMapAndAgent
    main.cpp
)

qt_add_qml_module(appMapAndAgent
    URI MapAndAgent
    VERSION 1.0
    QML_FILES
        main.qml
        MapPage.qml
        AgentPage.qml
        SettingsPage.qml
)

set_target_properties(appMapAndAgent PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMapAndAgent
    PRIVATE ${QT_LIBRARIES})

include(GNUInstallDirs)
install(TARGETS appMapAndAgent
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
