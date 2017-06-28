import VPlayApps 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.1
import "./model"

Page {
    id: loginPage
    title: "Slecetuser"
    signal loginSucceeded
    signal loginFalsed
    property var current
    property var num

    backgroundColor: Qt.rgba(0,0,0, 0.75) // page background is translucent, we can see other items beneath the page



    // login form background
    Rectangle {
        id: loginForm
        anchors.centerIn: parent
        color: "white"
        width: content.width + dp(48)
        height: content.height + dp(16)
        radius: dp(4)
    }

    // login form content
    GridLayout {
        id: content
        anchors.centerIn: loginForm
        columnSpacing: dp(20)
        rowSpacing: dp(10)
        columns: 2

        // headline
        AppText {
            Layout.topMargin: dp(8)
            Layout.bottomMargin: dp(12)
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            text: "Login "
        }

        // email text and field
        AppText {
            text: qsTr("Name")
            font.pixelSize: sp(12)
        }

        AppTextField {
            id: txtUsername
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: Theme.tintColor
            borderWidth: !Theme.isAndroid ? dp(2) : 0
            onAccepted: {
                if(txtUsername.text === ""){
                    loginFalsed()
                    cuowu.opacity = 1.0
                }
            }
        }
        AppText {
            text: qsTr("Passward")
            font.pixelSize: sp(12)
        }



        AppTextField {
            id: txtPassword
            Layout.preferredWidth: dp(200)
            showClearButton: true
            font.pixelSize: sp(14)
            borderColor: Theme.tintColor
            borderWidth: !Theme.isAndroid ? dp(2) : 0
            echoMode: TextInput.Password
            onAccepted: {
                if(txtPassword.text === ""){
                    loginFalsed()
                    cuowu.opacity = 1.0
                }
            }
        }

        // column for buttons, we use column here to avoid additional spacing between buttons
        Column {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            Layout.topMargin: dp(12)
            AppText{
                id:cuowu
                text:"plase give me name or passward"
                color: "red"
                font.pixelSize: sp(12)
                opacity: 0.0
                // anchors.bottom: parent.bottom
                width: content.width - sp(12)

            }
            AppText{
                id:cuowu2
                text:"password has wrong"
                color: "red"
                font.pixelSize: sp(12)
                opacity: 0.0
                // anchors.bottom: parent.bottom
                width: content.width - sp(12)

            }

            // buttons
            AppButton {
                text: qsTr("login")
                flat: false
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    current = {
                        name:txtUsername.text,
                        password:txtPassword.text
                    }

                    DataModel.dbInit(current)
                    num = DataModel.code

                    if( (num === 0) || (num === 2) )
                    {
                        loginPage.forceActiveFocus()
                        console.debug("DB has init.")
                        console.debug("logging in ...")
                        loginSucceeded()
                        //cuowu.opacity = 0.0
                        //cuowu2.opacity =0.0
                        //txtPassword.text = ""
                        console.debug("num:",num)
                    }

                    else
                    {
                        loginFalsed()
                        cuowu2.opacity = 1.0
                        //cuowu.opacity = 0.0
                        console.debug("num:",num)
                    }
                }


            }
        }
    }
}



