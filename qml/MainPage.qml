import VPlayApps 1.0
import QtQuick 2.0
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0
import "./pages"
import "./widgets"
import "./model"

Page {
    id: mainpage
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
        id: detailPageComponent
        DetailPage {
        }
    }

//    property alias navigation: navigation

    Navigation {
        id: navigation
        drawer.drawerPosition: drawer.drawerPositionLeft
        headerView: NavHeader {
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
