import VPlayApps 1.0
import QtQuick 2.4

ListPage {
    title: "People"

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
