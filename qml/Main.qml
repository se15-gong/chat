import VPlayApps 1.0
import QtQuick 2.0


App {
    onInitTheme: {
        Theme.colors.tintColor = "#1AD6FD"

            Theme.colors.backgroundColor = "#eee"

            Theme.navigationBar.backgroundColor = Theme.tintColor
            Theme.navigationBar.titleColor = "black"
            Theme.navigationBar.itemColor = "white"
            Theme.colors.statusBarStyle = Theme.colors.statusBarStyleWhite
    }
    MainPage{ }
}
