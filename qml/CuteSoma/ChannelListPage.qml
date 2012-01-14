import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    id: mainPage

    property string currentChannel: ""

    ListView
    {
         id: channelsView
         model: ChannelsModel { id: channelsModel}
         delegate: ChannelsDelegate {}
         header: Header { text: "CuteSoma"; portrait: appWindow.inPortrait }
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
