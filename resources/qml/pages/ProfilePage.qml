import QtQuick
import QtWebEngine
import "../components"

Item {
    id: root

    property var state: ({})
    property string skinUrl: state.skinBodyUrl || ""
    property string skin3dUrl: state.skin3dUrl || ""
    property string assetsUrl: state.assetsUrl || ""
    signal navigate(string page)

    Theme { id: theme }

    function asset(name) {
        return assetsUrl !== "" ? assetsUrl + "/Images/" + name : ""
    }

    BackButton {
        x: 125
        y: 22
        assetsUrl: root.assetsUrl
        onClicked: root.navigate("home")
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: 125
        anchors.rightMargin: 35
        anchors.topMargin: 118
        anchors.bottomMargin: 38

        FrameCard {
            width: Math.min(700, parent.width)
            height: Math.min(430, parent.height)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            contentPadding: 0

            Item {
                anchors.fill: parent

                Rectangle {
                    id: header
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: 92
                    color: "#00000000"

                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 28
                        anchors.verticalCenter: parent.verticalCenter
                        width: 54
                        height: 54
                        radius: 27
                        color: theme.primary

                        SharpImage {
                            anchors.centerIn: parent
                            width: 30
                            height: 30
                            source: root.asset("profile.svg")
                            opacity: 0.9
                        }
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 98
                        anchors.right: parent.right
                        anchors.rightMargin: 28
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Text {
                            width: parent.width
                            text: "Profile"
                            color: theme.content
                            elide: Text.ElideRight
                            font.family: theme.fontFamily
                            font.pixelSize: 12
                            font.weight: Font.Medium
                        }

                        Text {
                            width: parent.width
                            text: root.state.accountName || "Player"
                            color: theme.primary
                            elide: Text.ElideRight
                            font.family: theme.fontFamily
                            font.pixelSize: 25
                            font.weight: Font.Black
                        }
                    }
                }

                Rectangle {
                    id: stage
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: header.bottom
                    anchors.bottom: actions.top
                    anchors.bottomMargin: 18
                    color: "#0D1110"
                    clip: true

                    WebEngineView {
                        id: skinViewer
                        anchors.fill: parent
                        visible: root.skin3dUrl !== ""
                        backgroundColor: "#0D1110"
                        url: root.skin3dUrl === "" ? "" : root.skin3dUrl + "/" + Math.max(1, Math.round(width)) + "/" + Math.max(1, Math.round(height))

                        onLoadingChanged: function(loadRequest) {
                            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                                skinViewer.runJavaScript(
                                    "document.documentElement.style.background='transparent';" +
                                    "document.body.style.cssText='margin:0;overflow:hidden;background:transparent';" +
                                    "document.getElementById('skin_container').style.display='block';"
                                )
                            }
                        }
                    }

                    SharpImage {
                        visible: root.skin3dUrl === ""
                        anchors.centerIn: parent
                        width: 118
                        height: 118
                        source: root.asset("profile.svg")
                        opacity: 0.34
                    }
                }

                Row {
                    id: actions
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 26
                    anchors.leftMargin: 30
                    anchors.rightMargin: 30
                    spacing: 20

                    GmlButton {
                        width: (parent.width - 40) / 3
                        kind: "secondary"
                        text: "Refresh"
                        onClicked: controller.refreshSkin()
                    }

                    GmlButton {
                        width: (parent.width - 40) / 3
                        kind: "primary"
                        text: "Upload skin"
                        onClicked: controller.uploadTexture("skin")
                    }

                    GmlButton {
                        width: (parent.width - 40) / 3
                        kind: "secondary"
                        text: "Upload cape"
                        onClicked: controller.uploadTexture("cape")
                    }
                }
            }
        }
    }
}
