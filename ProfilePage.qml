import QtQuick 2.3
import VPlayApps 1.0

import QtGraphicalEffects 1.0

import "../model"
import "../widgets"

ListPage {
    id: profilePage

    title: qsTr("Profile")
    property var time: alldata[currentIndex]
    property int currentIndex: 0

    property var alldata: [
        { t: 1,  },
        { t: 3,  }
    ]
    backgroundColor: "white"

    navigationBarTranslucency: 1.0 // navigation bar is 100 percent translucent for this page

    titleItem: Column {
        // Fade title item in depdending on scroll state
        opacity: 1 - profileImage.opacity

        AppText {    //白色名字  最上方
            anchors.horizontalCenter: Theme.isAndroid ? undefined : parent.horizontalCenter
            text: profilePage.profile.name
            color: "white"
            font.family: Theme.boldFont.name
            font.bold: true
            font.pixelSize: dp(14)
        }

        AppText {    //发的微博数
            anchors.horizontalCenter: Theme.isAndroid ? undefined : parent.horizontalCenter
            text: qsTr("%1 Tweets").arg(profilePage.profile.statuses_count.toLocaleString(Qt.locale(), "f", 0))
            color: "white"
            font.pixelSize: dp(10)
        }
    }

    // The actual profile data to display
    property var profile

    readonly property real barHeight: dp(Theme.navigationBar.height) + Theme.statusBarHeight


    // Image header
    // Background color placeholder
//    property var time: alldata[currentIndex]
//    property int currentIndex: 0

//    property var alldata: [
//        { t: 1,  },
//        { t: 3,  }
//    ]

    Rectangle {
        id: topImage

        z: 1

        y: listView.contentY + listView.headerItem.height > 0 ?
               -Math.min(listView.contentY + listView.headerItem.height, height - barHeight) : 0


         gradient: Gradient {
            GradientStop {
                position: 0
                color: time.t < 2 ? "black" : "white"

                Behavior on color { ColorAnimation { duration: 1000 } }
            }
            GradientStop {
                position: 1
                color: time.t < 2 ? "black" : "white"

                Behavior on color { ColorAnimation { duration: 1500 } }
            }
        }

        // ColorAnimation on color { to:"white";loops: Animation.Infinite; duration: 1500}
        width: parent.width
        height: dp(140)

        //    Image {
        //      id: imgHeader
        //      source: !!profile && !!profile.profile_banner_url ? profile.profile_banner_url : ""
        //      anchors.fill: parent
        //      fillMode: Image.PreserveAspectCrop
        //      visible: true
        //    }

        //    FastBlur {
        //      source: imgHeader
        //      anchors.fill: imgHeader
        //      radius: 64 * Math.max(0, Math.min(1, (listView.contentY * 0.5 + topImage.height) / listView.headerItem.contentHeight))
        //    }

        // Profile image
        RoundedImage {
            id: profileImage
            //   source: !!profile && !!profile.profile_image_url ? profile.profile_image_url.replace("_normal", "_bigger") : ""

            //                  x: dp(10)
            //                  y: -(height / 4) + parent.height
            //                  width: dp(50)
            //                  height: dp(50)


            opacity: Math.max(0, Math.min(1, -(listView.contentY + topImage.height) / topImage.height))
            scale: opacity

            //border.color: "blue"
            //border.width: dp(2)
            // backgroundColor: "yellow"
        }
    }

    listView {
        //    emptyText.text: qsTr("No tweets")

        header: Column {
            id: contentColumn

            width: parent.width

            // property real contentHeight: height - topImage.height

            //   Spacer for image header
            Item {
                height: topImage.height
                width: parent.width
            }

            // Profile details
            Rectangle {
                width: parent.width
                height: profileContent.height + dp(10) + profileContent.y
                color: "yellow"


                Column {
                    id: profileContent

                    width: parent.width - dp(20)
                    x: dp(10)
                    y:  dp(10)
                    spacing: dp(8)

                    Column {
                        spacing: dp(4)

                        AppText {
                            text: profile.name
                            font.pixelSize: sp(16)
                            font.bold: true
                        }

                        AppText {
                            text: "@" + profile.screen_name
                            font.pixelSize: sp(12)
                            color: Theme.secondaryTextColor
                        }
                    }

                    AppText {
                        text: profile.description
                        width: parent.width
                        wrapMode: Text.WordWrap
                        font.pixelSize: sp(12)
                        lineHeight: 1.3
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

                        Text {
                            id: profileLocation
                            text: profile.location
                            visible: !!profile.location
                            font.family: Theme.normalFont.name
                            font.pixelSize: sp(12)
                            color: Theme.textColor
                        }

                        Icon {
                            icon: IconType.link
                            size: dp(12)
                            color: Theme.secondaryTextColor
                            visible: profileUrl.visible
                        }

                        Text {
                            id: profileUrl
                            text: profile.entities.url && profile.entities.url.urls[0].display_url || ""
                            visible: !!profile.entities.url
                            font.family: Theme.normalFont.name
                            font.pixelSize: sp(12)
                            color: Theme.textColor
                        }
                    }

                    Flow {
                        spacing: dp(6)
                        width: parent.width

                        Text {
                            text: profile.friends_count
                            font.family: Theme.normalFont.name
                            font.bold: true
                            font.pixelSize: sp(12)
                            color: Theme.textColor
                        }

                        Text {
                            text: qsTr("Following")
                            font.family: Theme.normalFont.name
                            font.pixelSize: sp(12)
                            font.capitalization: Font.AllUppercase
                            color: Theme.secondaryTextColor
                        }

                        Text {
                            text: profile.followers_count
                            font.family: Theme.normalFont.name
                            font.bold: true
                            font.pixelSize: sp(12)
                            color: Theme.textColor
                        }

                        Text {
                            text: qsTr("Followers")
                            font.family: Theme.normalFont.name
                            font.pixelSize: sp(12)
                            font.capitalization: Font.AllUppercase
                            color: Theme.secondaryTextColor
                        }
                    }
                }
            }

            Rectangle {
                y: parent.height - height
                width: parent.width
                height: 1
                color: Theme.dividerColor
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
            }}
    }
    Rectangle{
        id:behand
        color: "blue"
        width: parent.width
        //    height: dp(140)
        y:parent.height - height


    }


}