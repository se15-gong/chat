import QtQuick 2.4
import QtQuick.Controls 1.2

import VPlayApps 1.0

import "../widgets"
import "../model"

ListPage {
  id: page

  title: "Recent"


//  MouseArea{
//      id:mousearea
//      anchors.centerIn: plus
//      drag.target: plus
//      onReleased:

//}
  FloatingActionButton{
      id:plus
    icon: IconType.plus
    visible: true
    onClicked: InputDialog.inputTextMultiLine(app,
                                              qsTr("New tweet"),
                                              qsTr("Enter text..."),
                                              function(ok, text) {
                                                if(ok) DataModel.addTweet(text)
                                              })
//    Drag.active: mousearea.drag.active
//    Drag.hotSpot.x: plus.width/2
//    Drag.hotSpot.y: plus.height/2

  }



  titleItem: Icon {
    icon: IconType.clocko
    color: "white"
    size: dp(24)
  }

  property int numItems: 10
  model: DataModel.timeline && DataModel.timeline.slice(0, numItems)
  delegate: TweetRow {
    id: row

    onSelected: {
      console.debug("Selected item at index:", index)
      navigationStack.push(detailPageComponent, { tweet: row.item })
    }

    onProfileSelected: {
      console.debug("Selected profile at index:", index)
      navigationStack.push(profilePageComponent, { profile: row.item.user })
    }
  }

  //load older tweets with visibility handler
  listView.footer: VisibilityRefreshHandler {
    onRefresh: loadOldTimer.start()
    opacity: 0
  }

  //load new tweets with pull handler
  pullToRefreshHandler {
    pullToRefreshEnabled: true
    onRefresh: loadNewTimer.start()
    refreshing: loadNewTimer.running
  }

  Timer {
    // Fake loading of new tweets in background
    id: loadNewTimer
    interval: 5000
    onTriggered: {
      DataModel.addTweet("Lorem Ipsum.")
    }
  }

  Timer {
    // Fake loading of older tweets in background
    id: loadOldTimer
    interval: 2000
    onTriggered: {
      var pos = listView.getScrollPosition()
      numItems += 10
      listView.restoreScrollPosition(pos)
    }
  }
}
