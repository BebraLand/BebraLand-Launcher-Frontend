import QtQuick
import QtQuick.Controls
import "../components"

Item {
    id: root

    property var state: ({})
    property var mods: state.optionalMods || []
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
        id: body
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 125
        anchors.rightMargin: 35
        anchors.topMargin: 135
        anchors.bottomMargin: 40

        FrameCard {
            id: infoCard
            anchors.left: parent.left
            anchors.top: parent.top
            width: 300
            height: 178

            Column {
                anchors.fill: parent
                spacing: 14

                Row {
                    spacing: 10
                    SharpImage {
                        width: 28
                        height: 28
                        source: root.asset("folder.svg")
                    }
                    Text {
                        text: "Mods"
                        color: theme.headline
                        font.family: theme.fontFamily
                        font.pixelSize: 22
                        font.weight: Font.Black
                    }
                }

                Text {
                    width: parent.width - 38
                    x: 38
                    text: "Optional mods for selected profile."
                    color: theme.content
                    wrapMode: Text.WordWrap
                    lineHeight: 1.35
                    font.family: theme.fontFamily
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }
            }
        }

        Item {
            anchors.left: infoCard.right
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            FrameCard {
                visible: root.mods.length === 0
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 150

                Row {
                    anchors.fill: parent
                    spacing: 18

                    SharpImage {
                        width: 48
                        height: 48
                        source: root.asset("folder.svg")
                        opacity: 0.7
                    }

                    Column {
                        width: parent.width - 66
                        spacing: 8

                        Text {
                            text: "Empty"
                            color: theme.headline
                            font.family: theme.fontFamily
                            font.pixelSize: 22
                            font.weight: Font.Black
                        }

                        Text {
                            width: parent.width
                            text: "No optional mods in this profile."
                            color: theme.content
                            wrapMode: Text.WordWrap
                            font.family: theme.fontFamily
                            font.pixelSize: 14
                            font.weight: Font.Medium
                        }
                    }
                }
            }

            Flickable {
                id: flick
                visible: root.mods.length > 0
                anchors.fill: parent
                anchors.rightMargin: 14
                clip: true
                contentWidth: width
                contentHeight: modsColumn.implicitHeight
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar {
                    width: 6
                    policy: flick.contentHeight > flick.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                    contentItem: Rectangle {
                        radius: 3
                        color: parent.pressed ? theme.primary : "#80FFFFFF"
                    }
                    background: Rectangle {
                        radius: 3
                        color: "#22000000"
                    }
                }

                Column {
                    id: modsColumn
                    width: flick.width
                    spacing: 10

                    Repeater {
                        model: root.mods

                        delegate: Rectangle {
                            id: rowCard
                            width: modsColumn.width
                            height: Math.max(98, textColumn.implicitHeight + 40)
                            radius: 20
                            color: theme.frame
                            border.width: 1
                            border.color: theme.frameBorder

                            function roundedContains(x, y, width, height, radius) {
                                if (x < 0 || y < 0 || x > width || y > height)
                                    return false

                                var r = Math.max(0, Math.min(radius, width / 2, height / 2))
                                var cx = Math.max(r, Math.min(x, width - r))
                                var cy = Math.max(r, Math.min(y, height - r))
                                var dx = x - cx
                                var dy = y - cy
                                return dx * dx + dy * dy <= r * r
                            }

                            Row {
                                anchors.fill: parent
                                anchors.margins: 20
                                spacing: 18

                                CheckRow {
                                    anchors.verticalCenter: parent.verticalCenter
                                    checked: !!modelData.enabled
                                    text: ""
                                    onToggled: function(checked) {
                                        controller.toggleOptionalMod(modelData.id || "", checked)
                                    }
                                }

                                Column {
                                    id: textColumn
                                    width: parent.width - 58
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 8

                                    Text {
                                        width: parent.width
                                        text: modelData.name || modelData.id || "Mod"
                                        color: theme.headline
                                        elide: Text.ElideRight
                                        font.family: theme.fontFamily
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                    }

                                    Row {
                                        width: parent.width
                                        spacing: 6

                                        Rectangle {
                                            width: defaultLabel.implicitWidth + 16
                                            height: 24
                                            radius: 12
                                            color: modelData.defaultEnabled ? "#173B26" : theme.form
                                            border.color: modelData.defaultEnabled ? "#1F7E44" : theme.formBorderHover
                                            border.width: 1

                                            Text {
                                                id: defaultLabel
                                                anchors.centerIn: parent
                                                text: modelData.defaultEnabled ? "Default on" : "Default off"
                                                color: modelData.defaultEnabled ? "#BDF5D0" : theme.content
                                                font.family: theme.fontFamily
                                                font.pixelSize: 11
                                                font.weight: Font.Bold
                                            }
                                        }

                                        Rectangle {
                                            visible: !!modelData.requiresText
                                            width: Math.min(requiresLabel.implicitWidth + 16, textColumn.width - defaultLabel.implicitWidth - 34)
                                            height: 24
                                            radius: 12
                                            color: "#161D22"
                                            border.color: "#2F4654"
                                            border.width: 1

                                            Text {
                                                id: requiresLabel
                                                anchors.centerIn: parent
                                                width: parent.width - 16
                                                text: "Requires " + (modelData.requiresText || "")
                                                color: "#B9D7E6"
                                                elide: Text.ElideRight
                                                horizontalAlignment: Text.AlignHCenter
                                                font.family: theme.fontFamily
                                                font.pixelSize: 11
                                                font.weight: Font.Bold
                                            }
                                        }

                                        Rectangle {
                                            visible: !!modelData.conflictsText
                                            width: Math.min(conflictsLabel.implicitWidth + 16, textColumn.width - defaultLabel.implicitWidth - 34)
                                            height: 24
                                            radius: 12
                                            color: "#241817"
                                            border.color: "#5A302B"
                                            border.width: 1

                                            Text {
                                                id: conflictsLabel
                                                anchors.centerIn: parent
                                                width: parent.width - 16
                                                text: "Conflicts " + (modelData.conflictsText || "")
                                                color: "#FFB0A3"
                                                elide: Text.ElideRight
                                                horizontalAlignment: Text.AlignHCenter
                                                font.family: theme.fontFamily
                                                font.pixelSize: 11
                                                font.weight: Font.Bold
                                            }
                                        }
                                    }

                                    Text {
                                        visible: !!modelData.description
                                        width: parent.width
                                        text: modelData.description || ""
                                        color: theme.content
                                        wrapMode: Text.WordWrap
                                        lineHeight: 1.25
                                        font.family: theme.fontFamily
                                        font.pixelSize: 12
                                        font.weight: Font.Medium
                                    }
                                }
                            }

                            MouseArea {
                                id: rowMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: active ? Qt.PointingHandCursor : Qt.ArrowCursor

                                readonly property bool active: containsMouse && rowCard.roundedContains(mouseX, mouseY, rowCard.width, rowCard.height, rowCard.radius)

                                onClicked: (mouse) => {
                                    if (!rowCard.roundedContains(mouse.x, mouse.y, rowCard.width, rowCard.height, rowCard.radius))
                                        return
                                    controller.toggleOptionalMod(modelData.id || "", !modelData.enabled)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
