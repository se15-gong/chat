pragma Singleton

import QtQuick 2.0
import VPlayApps 1.0
import QtQuick.LocalStorage 2.0
import "../Database.js" as JS
import "../pages"

QtObject {
    id: dataModel

    property var currentProfile
    //当前用户
    property var timeline

    //时间线
    property var firstTweetData

    //第一个推特日期
    property var friendline: []
    property var userline: []

    // Load default data
    Component.onCompleted: {
        console.debug("Loading datamodel...")
        // Profile
        //        var xhr = new XMLHttpRequest
        //        xhr.onreadystatechange = function () {
        //            if (xhr.readyState === XMLHttpRequest.DONE)
        //                currentProfile = JSON.parse(xhr.responseText)
        //        }
        //        xhr.open("GET", Qt.resolvedUrl("../data/user.json"))
        //        xhr.send()

        // Feed
        var xhr2 = new XMLHttpRequest
        xhr2.onreadystatechange = function () {
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
    }

    //    function modifycurrentprofile(newname)
    //    {
    //        return currentProfile.name = newname
    //    }

    function isme(profile) {
        if (currentProfile.name === profile.name)
            return false
        else
            return true
    }

    function tweetModel(data) {
        // Twitter uses custom format not recognized by new Date(string)
        var date = new Date(data.created_at.replace("+0000 ", "") + " UTC")

        // Check for URLs
        var text = data.text
        if (!!data.entities && !!data.entities.urls) {
            for (var j = 0; j < data.entities.urls.length; j++) {
                var url = data.entities.urls[j]
                text = text.replace(
                            url.url,
                            "<a href=\"" + url.url + "\">" + url.display_url + "</a>")
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
            name: data.user.name,
            handle: "@" + data.user.screen_name,
            icon: data.user.profile_image_url.replace("_normal", "_bigger"),
            text: text,
            image: image,
            time: DateFormatter.prettyDateTime(date),
            retweet_count: data.retweet_count,
            favorite_count: data.favorite_count,
            retweeted: data.retweeted,
            favorited: data.favorited,
            user: data.user,
            actionsHidden: undefined // workaround because dynamic add/remove of properties has troubles on iOS with Qt. 5.6.0
        }
    }

    function addTweet(text) {
        //create fake tweet as copy of first tweet with new text
        var newTweet = JSON.parse(JSON.stringify(firstTweetData))

        newTweet.text = text
        currentProfile.name = text
        timeline.splice(0, 0, tweetModel(newTweet)) //insert at position 0
        timelineChanged()
    }

    function dbInit() {
        var db = LocalStorage.openDatabaseSync("FriendList", "",
                                               "Track exercise", 1000000)

        db.transaction(function (tx) {
            tx.executeSql(
                        'CREATE TABLE IF NOT EXISTS friend (chatter_name text,content text)')
            var results = tx.executeSql('SELECT * FROM friend')
            for (var i = 0; i < results.rows.length; i++) {
                var r = {
                    text: results.rows.item(i).chatter_name,
                    detailText: results.rows.item(i).content
                }
                friendline.push(r)
                console.debug("read success!")
            }

            var users = tx.executeSql('SELECT * FROM user')
            for (var i = 0; i < users.rows.length; i++) {
                var r = {
                    name: users.rows.item(i).user_name,
                    screen_name: users.rows.item(i).screen_name,
                    description: users.rows.item(i).content,
                    location:users.rows.item(i).address
                }
                userline.push(r)
                currentProfile = r
                console.debug("user read success!  users.rows.length:",users.rows.length)
            }
        })
    }

    function useradd(user){
        var db = JS.dbGetHandle()
        db.transaction(function (tx) {
            tx.executeSql('INSERT INTO user(user_name) VALUES(?)',
                          [user])
        })
        userline.push(user)
    }


    function friendadd(profile) {
        var isadd = true
        for (var i = 0; i < friendline.length; i++) {
            if (profile.name === friendline[i].text) {
                isadd = false
                console.debug("The friend has existed!")
            }
        }
        if (isadd) {
            var newItem = {
                text: profile.name,
                detailText: profile.description
                // image: Qt.resolvedUrl("user_default.png")
            }

            var db = JS.dbGetHandle()
            db.transaction(function (tx) {
                tx.executeSql('INSERT INTO friend VALUES(?,?)',
                              [profile.name, profile.description])
            })
            friendline.push(newItem)
            friendlineChanged()
            console.debug("add a friend:", profile.name)
        }
    }

    function friendremove(index) {
        var db = JS.dbGetHandle()
        db.transaction(function (tx) {
            tx.executeSql('delete from friend where chatter_name = ?',
                          [friendline[index].text])
        })
        friendline.splice(index, 1)
        console.debug("remove a friend")
        friendlineChanged()
    }
}
