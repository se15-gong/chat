import VPlayApps 1.0
import QtQuick 2.4
import QtGraphicalEffects 1.0
ListPage {
    readonly property real barHeight: dp(Theme.navigationBar.height) + Theme.statusBarHeight
    navigationBarTranslucency: 1.0
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
        visible: false
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
    title: "People"

    titleItem: Icon{
        icon: IconType.user
        color : "white"
        size: dp(24)
    }

    delegate:SimpleRow{
        image.radius: image.height
        image.fillMode: Image.PreserveAspectCrop
        autoSizeImage: true
        style.showDisclosure: false
        imageMaxSize: dp(48)
        detailTextItem.maximumLineCount: 1
        detailTextItem.elide: Text.ElideRight

        onSelected: {
            peoplestack.popAllExceptFirstAndPush(gpcomponent,{
                                                     person: item.text,
                                                     newMsgs: [{me: true, text: item.detailText}]
                                                 })
        }
    }
    Component{id:gpcomponent;GroupPeople{}}
    model: [
        { text: "Jin Chen", detailText:"hello!" ,image: Qt.resolvedUrl("portrait0.jpg")}
    ]

}
