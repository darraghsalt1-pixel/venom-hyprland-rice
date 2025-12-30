import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
property string lastUser: userModel.lastUser
    property int sessionIndex: sessionModel.lastIndex
    width: 1920
    height: 1080

    // 1. Background Image
    Image {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
    }

    // 2. Translucent Sidebar (2/5 of screen width)
    Rectangle {
        id: sidebar
        width: parent.width * 0.4  // 2/5 = 40%
        height: parent.height
        color: "#AA000000" // Black with transparency (Adjust AA for more/less blur)
        anchors.left: parent.left

        // 3. Time and Date Container
Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                id: timeLabel
                text: Qt.formatDateTime(new Date(), "hh:mm")
                color: "white"
                font.pixelSize: 80
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: dateLabel
                text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                color: "#CCCCCC"
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    // 4. Login Input (Placed to the right of the sidebar)
// 4. Login Input (Placed to the right of the sidebar)
    Column {
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.15
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20

Column {
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.15
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20


            Text {
                id: loginLabel
                text: "LOG IN"
                color: "white"
font.bold: true
                font.letterSpacing: 4
                font.pixelSize: 18
anchors.horizontalCenter: parent.horizontalCenter
style: Text.Outline
    styleColor: "black"
            }

        // --- START OF THE PASSWORD FIELD ---
        Rectangle {
            id: passwordFieldBackground
            width: 300
            height: 45
            color: "#3d56e0e6" // Translucent background
            radius: 5
            border.color: passwordInput.activeFocus ? "white" : "transparent"
            border.width: 1

            TextInput {
                id: passwordInput
                anchors.fill: parent
                anchors.margins: 10 
                verticalAlignment: Text.AlignVCenter
                
                font.pixelSize: 20
                color: "white"
                
                // This makes it act like a password field (dots instead of text)
                echoMode: TextInput.Password 
                
                // Focus must be true so you can type immediately
                focus: true 

                // When you press Enter, this runs:
                onAccepted: {
                     container.color = "white"
                     sddm.login(userModel.lastUser, passwordInput.text, sessionModel.lastIndex)
                }
            }
        }
        // --- END OF THE PASSWORD FIELD ---
    }    
    // Timer to update the clock every second
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: timeLabel.text = Qt.formatDateTime(new Date(), "hh:mm")
    }

}
}
