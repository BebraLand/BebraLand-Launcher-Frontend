import QtQuick

Image {
    id: root

    property real renderScale: 4

    fillMode: Image.PreserveAspectFit
    smooth: true
    mipmap: true
    asynchronous: true
    sourceSize.width: width > 0 ? Math.ceil(width * renderScale) : 0
    sourceSize.height: height > 0 ? Math.ceil(height * renderScale) : 0
}
