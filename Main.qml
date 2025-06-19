pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Window {
    id: mainWindow
    width: 360
    height: 616
    visible: true
    title: qsTr("Calculator")
    color: "#024873"

    SecretMenu{
        id:secretmenu
        visible: false
        anchors.fill: parent
    }



    property bool secretMode: false
    property string secretCode: ""
    property int secretTimeout: 5000
    property int longPressDuration : 4000

    Timer{
        id: secretResetTimer
        interval : mainWindow.secretTimeout
        onTriggered: {
            mainWindow.secretMode = false
            mainWindow.secretCode = ""
        }
    }

    Timer{
        id: longPressTimer
        interval: mainWindow.longPressDuration
        onTriggered:{
            if(equal.pressed){
                mainWindow.secretMode = true
                mainWindow.secretCode = ""
                secretResetTimer.restart()
            }
        }
    }

    ColumnLayout {
        id: mainLayout
        property string currentExpression: ""
        property int bracketBalance: 0
        visible: true
        anchors.fill: parent


        Rectangle {
            id: back_calculation
            color: "#04bfad"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth:360
            Layout.minimumHeight: 156

            Layout.alignment: Qt.AlignTop
            bottomLeftRadius : 32
            bottomRightRadius : 32

            Column {
                id: column
                anchors.fill: back_calculation
                anchors.margins: 20

                TextInput {
                    id: calculation_line
                    Layout.minimumWidth: 280
                    Layout.minimumHeight: 30
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    readOnly: true
                    font.family: "Open Sans"
                    font.pixelSize: 20
                    color: "#ffffff"
                    text: mainLayout.currentExpression
                    anchors.right: text_result.right
                    anchors.bottom: text_result.top
                    anchors.bottomMargin: 10
                    font.letterSpacing: 0.5
                }

                Text {
                    id: text_result
                    Layout.minimumWidth: 281
                    Layout.minimumHeight: 60
                    color: "#ffffff"
                    font.pixelSize: 50
                    font.family: "Open Sans"
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: "0"
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 35
                    font.letterSpacing: 0.5
                }
            }
        }

        GridLayout {
            id: numpad
            Layout.topMargin: 10
            Layout.bottomMargin: 30
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumWidth: 312
            Layout.minimumHeight: 396
            Layout.fillWidth: true
            Layout.fillHeight: true


            RoundButton {
                id: bkt
                Layout.maximumWidth: 60
                Layout.maximumHeight: 60
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.row: 0
                Layout.column: 0
                display: AbstractButton.IconOnly
                icon.source: "UI/img/buttons/operation/bkt"
                icon.height: 30
                icon.width: 30
                icon.color: "#ffffff"
                background: Rectangle {
                    radius: 30
                    color: bkt.pressed ? "#F7E425" : "#0889A6"
                }

                onClicked: {
                    if (mainLayout.currentExpression === "" ||
                        "+-*÷%(".includes(mainLayout.currentExpression.slice(-1))) {
                        mainLayout.currentExpression += "("
                        mainLayout.bracketBalance++
                    } else if (mainLayout.bracketBalance > 0 &&
                               "0123456789.)".includes(mainLayout.currentExpression.slice(-1))) {
                        mainLayout.currentExpression += ")"
                        mainLayout.bracketBalance--
                    }
                    calculation_line.text = mainLayout.currentExpression
                }
            }

            RoundButton {
                id: plus_minus
                Layout.maximumWidth: 60
                Layout.maximumHeight: 60
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.row: 0
                Layout.column: 1
                display: AbstractButton.IconOnly
                icon.source: "UI/img/buttons/operation/plus_minus"
                icon.height: 30
                icon.width: 30
                icon.color: "#ffffff"
                background: Rectangle {
                    radius: 30
                    color: plus_minus.pressed ? "#F7E425" : "#0889A6"
                }

                onClicked: {
                    if (mainLayout.currentExpression.length > 0) {
                        var lastToken = "";
                        var newExpression = "";
                        var tokens = mainLayout.currentExpression.split(/([()+\-*÷%])/).filter(t => t !== "");

                        if (tokens.length > 0) {
                            lastToken = tokens[tokens.length - 1];
                            var num = parseFloat(lastToken);
                            if (!isNaN(num)) {
                                tokens[tokens.length - 1] = String(-num);
                                newExpression = tokens.join("");
                            } else {
                                newExpression = mainLayout.currentExpression + "(-";
                            }
                        } else {
                            newExpression = "(-";
                        }

                        mainLayout.currentExpression = newExpression;
                        calculation_line.text = mainLayout.currentExpression;
                    } else {
                        mainLayout.currentExpression = "-";
                        calculation_line.text = mainLayout.currentExpression;
                    }
                }
            }

            RoundButton {
                id: percent
                Layout.maximumWidth: 60
                Layout.maximumHeight: 60
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.row: 0
                Layout.column: 2
                display: AbstractButton.IconOnly
                icon.source: "UI/img/buttons/operation/percent"
                icon.height: 30
                icon.width: 30
                icon.color: "#ffffff"
                background: Rectangle {
                    radius: 30
                    color: percent.pressed ? "#F7E425" : "#0889A6"
                }

                onClicked: {
                    mainLayout.currentExpression += "%"
                    calculation_line.text = mainLayout.currentExpression
                }
            }

            RoundButton {
                id: division
                Layout.maximumWidth: 60
                Layout.maximumHeight: 60
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.row: 0
                Layout.column: 3
                display: AbstractButton.IconOnly
                icon.source: "UI/img/buttons/operation/division"
                icon.height: 30
                icon.width: 30
                icon.color: "#ffffff"
                background: Rectangle {
                    radius: 30
                    color: division.pressed ? "#F7E425" : "#0889A6"
                }

                onClicked: {
                    mainLayout.currentExpression += "÷"
                    calculation_line.text = mainLayout.currentExpression
                }
            }

            RoundButton {
                id: multiplication
                Layout.maximumWidth: 60
                Layout.maximumHeight: 60
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.row: 1
                Layout.column: 3
                display: AbstractButton.IconOnly
                icon.source: "UI/img/buttons/operation/multiplication"
                icon.height: 30
                icon.width: 30
                icon.color: "#ffffff"
                background: Rectangle {
                    radius: 30
                    color: multiplication.pressed ? "#F7E425" : "#0889A6"
                }

                onClicked: {
                    mainLayout.currentExpression += "*"
                    calculation_line.text = mainLayout.currentExpression
                }
            }

            RoundButton {
                id: minus
                Layout.maximumWidth: 60
                Layout.maximumHeight: 60
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.row: 2
                Layout.column: 3
                display: AbstractButton.IconOnly
                icon.source: "UI/img/buttons/operation/minus"
                icon.height: 30
                icon.width: 30
                icon.color: "#ffffff"
                background: Rectangle {
                    radius: 30
                    color: minus.pressed ? "#F7E425" : "#0889A6"
                }

                onClicked: {
                    mainLayout.currentExpression += "-"
                    calculation_line.text = mainLayout.currentExpression
                }
            }

            RoundButton {
                id: plus
                Layout.maximumWidth: 60
                Layout.maximumHeight: 60
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.row: 3
                Layout.column: 3
                display: AbstractButton.IconOnly
                icon.source: "UI/img/buttons/operation/Plus"
                icon.height: 30
                icon.width: 30
                icon.color: "#ffffff"
                background: Rectangle {
                    radius: 30
                    color: plus.pressed ? "#F7E425" : "#0889A6"
                }

                onClicked: {
                    mainLayout.currentExpression += "+"
                    calculation_line.text = mainLayout.currentExpression
                }
            }

            RoundButton {
                id: equal
                Layout.maximumWidth: 60
                Layout.maximumHeight: 60
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.row: 4
                Layout.column: 3
                display: AbstractButton.IconOnly
                icon.source: "UI/img/buttons/operation/equal"
                icon.height: 30
                icon.width: 30
                icon.color: "#ffffff"
                background: Rectangle {
                    radius: 30
                    color: equal.pressed ? "#F7E425" : "#0889A6"
                }

                onPressed: {
                    longPressTimer.start()
                      }
                onReleased: {
                    longPressTimer.stop()

                    if(!mainWindow.secretMode) {

                    while (mainLayout.bracketBalance > 0) {
                        mainLayout.currentExpression += ")"
                        mainLayout.bracketBalance--
                    }

                    if (mainLayout.currentExpression.trim() === "") {
                        text_result.text = "0"
                        return;
                    }

                    var result = calcCore.Result(mainLayout.currentExpression)
                        text_result.text = result
                        mainLayout.currentExpression = result

                    mainLayout.bracketBalance = 0
                    }
                }
            }


            RoundButton {
                id: reset
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumWidth: 60
                Layout.maximumHeight: 60
                Layout.row: 4
                Layout.column: 0
                text: "C"
                palette.buttonText : "#FFFFFF"
                font.pixelSize: 24
                font.family: "Open Sans"
                display: AbstractButton.TextOnly
                background: Rectangle {
                    radius: 30
                    color: reset.pressed ? "#F25E5E" : "#ffafb0"
                }

                onClicked: {
                    if(mainWindow.secretMode){
                        mainWindow.secretMode = false
                        secretResetTimer.stop()
                    }

                    mainLayout.currentExpression = ""
                    mainLayout.bracketBalance = 0
                    calculation_line.text = ""
                    text_result.text = "0"
                }
            }

            Repeater {
                model: ListModel {
                    ListElement { symbol: "7"; gridrow: 1; gridcol: 0 }
                    ListElement { symbol: "8"; gridrow: 1; gridcol: 1 }
                    ListElement { symbol: "9"; gridrow: 1; gridcol: 2 }
                    ListElement { symbol: "4"; gridrow: 2; gridcol: 0 }
                    ListElement { symbol: "5"; gridrow: 2; gridcol: 1 }
                    ListElement { symbol: "6"; gridrow: 2; gridcol: 2 }
                    ListElement { symbol: "1"; gridrow: 3; gridcol: 0 }
                    ListElement { symbol: "2"; gridrow: 3; gridcol: 1 }
                    ListElement { symbol: "3"; gridrow: 3; gridcol: 2 }
                    ListElement { symbol: "0"; gridrow: 4; gridcol: 1 }
                    ListElement { symbol: "."; gridrow: 4; gridcol: 2 }
                }

                delegate: RoundButton {
                    id:numberbutton
                    required property string symbol
                    required property int gridrow
                    required property int gridcol

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumWidth: 60
                    Layout.maximumHeight: 60
                    Layout.row: gridrow
                    Layout.column: gridcol
                    font.family: "Open Sans"
                    font.pointSize: 24
                    palette.buttonText: pressed ? "#FFFFFF" : "#024873"
                    text: symbol
                    font.letterSpacing: 1

                    background: Rectangle {
                        radius: 30
                        color: numberbutton.pressed ? "#04BFAD" : "#B0D1D8"
                    }

                    onClicked: {

                        if(mainWindow.secretMode){
                            mainWindow.secretCode += symbol

                            if(mainWindow.secretCode === "123"){
                                secretmenu.visible = true
                                mainLayout.visible = false
                                mainWindow.secretMode = false
                                return
                            }

                            secretResetTimer.restart()
                            return
                        }

                        mainLayout.currentExpression += symbol
                        calculation_line.text = mainLayout.currentExpression
                    }
                }
            }
        }
    }
}
