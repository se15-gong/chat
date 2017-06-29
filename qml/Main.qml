import VPlayApps 1.0
import QtQuick 2.0
import VPlay 2.0
import QtGraphicalEffects 1.0
App {
    id: app
    property bool userLoggedIn: false



    // login page is always visible if user is not logged in
    LoginPage {
        z: 1 // show login above actual app pages
        visible: opacity > 0
        enabled: visible
        opacity: userLoggedIn ? 0 : 1 // hide if user is logged in
        onLoginSucceeded: userLoggedIn = true
         onLoginFalsed:  userLoggedIn = false

        Behavior on opacity { NumberAnimation { duration: 250 } } // page fade in/out
    }
    onInitTheme: {
        Theme.colors.tintColor = "#1AD6FD"

        Theme.colors.backgroundColor = "#eee"

        Theme.navigationBar.backgroundColor = Theme.tintColor
        Theme.navigationBar.titleColor = "black"
        Theme.navigationBar.itemColor = "white"
        Theme.colors.statusBarStyle = Theme.colors.statusBarStyleWhite
    }
    MainPage {
    }
}
