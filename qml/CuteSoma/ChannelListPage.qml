import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    id: mainPage

    property string currentChannel: ""

    Header {
        id: header
        text: "CuteSoma"
        portrait: appWindow.inPortrait
        anchors.top: parent.top
    }

    ListView
    {
         id: channelsView
         model: ChannelsModel { id: channelsModel}
         delegate: ChannelsDelegate {}
         clip: true
         anchors.left: parent.left
         anchors.right: parent.right
         anchors.top: header.bottom
         anchors.bottom: parent.bottom
    }

    BusyIndicator {
        platformStyle: BusyIndicatorStyle { size: "large" }
        visible: channelsModel.status == XmlListModel.Loading
        running: visible
        anchors.centerIn: parent
    }
}
