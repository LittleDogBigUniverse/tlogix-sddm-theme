/***********************************************************************/


import QtQuick 2.0

import SddmComponents 2.0


Rectangle {
    width: 640
    height: 480

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "steelblue"
            errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
    }

    Repeater {
        model: screenModel
        Background {
            x: geometry.x; y: geometry.y; width: geometry.width; height:geometry.height
            source: config.background
            fillMode: Image.Centre
            onStatusChanged: {
                if (status == Image.Error && source != config.defaultBackground) {
                    source = config.defaultBackground
                }
            }
        }
    }

    Rectangle {
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
        color: "transparent"
        transformOrigin: Item.Top

        Rectangle {
            id: logoContainer
            anchors.centerIn: parent
            height: parent.height / 5 * 3
            anchors.verticalCenterOffset: height * 0/ 3
                                    anchors.horizontalCenterOffset: -1.4 * height / 2
            width: height
            color: "#99ffffff"

            Image {
                id: tlogixLogo
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                transformOrigin: Item.Center
                source: "tlogix-logo.png"
            }
        }

        Rectangle {
            id: formContainer
            anchors.centerIn: parent
            height: parent.height / 10 * 3
            width: height * 1.8
            anchors.verticalCenterOffset: height * 0/ 3
            anchors.horizontalCenterOffset: +3.1 * height / 2
            color: "#99ffffff"

            Column {
                id: mainColumn
                anchors.centerIn: parent
                width: parent.width * 0.9
                spacing: formContainer.height / 22.5

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width
                    height: text.implicitHeight
                    color: "white"
                    text: textConstants.welcomeText.arg(sddm.hostName)
                    wrapMode: Text.WordWrap
                    font.pixelSize: formContainer.height / 11.75
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                Row {
                    width: parent.width
                    spacing: Math.round(formContainer.height / 70)
                    Text {
                        id: lblName
                        width: parent.width * 0.20; height: formContainer.height / 9
                        color: "white"
                        text: textConstants.userName
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                        font.pixelSize: formContainer.height / 22.5
                    }

                    TextBox {
                        id: name
                        width: parent.width * 0.8; height: formContainer.height / 9
                        text: userModel.lastUser
                        font.pixelSize: formContainer.height / 20

                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing : Math.round(formContainer.height / 70)
                    Text {
                        id: lblPassword
                        width: parent.width * 0.2; height: formContainer.height / 9
                        color: "white"
                        text: textConstants.password
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                        font.pixelSize: formContainer.height / 22.5
                    }

                    PasswordBox {
                        id: password
                        width: parent.width * 0.8; height: formContainer.height / 9
                        font.pixelSize: formContainer.height / 20
                        tooltipBG: "lightgrey"
                        focus: true
                        Timer {
                            interval: 200
                            running: true
                            onTriggered: password.forceActiveFocus()
                        }

                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    spacing: Math.round(formContainer.height / 70)
                    width: parent.width / 2
                    z: 100

                    Row {
                        z: 100
                        width: parent.width * 1.2
                        spacing : Math.round(formContainer.height / 70)
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblSession
                            width: parent.width  / 3; height: formContainer.height / 9
                            text: textConstants.session
                            verticalAlignment: Text.AlignVCenter
                            color: "white"
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: formContainer.height / 22.5
                        }

                        ComboBox {
                            id: session
                            width: parent.width * 4 / 3; height: formContainer.height / 9
                            font.pixelSize: formContainer.height / 20

                            arrowIcon: "angle-down.png"

                            model: sessionModel
                            index: sessionModel.lastIndex

                            KeyNavigation.backtab: password;
                        }

                    Row {
                        z: 101
                        width: parent.width * 0.8
                        spacing : formContainer.height / 27
                        anchors.bottom: parent.bottom

                        KeyNavigation.backtab: session; KeyNavigation.tab: loginButton
                        }
                    }
                }

                Column {
                    width: parent.width
                    Text {
                        id: errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: textConstants.prompt
                        color: "white"
                        font.pixelSize: formContainer.height / 22.5
                    }
                }

                Row {
                    spacing: Math.round(formContainer.height / 70)
                    anchors.horizontalCenter: parent.horizontalCenter
                    property int btnWidth: Math.max(loginButton.implicitWidth,
                                                    shutdownButton.implicitWidth,
                                                    rebootButton.implicitWidth, formContainer.height / 3) + 8
                    Button {
                        id: loginButton
                        text: textConstants.login
                        width: parent.btnWidth
                        height: formContainer.height / 9
                        font.pixelSize: formContainer.height / 20
                        color: "#F7931E"
                        onClicked: sddm.login(name.text, password.text, session.index)
                        KeyNavigation.tab: shutdownButton

                        // Doesn't work
                        /*MouseArea {
                            hoverEnabled:  true
                            anchors.fill: parent
                            onEntered: parent.color = "#ffffff"
                        }*/
                    }

                    Button {
                        id: shutdownButton
                        text: textConstants.shutdown
                        width: parent.btnWidth
                        height: formContainer.height / 9
                        font.pixelSize: formContainer.height / 20
                        color: "#F7931E"
                        onClicked: sddm.powerOff()
                        KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                    }

                    Button {
                        id: rebootButton
                        text: textConstants.reboot
                        width: parent.btnWidth
                        height: formContainer.height / 9
                        font.pixelSize: formContainer.height / 20
                        color: "#F7931E"
                        onClicked: sddm.reboot()

                        KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
