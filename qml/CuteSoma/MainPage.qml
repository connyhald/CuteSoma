import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    id: mainPage

    property string currentChannel: ""

    Component {
        id: listHeader
        Rectangle
        {
            id: header
            height: 64
            color: "#363636"
            anchors.left: parent.left
            anchors.right: parent.right

            Text
            {
                text: "CuteSoma"
                color: "white"
                font.family: "Nokia Pure Text Light"
                font.pixelSize: 32
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    ListView
    {
         id: channelsView
         model: ChannelsModel { id: channelsModel}
         delegate: ChannelsDelegate {}
         header: listHeader
         clip: true
         anchors.fill: parent
    }

    BusyIndicator {
        platformStyle: BusyIndicatorStyle {
            size: "large"
        }
        visible: channelsModel.status == XmlListModel.Loading
        running: visible
        anchors.centerIn: parent
    }

}
