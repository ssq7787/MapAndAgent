cmake_minimum_required(VERSION 3.16)

project(MapAndAgent VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 COMPONENTS Quick Positioning REQUIRED)

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

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should set an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMapAndAgent PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMapAndAgent
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMapAndAgent
    PRIVATE Qt6::Quick Qt6::Positioning)

include(GNUInstallDirs)
install(TARGETS appMapAndAgent
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
