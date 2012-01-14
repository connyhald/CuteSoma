import QtQuick 1.0

Rectangle {
    id: root
    property string text: ""
    property bool portrait: false

    // 46 and 72 taken from Harmattan plattform defaults
    height: portrait ? 72 : 46
    color: "#363636"
    anchors.left: parent.left
    anchors.right: parent.right

    Text {
        text: root.text
        color: "white"
        font.family: "Nokia Pure Text Light"
        font.pixelSize: 32
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        anchors.verticalCenter: parent.verticalCenter
    }
}
