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
                onClicked: (menu.status === DialogStatus.Closed) ? menu.open() : menu.close()
            }
        }

        TabGroup {
            id: tabGroup
            currentTab: mainPage
            anchors.fill: parent
            MainPage { id: mainPage }
            ChannelPlayerPage { id: channelPlayerPage }
        }
    }


    Menu
    {
        id: menu
        //visualParent: pageStack

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
}
