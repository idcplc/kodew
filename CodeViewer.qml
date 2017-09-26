import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

// SQLite driver
import QtQuick.LocalStorage 2.0

// Line Numbers
import CodeEditor 0.1

// Code viewer
Rectangle {
    id: codeViewer
    property alias labelTitle : labelTitle
    property alias labelDescription : labelDescription
    property alias sourceView : sourceView

    color: "#2E333E"
    height: parent.height
    anchors.left: snippetBrowser.right
    anchors.right: parent.right

    // Snippet title view

    // Title bar
    Rectangle {
        color: "#2E333E"
        x: 0
        y: 0
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        Label {
            id: labelTitle
            x: 10
            y: 10
            height: 20
            width: parent.width - 20
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.right: parent.right
            text: ""
            font.pixelSize: 16
            color: "#E5EAEA"
        }

        Rectangle {
            color: "#343A47"
            x: 10
            y: 35
            height: 19
            width: 30
            radius: 3
            border.width: 1
            border.color: "#3D4451"
            Label {
                text: "C"
                color: "#9A9EA4"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
            }

        }

        Rectangle {
            color: "#343A47"
            x: 45
            y: 35
            height: 19
            width: 50
            radius: 3
            border.width: 1
            border.color: "#3D4451"
            Label {
                text: "C++"
                color: "#9A9EA4"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
            }

        }
    }

    // Separator
    Rectangle {
        color: "#3D4451"
        x: 0
        y: 60
        height: 1
        anchors.left: parent.left
        anchors.right: parent.right
    }

    // Description bar
    Rectangle {
        color: "#2E333E"
        x: 0
        y: 61
        height: 65
        anchors.left: parent.left
        anchors.right: parent.right
        Label {
            id: labelDescription
            x: 10
            y: 10
            height: 25
            width: parent.width - 20
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.right: parent.right
            text: ""
            font.pixelSize: 12
            color: "#CED3D3"
            wrapMode: Label.WordWrap
        }
    }

    // Separator
    Rectangle {
        color: "#3D4451"
        x: 0
        y: 126
        height: 1
        anchors.left: parent.left
        anchors.right: parent.right
    }

    // Line Numbers
    LineNumbers {
        id: lineNumbers
        width: 40
        height: parent.height - (127 + 20)
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }

    // Snippet view
    TextArea {
        id: sourceView
        objectName: "sourceView"
        frameVisible: false
        font.family: "Consolas"
        font.pointSize: 12
        readOnly: true
        wrapMode: TextEdit.NoWrap
        style: TextAreaStyle {
            textColor: "lightgray"
            selectionColor: "steelblue"
            selectedTextColor: "#eee"
            backgroundColor: "#2E333E"
        }
        clip: true
        height: parent.height - (127 + 20)
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        anchors.left: lineNumbers.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: ""

        function update() {
            var lineHeight = (font.pointSize + 3) / lineCount
            if (lineHeight < (font.pointSize + 3)) {
                lineHeight = (font.pointSize + 3)
            }
            lineNumbers.lineCount = lineCount
            lineNumbers.scrollY = flickableItem.contentY
            lineNumbers.lineHeight = lineHeight
            lineNumbers.cursorPosition = cursorPosition
            lineNumbers.selectionStart = selectionStart
            lineNumbers.selectionEnd = selectionEnd
            lineNumbers.text = text
            lineNumbers.fontSize = font.pointSize
            lineNumbers.update()
        }

        Component.onCompleted: {
            flickableItem.contentYChanged.connect(update)
            update()
        }

        onLineCountChanged: update()
        onHeightChanged: update()
        onCursorPositionChanged: update()
    }
} // Code viewer
