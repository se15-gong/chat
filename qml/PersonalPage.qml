import VPlayApps 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.1
Page{
    title: "Gong"
    Navigation{
        navigationMode: navigationModeTabs
        NavigationItem{
            title: "profile"
        }
        NavigationItem{
            title: "setting"
//            Row {
//              id: notificationRow
//              Layout.alignment: Qt.AlignHCenter
//              spacing: parent.spacing

//              ListPage {
//                model: [{ type: "Theme setting", text:"color"  },

//                  { type: "Text color", text: "" },
//                  { type: "About me", text: "This software is written by 15se" }]
//                section.property: "type"
//              }

            }

        }
    }
}
