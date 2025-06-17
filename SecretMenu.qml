import QtQuick
import QtQuick.Controls
import QtQuick.Window

Rectangle{
    id: secretmenu
    color: "#024873"

    Text {
        y: 85
        width: 329
        height: 65
        text: "Секретное меню"
        anchors.bottom: backbutton.top
        anchors.bottomMargin: 50
        font.pointSize: 30
        font.family: "Open Sans"
        anchors.horizontalCenter: parent.horizontalCenter
    }



    Button{
        id: backbutton
        width: 246
        height: 80
        text: "назад в калькулятор"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
            mainLayout.visible = true
            secretmenu.visible = false
        }

    }
}
