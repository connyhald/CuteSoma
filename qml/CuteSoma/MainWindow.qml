import QtQuick 1.0
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    initialPage: Page {
        anchors.fill: parent

        tools: ToolBarLayout {
            id: toolBarLayout

            ButtonRow {
                TabButton {
                    text: "Channels"
                    iconSource: "image://theme/icon-m-toolbar-list"
                    tab: mainPage
                }
                TabButton {
                    text: "Player"
                    iconSource: "image://theme/icon-m-toolbar-content-audio"
                    tab: channelPlayerPage
                }
            }
            ToolIcon {
                iconId: "toolbar-view-menu"
                onClicked: menu.open()
            }
        }

        TabGroup {
            id: tabGroup
            currentTab: mainPage
            anchors.fill: parent
            ChannelListPage { id: mainPage }
            ChannelPlayerPage { id: channelPlayerPage }
        }
    }


    Menu
    {
        id: menu
        MenuLayout
        {
            MenuItem
            {
                text: "About"
                onClicked: { pageStack.push(Qt.resolvedUrl("About.qml")) }
            }
            MenuItem
            {
                text: "Quit"
                onClicked: Qt.quit()
            }
        }
    }

    Rectangle {
        color: "black"
        opacity: 0.8
        visible: serverComm.lastPlaying !== "" && platformWindow.viewMode === WindowState.Thumbnail
        anchors.fill: parent
        Text {
            text: serverComm.lastPlaying
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 80
            anchors.fill: parent
            anchors.margins: 20
        }
        Behavior on opacity {
            PropertyAnimation { duration: 250 }
        }
    }
}
