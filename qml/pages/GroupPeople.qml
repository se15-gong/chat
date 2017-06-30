import VPlayApps 1.0
import QtQuick 2.4

ListPage {

    title: person

    property string person

    property var newMsgs: []

    property int numRepeats: 1

    readonly property int numLoadedItems: blindTextMsgs.length

    property var blindTextMsgs:[
    {me:false,text:"aaaaa"},
    {me:false,text:"bbbbb"},
    {me:true,text:"ccccc"},
    {me:false,text:"ddddd"}]

    model: {
      var model = newMsgs
      for(var i = 0; i < numRepeats; i++) {
        model = blindTextMsgs.concat(model)
      }
      return model
    }

    Component.onCompleted: listView.positionViewAtEnd()

    listView.backgroundColor: "white"
    listView.anchors.bottomMargin: inputBox.height
    listView.header: VisibilityRefreshHandler {
        onRefresh: loadTimer.start()
        opacity: 0
    }

    //fake loading with timer
    Timer {
      id: loadTimer
      interval: 1000
      onTriggered: {
        var pos = listView.getScrollPosition()
        numRepeats++
        listView.restoreScrollPosition(pos, numLoadedItems)
      }
    }

    delegate: Item {
      id: bubble

      width: parent.width
      height: bg.height + dp(20)

      property bool me: modelData.me

      Rectangle {
        id: bg
        color: me ? Theme.tintColor : "#e9e9e9"
        radius: dp(10)

        x: me ? (bubble.width - width - dp(10)) : dp(10)
        y: dp(10)
        width: innerText.width + dp(20)
        height: innerText.implicitHeight + dp(20)

        Text {
          id: innerText
          x: dp(10)
          y: dp(10)
          width: Math.min(innerText.implicitWidth, bubble.parent.width * 0.75)
          wrapMode: Text.WordWrap
          text: modelData.text
          font.pixelSize: sp(16)
          color: me ? "white" : "black"
        }
      }
    }


    // horizontal separator line between input text and
    Rectangle {
      height: px(1)
      anchors.bottom: inputBox.top
      anchors.left: parent.left
      anchors.right: parent.right
      color: "#cccccc"
    }

    AppTextField {
      id: inputBox
      height: dp(48)
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: dp(8)
      anchors.rightMargin: dp(8)
      font.pixelSize: sp(16)
      placeholderText: "Type a message ..."
      backgroundColor: "white"
      verticalAlignment: Text.AlignVCenter

      onAccepted: {
          if(!inputBox.text)
              inputBox.placeholderText = "You can't enter none!"
          else
          {
            newMsgs = newMsgs.concat({me: true, text: inputBox.text});
            inputBox.placeholderText = ""
          }

        inputBox.text = ""
        listView.positionViewAtEnd()
      }
      AppButton{
          icon:IconType.paperplane
          visible: true
          anchors.topMargin:inputBox.top
          anchors.right: inputBox.right
          onClicked: {
              if(!inputBox.text)
                  inputBox.placeholderText = "You can't enter none!"
              else
              {
                newMsgs = newMsgs.concat({me: true, text: inputBox.text});
                inputBox.placeholderText = ""
              }

            inputBox.text = ""
            listView.positionViewAtEnd()
          }
      }
    }

}
