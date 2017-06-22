import VPlayApps 1.0
import QtQuick 2.0
import QtQuick.Controls 2.0 as QuickControls2
import "../model"



Page{
    title: "Me"
    titleItem: Icon{
        icon: IconType.github
        color : "white"
        size: dp(24)}
    //icon: IconType.github

    AppTabBar{
        id:apptabbar
        contentContainer: swipeview
        AppTabButton{
            text: "profile"
            icon: IconType.anchor

        }
        AppTabButton{
            text: "setting"
            icon: IconType.gear
        }

    }
    QuickControls2.SwipeView{
        id:swipeview
        anchors.top:apptabbar.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        clip: true

        Rectangle{
            NavigationStack {
                Component.onCompleted: {
                    push( profilePageComponent , { profile: DataModel.currentProfile })
                }
            }
        }
        Rectangle{
            color: "white"
        }



        //        Navigation{
        //            navigationMode: navigationModeTabs
        //            NavigationItem{
        //                title: "profile"
        //                icon: IconType.anchor
        //                NavigationStack {
        //                Component.onCompleted: {
        //                    push( profilePageComponent , { profile: DataModel.currentProfile })
        //            }
        //                }
        //            }
        //            NavigationItem{
        //                title: "setting"
        //                icon: IconType.gear
        //            }
        //        }
    }
}
