pragma Singleton

import QtQuick 2.0
import VPlayApps 1.0


QtObject {
  id: dataModel

  property var currentProfile   //当前用户
  property var timeline    //时间线
  property var messages    //信息

  property var firstTweetData  //第一个推特日期

  // Load default data
  Component.onCompleted: {
    console.debug("Loading datamodel...")

    // Profile
    var xhr = new XMLHttpRequest
    xhr.onreadystatechange = function() {
      if (xhr.readyState === XMLHttpRequest.DONE)
        currentProfile = JSON.parse(xhr.responseText)
    }
    xhr.open("GET", Qt.resolvedUrl("../data/user.json"))
    xhr.send()

    // Feed
    var xhr2 = new XMLHttpRequest
    xhr2.onreadystatechange = function() {
      if (xhr2.readyState === XMLHttpRequest.DONE) {
        var json = JSON.parse(xhr2.responseText)
        var model = []

        firstTweetData = json[0]
        for (var i = 0; i < json.length; i++) {
          model.push(tweetModel(json[i]))
        }

        timeline = model
      }
    }
    xhr2.open("GET", Qt.resolvedUrl("../data/feed.json"))
    xhr2.send()

    // Messages
 //   var xhr3 = new XMLHttpRequest
//    xhr3.onreadystatechange = function() {
//      if (xhr3.readyState === XMLHttpRequest.DONE) {
//        var raw = JSON.parse(xhr3.responseText)
//        var model = []

//        for (var i = 0; i < raw.length; i++) {
//          var names = model.map(function(val) { return val.handle } )
//          var message = JSON.parse(JSON.stringify(raw[i]))
//          message.user = message.sender
//          message = tweetModel(message)

//          if (names.indexOf("@" + message.user.screen_name) === -1) {
//            message.actionsHidden = true
//            delete message.sender
//            delete message.image
//            delete message.retweeted
//            delete message.favorited
//            delete message.retweet_count
//            delete message.favorite_count
//            model.push(message)
//          }
//        }
//        messages = model
//      }
//    }
//    xhr3.open("GET", Qt.resolvedUrl("../data/messages.json"))
//    xhr3.send()
  }

  function tweetModel(data) {
    // Twitter uses custom format not recognized by new Date(string)
    var date = new Date(data.created_at.replace("+0000 ", "") + " UTC")

    // Check for URLs
    var text = data.text
    if (!!data.entities && !!data.entities.urls) {
      for (var j = 0; j < data.entities.urls.length; j++) {
        var url = data.entities.urls[j]
        text = text.replace(url.url, "<a href=\"" + url.url + "\">" + url.display_url + "</a>")
      }
    }

    // Check for image media
    var image = null
    if (!!data.entities && !!data.entities.media) {
      for (var j = 0; j < data.entities.media.length; j++) {
        var med = data.entities.media[j]
        if (med.type === "photo") {
          // Save image reference
          image = med.media_url

          // Remove possible url from text
          text = text.replace(med.url, "")

          // We just use the first found photo for now
          break
        }
      }
    }

    return {
      "name": data.user.name,
      "handle": "@" + data.user.screen_name,
      "icon": data.user.profile_image_url.replace("_normal", "_bigger"),
      "text": text,
      "image": image,
      "time": DateFormatter.prettyDateTime(date),
      "retweet_count": data.retweet_count,
      "favorite_count": data.favorite_count,
      "retweeted": data.retweeted,
      "favorited": data.favorited,
      "user": data.user,
      "actionsHidden": undefined // workaround because dynamic add/remove of properties has troubles on iOS with Qt. 5.6.0
    }
  }

  function addTweet(text) {
    //create fake tweet as copy of first tweet with new text
    var newTweet = JSON.parse(JSON.stringify(firstTweetData))
    newTweet.user = currentProfile
    newTweet.text = text
    timeline.splice(0, 0, tweetModel(newTweet)) //insert at position 0
    timelineChanged()
  }
}
