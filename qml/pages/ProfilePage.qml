import QtQuick 2.3
import VPlayApps 1.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import "../model"
import "../widgets"
import "../pages"

ListPage {
    id: profilePage

    property var profile

    readonly property real barHeight: dp(Theme.navigationBar.height) + Theme.statusBarHeight

    title: qsTr("Profile")
    property var time: alldata[currentIndex]
    property int currentIndex: 0

    property var alldata: [{
            t: 1
        }, {
            t: 3
        }]
    backgroundColor: "white"

    navigationBarTranslucency: 1.0 // navigation bar is 100 percent translucent for this page
    signal logoutClicked
    onLogoutClicked: {
        userLoggedIn = false
        // jump to main page after logout
        navigation.currentIndex = 0
        navigation.currentNavigationItem.navigationStack.popAllExceptFirst()
        Qt.quit()
    }
    Image {
        source: "5.jpg"
        z: 0
    }

    titleItem: Column {
        // Fade title item in depdending on scroll state
        opacity: 1 - profileImage.opacity

        AppText {
            //白色名字  最上方
            anchors.horizontalCenter: Theme.isAndroid ? undefined : parent.horizontalCenter
            text: DataModel.currentProfile.name
            color: "white"
            font.family: Theme.boldFont.name
            font.bold: true
            font.pixelSize: dp(14)
        }
    }

    Rectangle {
        id: topImage

        z: 1

        y: listView.contentY + listView.headerItem.height
           > 0 ? -Math.min(listView.contentY + listView.headerItem.height,
                           height - barHeight) : 0

        width: parent.width
        height: dp(140)

        gradient: Gradient {
            GradientStop {
                position: 0
                color: time.t < 2 ? "#191970" : "grey"

                Behavior on color {
                    ColorAnimation {
                        duration: 1000
                    }
                }
            }
            GradientStop {
                position: 1
                color: time.t < 2 ? "#191970" : "grey"

                Behavior on color {
                    ColorAnimation {
                        duration: 1500
                    }
                }
            }
        }

        // Profile image
        RoundedImage {
            id: profileImage

            opacity: Math.max(
                         0, Math.min(
                             1,
                             -(listView.contentY + topImage.height) / topImage.height))
            scale: opacity
        }
    }

    listView {
        z: 1
        header: Column {
            id: contentColumn

            width: parent.width

            //   Spacer for image header
            Item {
                height: topImage.height
                width: parent.width
            }

            // Profile details
            Rectangle {

                width: parent.width
                height: profileContent.height + dp(10) + profileContent.y

                Image {
                    id: background
                    source: "4.jpg"
                    opacity: 1
                }

                Column {
                    id: profileContent

                    width: parent.width - dp(20)
                    x: dp(10)
                    y: dp(10)
                    spacing: dp(8)

                    Column {
                        spacing: dp(4)

                        AppText {
                            text: DataModel.currentProfile.name
                            font.pixelSize: sp(36)
                            font.bold: true
                        }
                        GridLayout {
                            AppText {
                                text: qsTr("Screen_Name:")
                                font.pixelSize: sp(12)
                            }

                            AppTextField {
                                id: screen_name_text
                                text: DataModel.currentProfile.screen_name
                                font.pixelSize: sp(12)
                                backgroundColor: Theme.secondaryTextColor
                                opacity: 0.5
                                onAccepted: {
                                    if (screen_name_text.text
                                            !== DataModel.currentProfile.screen_name)
                                        DataModel.upuser_screen_name(
                                                    screen_name_text.text)
                                }
                            }
                        }

                        AppText {
                            text: qsTr("Description:")
                            font.pixelSize: sp(12)
                        }
                        AppTextField {
                            id: description_text
                            text: DataModel.currentProfile.description
                            width: parent.width
                            font.pixelSize: sp(12)
                            borderColor: Theme.secondaryTextColor
                            //lineHeight: 1.3
                            height: dp(33)
                            opacity: 0.5
                            onAccepted: {
                                if (description_text.text !== DataModel.currentProfile.description)
                                    DataModel.upuser_description(
                                                description_text.text)
                            }
                        }

                        Flow {
                            spacing: dp(6)
                            width: parent.width

                            Icon {
                                icon: IconType.mapmarker
                                size: dp(12)
                                color: Theme.secondaryTextColor
                                visible: profileLocation.visible
                            }

                            AppTextField {
                                id: location_text
                                text: DataModel.currentProfile.location
                                //                            visible: !!DataModel.currentProfile.location
                                font.bold: true
                                font.pixelSize: sp(12)
                                backgroundColor: Theme.secondaryTextColor
                                opacity: 0.5
                                onActiveFocusChanged: {
                                    if (location_text.text !== DataModel.currentProfile.location)
                                        DataModel.upuser_location(
                                                    location_text.text)
                                }
                            }
                        }
                    }
                }
            }

            Timer {
                interval: 1000
                repeat: true
                running: true
                onTriggered: {
                    interval = 3500
                    if (currentIndex < alldata.length - 1)
                        currentIndex++
                    else
                        currentIndex = 0
                }
            }
        }
    }
    Rectangle {
        id: behand
        color: "blue"
        width: parent.width
        y: parent.height - height
    }
    FloatingActionButton {
        z: 1
        icon: IconType.remove
        visible: true
        onClicked: logoutClicked()
    }
}
