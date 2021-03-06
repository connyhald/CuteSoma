import QtQuick 1.0
import com.nokia.meego 1.0

Page
{
    id: channelPlayer

    property QtObject model: null

    tools: backMenuTool

    Connections
    {
        target: serverComm

        onChannelLoading:
        {
            indicator.visible = true;
        }

        onChannelLoaded:
        {
            indicator.visible = false;
        }

        onPositionUpdate:
        {
            counterLabelP.text = minutes + ":" + seconds;
            counterLabelL.text = minutes + ":" + seconds;
        }

        onUpdateSong:
        {
            if (model) {
                serverComm.updateChannelInfo(model.channelId);
            }
        }

        onChannelSongUpdate:
        {
            songLabelP.text = song;
            songLabelL.text = song;
        }

        onSongPlaying:
        {
            imgPlayL.visible = false;
            imgPlayP.visible = false;
            imgPauseL.visible = true;
            imgPauseP.visible = true;
        }

        onSongPaused:
        {
            imgPlayL.visible = true;
            imgPlayP.visible = true;
            imgPauseL.visible = false;
            imgPauseP.visible = false;
        }
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

            Image
            {
                id: radioImageL
                source: model ? (model.channelImageBig === "" ? model.channelImage : model.channelImageBig) : ""
                width: 310
                height: 310
                sourceSize.width: 310
                sourceSize.height: 310
                asynchronous: true
                smooth: true
                anchors.left: parent.left
                anchors.leftMargin: 10
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
                    text: model ? model.song : ""
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

            Button
            {
                id: playStopButtonL

                Image
                {
                    id: imgPlayL
                    anchors.centerIn: parent
                    visible: false
                    source: "image://theme/icon-m-toolbar-mediacontrol-play" + (theme.inverted ? "-inverse" : "")
                }

                Image
                {
                    id: imgPauseL
                    anchors.centerIn: parent
                    source: "image://theme/icon-m-toolbar-mediacontrol-pause" + (theme.inverted ? "-inverse" : "")
                }

                onClicked:
                {
                    if (imgPlayL.visible)
                    {
                        imgPlayP.visible = false;
                        imgPauseP.visible = true;
                        imgPlayL.visible = false;
                        imgPauseL.visible = true;

                        serverComm.play();
                    }
                    else
                    {
                        imgPlayP.visible = true;
                        imgPauseP.visible = false;
                        imgPlayL.visible = true;
                        imgPauseL.visible = false;

                        serverComm.pause();
                    }
                }
            }

            Label
            {
                id: counterLabelL
                text: "00:00"
                anchors.left: playStopButtonL.right
                anchors.leftMargin: playStopButtonL.width + 100
            }
        }
    }

    Item
    {
        id: channelPortraitLayout
        visible: false
        anchors.verticalCenterOffset: 5
        anchors.left: parent.left

        Item
        {
            id: songItemP
            anchors.top: parent.bottom
            anchors.topMargin: 10

            Image
            {
                id: radioImageP
                source: model ? (model.channelImageBig === "" ? model.channelImage : model.channelImageBig) : ""
                width: 400
                height: 400
                sourceSize.height: 400
                sourceSize.width: 400
                asynchronous: true
                smooth: true
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 40
            }

            Item
            {
                anchors.top: radioImageP.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 15

                Label
                {
                    id: nameLabelP
                    text: model ? model.channelName : ""
                    font.pixelSize: 34;
                    font.weight: Font.Bold;
                }

                Label
                {
                    id: djLabelP
                    text: "Dj: " + (model ? model.channelDj : "")
                    font.pixelSize: 25;
                    font.weight: Font.Light;
                    anchors.top: nameLabelP.bottom
                    anchors.topMargin: 10
                }

                Label
                {
                    id: descriptionLabelP
                    text: model ? model.channelDescription : ""
                    font.pixelSize: 25;
                    font.weight: Font.Light;
                    width: channelPlayer.width - 20
                    wrapMode: "WordWrap";
                    anchors.top: djLabelP.bottom
                    anchors.topMargin: 10
                }

                Label
                {
                    id: listenersLabelP
                    text: "Listeners: " + (model ? model.channelListeners : "")
                    font.pixelSize: 25;
                    font.weight: Font.Light;
                    anchors.top: descriptionLabelP.bottom
                    anchors.topMargin: 10
                }

                Label
                {
                    id: songLabelP
                    text: model ? model.song : ""
                    font.pixelSize: 25;
                    font.weight: Font.Bold;
                    anchors.top: listenersLabelP.bottom
                    anchors.topMargin: 10
                    width: channelPlayer.width - 30
                    wrapMode: "WordWrap"
                }
            }
        }

        Item
        {
            id: controlRowP
            anchors.top: parent.top
            anchors.topMargin: 690
            anchors.left: parent.left
            anchors.leftMargin: 15

            Button
            {
                id: playStopButtonP

                Image
                {
                    id: imgPlayP
                    anchors.centerIn: parent
                    visible: false
                    source: "image://theme/icon-m-toolbar-mediacontrol-play" + (theme.inverted ? "-inverse" : "")
                }

                Image
                {
                    id: imgPauseP
                    anchors.centerIn: parent
                    source: "image://theme/icon-m-toolbar-mediacontrol-pause" + (theme.inverted ? "-inverse" : "")
                }

                onClicked:
                {
                    if (imgPlayP.visible)
                    {
                        imgPlayP.visible = false;
                        imgPauseP.visible = true;
                        imgPlayL.visible = false;
                        imgPauseL.visible = true;

                        serverComm.play();
                    }
                    else
                    {
                        imgPlayP.visible = true;
                        imgPauseP.visible = false;
                        imgPlayL.visible = true;
                        imgPauseL.visible = false;

                        serverComm.pause();
                    }
                }
            }

            Label
            {
                id: counterLabelP
                text: "00:00"
                anchors.left: playStopButtonP.right
                anchors.leftMargin: 50
                anchors.top: parent.top
                anchors.topMargin: 15
            }
        }

    }

    states: [
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

    ToolBarLayout
    {
            id: backMenuTool
            visible: true
            ToolIcon { iconId: "toolbar-back"; onClicked: { pageStack.pop(); } }

            BusyIndicator
            {
                id: indicator
                platformStyle: BusyIndicatorStyle { size: "small" }
                running: true
                visible: true
                anchors.centerIn: parent
            }
    }
}
