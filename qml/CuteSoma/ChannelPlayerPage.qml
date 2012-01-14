import QtQuick 1.0
import com.nokia.meego 1.0

Page
{
    id: channelPlayer

    property QtObject model: null

    Connections {
        target: serverComm
        onUpdateSong: if (model) serverComm.updateChannelInfo(model.channelId)
    }

    // Takes duration in milli-seconds and outputs minutes:seconds
    function prettyDuration(msecs) {
        var secs = msecs / 1000;
        var resultMins = Math.floor(secs / 60); // round down
        var resultSecs = Math.round(secs % 60);

        // Add leading 0 if needed
        if (resultSecs < 10) resultSecs = "0" + resultSecs;

        return resultMins + ":" + resultSecs;
    }


    Item
    {
        id: channelLandscapeLayout
        visible: true
        anchors.left: parent.left

        Item
        {
            id: songItemL
            anchors.top: parent.bottom
            anchors.topMargin: 10

            Rectangle {
                id: radioImageL
                color: "gray"
                width: 310
                height: 310
                anchors.left: parent.left
                anchors.leftMargin: 10

                Image {
                    source: model ? (model.channelImageBig === "" ? model.channelImage : model.channelImageBig) : ""
                    sourceSize.width: 310
                    sourceSize.height: 310
                    asynchronous: true
                    smooth: true
                    anchors.fill: parent
                }
            }

            Item
            {
                anchors.left: radioImageL.right
                anchors.leftMargin: 10

                Label
                {
                    id: nameLabelL
                    text: model ? model.channelName : ""
                    font.pixelSize: 34;
                    font.weight: Font.Bold;
                }

                Label
                {
                    id: djLabelL
                    text: "Dj: " + (model ? model.channelDj : "")
                    font.pixelSize: 25;
                    font.weight: Font.Light;
                    anchors.top: nameLabelL.bottom
                    anchors.topMargin: 10
                }

                Label
                {
                    id: descriptionLabelL
                    text: model ? model.channelDescription : ""
                    font.pixelSize: 30;
                    font.weight: Font.Light;
                    width: channelPlayer.width - radioImageL.width - 20;
                    wrapMode: "WordWrap";
                    anchors.top: djLabelL.bottom
                    anchors.topMargin: 10
                }

                Label
                {
                    id: listenersLabelL
                    text: "Listeners: " + (model ? model.channelListeners : "")
                    font.pixelSize: 25;
                    font.weight: Font.Light;
                    anchors.top: descriptionLabelL.bottom
                    anchors.topMargin: 10
                }

                Label
                {
                    id: songLabelL
                    text: serverComm.lastPlaying
                    font.pixelSize: 25;
                    font.weight: Font.Bold;
                    anchors.top: listenersLabelL.bottom
                    anchors.topMargin: 10
                }
            }
        }

        Item
        {
            id: controlRowL
            anchors.top: parent.top
            anchors.topMargin: radioImageL.height + 20
            anchors.left: parent.left
            anchors.leftMargin: 10

            Button {
                id: playStopButtonL
                iconSource: serverComm.playing ? "image://theme/icon-m-toolbar-mediacontrol-pause" : "image://theme/icon-m-toolbar-mediacontrol-play"
                onClicked: serverComm.playing ? serverComm.pause() : serverComm.play()
            }

            Label
            {
                id: counterLabelL
                text: prettyDuration(serverComm.progress)
                anchors.left: playStopButtonL.right
                anchors.leftMargin: playStopButtonL.width + 100
            }
        }
    }

    Item
    {
        id: channelPortraitLayout
        visible: false
        anchors.fill: parent

        Column {
            spacing: 15
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 30

            Header {
                text:  model ? model.channelName : ""
                portrait: appWindow.inPortrait
                anchors.margins: -30

                BusyIndicator {
                    id: indicator
                    running: serverComm.channelLoading
                    visible: running
                    style: BusyIndicatorStyle { spinnerFrames: "image://theme/spinnerinverted" }
                    anchors.right: parent.right
                    anchors.rightMargin: 30
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                color: "gray"
                height: width
                anchors.left: parent.left
                anchors.right: parent.right

                BusyIndicator {
                    style: BusyIndicatorStyle { size: "large"; spinnerFrames: "image://theme/spinnerinverted" }
                    visible: running
                    running: radioImageP.status === Image.Loading
                    anchors.centerIn: parent
                }

                Image {
                    id: radioImageP
                    source: model ? (model.channelImageBig === "" ? model.channelImage : model.channelImageBig) : ""
                    sourceSize.height: 400
                    sourceSize.width: 400
                    asynchronous: true
                    smooth: true
                    anchors.fill: parent
                }
            }

            Column {
                spacing: 0
                anchors.left: parent.left
                anchors.right: parent.right

                Label {
                    id: djLabelP
                    text: "Dj: " + (model ? model.channelDj : "")
                    font.pixelSize: 25;
                    font.weight: Font.Light;
                    anchors.left: parent.left
                    anchors.right: parent.right
                }

                Label {
                    id: descriptionLabelP
                    text: model ? model.channelDescription : ""
                    font.pixelSize: 25;
                    font.weight: Font.Light;
                    wrapMode: "WordWrap"
                    maximumLineCount: 2
                    elide: Text.Right
                    anchors.left: parent.left
                    anchors.right: parent.right
                }

                Label {
                    id: listenersLabelP
                    text: "Listeners: " + (model ? model.channelListeners : "")
                    font.pixelSize: 25;
                    font.weight: Font.Light;
                    anchors.left: parent.left
                    anchors.right: parent.right
                }

                Label {
                    id: songLabelP
                    text: serverComm.lastPlaying
                    font.pixelSize: 25;
                    font.weight: Font.Bold;
                    elide: Text.Right
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }

            Row {
                spacing: 15
                anchors.left: parent.left
                anchors.right: parent.right

                Button {
                    iconSource: serverComm.playing ? "image://theme/icon-m-toolbar-mediacontrol-pause" : "image://theme/icon-m-toolbar-mediacontrol-play"
                    onClicked: serverComm.playing ? serverComm.pause() : serverComm.play()
                }

                Label
                {
                    id: counterLabelP
                    text: prettyDuration(serverComm.progress)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Label
    {
        id: noChannelIndicator
        text: "No channel selected yet"
        color: "gray"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.Center
        font.pixelSize: 80
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 20
    }


    states: [
        State {
            name: "noChannelSelected"
            when: model === null
            PropertyChanges {
                target: channelLandscapeLayout
                visible: false
            }
            PropertyChanges {
                target: channelPortraitLayout
                visible: false
            }
            PropertyChanges {
                target: noChannelIndicator
                visible: true
            }
        },
        State {
            name: "inLandscape"
            when: !appWindow.inPortrait
            PropertyChanges {
                target: channelLandscapeLayout
                visible: true
            }
            PropertyChanges {
                target: channelPortraitLayout
                visible: false
            }
        },
        State {
            name: "inPortrait"
            when: appWindow.inPortrait
            PropertyChanges {
                target: channelLandscapeLayout
                visible: false
            }
            PropertyChanges {
                target: channelPortraitLayout
                visible: true
            }
        }
    ]

}
