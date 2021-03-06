import VPlayApps 1.0
import QtQuick 2.0
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0
import "Database.js" as JS
import "./pages"
import "./widgets"
import "./model"

Page {
    id: mainpage
    signal isme
    Component {
        id: profile
        PersonalPage {
        }
    }
    Component {
        id: people
        PeoplePage {
        }
    }
    Component {
        id: recent
        RecentPage {
        }
    }
    Component {
        id: profilePageComponent
        ProfilePage {
        }
    }
    Component {
        id: otherprofileComponent
        OthersPage {
        }
    }

    Component {
        id: detailPageComponent
        DetailPage {
        }
    }

    //    property alias navigation: navigation
    Navigation {
        id: navigation
        drawer.drawerPosition: drawer.drawerPositionLeft
        headerView:  AppImage {
            width: parent.width
            fillMode: AppImage.PreserveAspectFit
            source: "./background.png"
            anchors.verticalCenter: parent.verticalCenter
          }

        footerView: Bottom {
        }

        NavigationItem {
            title: "Recent"
            icon: IconType.clocko
            NavigationStack {
                RecentPage {
                }
            }
        }

        NavigationItem {
            title: "People"
            icon: IconType.user
            NavigationStack {
                id: peoplestack
                PeoplePage {
                }
            }
        }

        NavigationItem {
            title: "Me"
            icon: IconType.githubalt
            NavigationStack {
                PersonalPage {
                }
            }
        }
    }
}

