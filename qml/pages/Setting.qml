import VPlayApps 1.0
import VPlayPlugins 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0

ListPage
{
    id:settingpage
    AppFlickable {
      anchors.fill: parent
      anchors.centerIn: parent
      contentWidth: width
      contentHeight: content.height + content.y * 2
//        ListPage {
//            model: [{ type: "Background setting",TextButtonBarItem},
//                { type: "Text color", text: " " },
//                { type: "About me", text: "This software is written by 15se" }]
//            section.property: "type"
//        }
    ColumnLayout{
AppText
    {
        anchors.horizontalCenter: parent
              text: "Background Color"
              wrapMode: Text.NoWrap
     }

Row{
      Layout.maximumWidth: parent.width
      Layout.alignment: Qt.AlignHCenter
      spacing: /*parent.spacing*/ 20


      ColorButton {
        color: Theme.isAndroid ? "#007aff" : "#3f5ab5"
        onClicked: Theme.colors.tintColor = Qt.binding(function() { return Theme.isDesktop ? "#007aff" : (Theme.isAndroid ? "#3f51b5" : "#01a9e2")})
      }
      Repeater {
            model: ["red", "green", "blue", "orange",]
            ColorButton {
              color: modelData
              onClicked: Theme.colors.tintColor = color
            }
          }
        }

    // separator
    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: parent.spacing * 20
      Rectangle {
        width: parent.width * 20
        height: px(1)
        color: Theme.tintColor
        anchors.centerIn: parent
      }
    }

    AppText {
      Layout.alignment: Qt.AlignHCenter
      text: "Text Color"
      wrapMode: Text.NoWrap
    }
   Row {
      Layout.alignment: Qt.AlignHCenter
      Layout.maximumWidth: parent.width
      spacing:20

      Repeater {
        model: [
          ["black", "#6C6C6C"],
          ["white", "#BFBFBF"],
          ["red", "#FF7D00"],
          ["green", "#007D4B"],
          ["blue", "#007DFF"]          // 7D00FF
        ]
        ColorButton {
          color: modelData[0]
          referenceColor: Theme.colors.textColor
          onClicked: {
            Theme.colors.textColor = modelData[0]
            Theme.colors.secondaryTextColor = modelData[1]
            if(index === 0)
              Theme.colors.disclosureColor = "#C5C5CA"
            else
              Theme.colors.disclosureColor = modelData[1]
          }
        }
      }
    }
   Item {
     Layout.fillWidth: true
     Layout.preferredHeight: parent.spacing * 20
     Rectangle {
       width: parent.width * 20
       height: px(1)
       color: Theme.tintColor
       anchors.centerIn: parent
     }
   }
   Row {
     Layout.alignment: Qt.AlignHCenter
     spacing: parent.spacing

     AppText {
       anchors.verticalCenter: parent.verticalCenter
       text: "Dark Tabs:"
       wrapMode: Text.NoWrap
     }

     AppSwitch {
       anchors.verticalCenter: parent.verticalCenter
       checked: Theme.tabBar.backgroundColor == "#080808"
       updateChecked: false
       onToggled: {
         if(!checked) {
           Theme.tabBar.titleColor = Qt.binding(function() { return Theme.isAndroid ? Theme.navigationBar.itemColor : Theme.tintColor })
           Theme.tabBar.titleOffColor = Qt.binding(function() { return Theme.isAndroid ? Qt.darker(Theme.navigationBar.titleColor, 1.5) : "#616161" })
           Theme.tabBar.backgroundColor = "#080808"

           Theme.navigationBar.backgroundColor = "#080808"
           Theme.navigationBar.titleColor = Qt.binding(function() {return Theme.isIos ? "#fff" : Theme.isAndroid ? "#fff" : "#f8f8f8" })
           Theme.navigationBar.itemColor = Qt.binding(function() {return Theme.isIos ? Theme.tintColor : Theme.tintColor })

           Theme.colors.statusBarStyle = Theme.colors.statusBarStyleWhite
         }
         else {

           Theme.tabBar.titleColor = Qt.binding(function() { return Theme.isAndroid ? Theme.navigationBar.itemColor : Theme.tintColor })
           Theme.tabBar.titleOffColor = Qt.binding(function() { return Theme.isAndroid ? Qt.lighter(Theme.colors.tintColor, 1.5) : Theme.disabledColor })
           Theme.tabBar.backgroundColor = Qt.binding(function() { return Theme.isAndroid ? Theme.colors.tintColor : "#f8f8f8"})

           Theme.navigationBar.backgroundColor = Qt.binding(function() { return Theme.isIos ? "#f8f8f8" : Theme.tintColor })
           Theme.navigationBar.titleColor = Qt.binding(function() {return Theme.isIos ? "#000" : Theme.isAndroid ? "#fff" : "#f8f8f8" })
           Theme.navigationBar.itemColor = Qt.binding(function() {return Theme.isIos ? Theme.tintColor : Theme.navigationBar.titleColor })

           Theme.colors.statusBarStyle = Theme.colors.statusBarStyleBlack
         }
       }
     } // AppSwitch
}
}
}
}
