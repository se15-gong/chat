import VPlayApps 1.0
import QtQuick 2.0

Page {

    id:mainpage
    Component{id:profile; PersonalPage{}}
    Component{id:people; PeoplePage{} }
    Component{id:recent; RecentPage{}}

    Navigation{
        id:navigation

        NavigationItem{
            title: "Recent"
            icon: IconType.clocko
            NavigationStack {
                RecentPage{}
            }
        }

        NavigationItem{
            title:  "People"
            icon: IconType.user
            NavigationStack {
                id:peoplestack
                PeoplePage{}
            }
        }

        NavigationItem{
            title: "Me"
            icon: IconType.github
            NavigationStack{
                PersonalPage{}
            }
        }
    }
}
