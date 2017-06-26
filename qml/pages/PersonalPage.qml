import VPlayApps 1.0
import QtQuick 2.0
import QtQuick.Controls 2.0 as QuickControls2
import QtGraphicalEffects 1.0
import "../model"
import "../pages"

ListPage {

    readonly property real barHeight: dp(Theme.navigationBar.height) + Theme.statusBarHeight
    navigationBarTranslucency: 0.0
    listView.anchors.topMargin: barHeight
    Rectangle {
        id: background
        width: parent.width
        height: page.barHeight
        color: Theme.navigationBar.backgroundColor

        // add the image
        Image {
            id: bgImage
            source: "portrait0.jpg"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop

            // the blur effect displays the image, we set the source image invisible
            visible: true
        }

        // apply blur effect
        FastBlur {
            id: blur
            source: bgImage
            anchors.fill: bgImage

            // the strength of the blur is based on the list view scroll position
            radius: Math.max(0, Math.min(64, page.listView.contentY))
        }
    }
    title: "Me"
    titleItem: Icon {
        icon: IconType.github
        color: "white"
        size: dp(24)
    }

    //icon: IconType.github
    AppTabBar {
        id: apptabbar
        contentContainer: swipeview
        opacity: 0
        AppTabButton {
            text: "profile"
            icon: IconType.anchor
        }
        AppTabButton {
            text: "setting"
            icon: IconType.gear
        }
    }
    QuickControls2.SwipeView {
        id: swipeview
        anchors.top: apptabbar.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        clip: true

        Rectangle {
            NavigationStack {
                id: profilestack
                Component.onCompleted: {

                    push(profilePageComponent, {
                             profile: DataModel.currentProfile
                         })
                }
            }
        }
        Rectangle {
            id: settingpage
            Setting {
            }
        }
    }
}
