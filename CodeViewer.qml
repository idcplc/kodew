import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

// SQLite driver
import QtQuick.LocalStorage 2.0

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
    // https://forum.qt.io/topic/29016/solved-code-editor-using-qml/4
    Rectangle {
        id: lineNumbers
        property int rowHeight: sourceView.font.pixelSize + 3
        color: "transparent"
        width: 35
        height: parent.height - (127 + 20)
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        clip: true
        Column {
            y: -sourceView.flickableItem.contentY + 4
            Repeater {
                model: sourceView.lineCount
                delegate: Text {
                    id: text
                    color: "#666"
                    font: sourceView.font
                    width: lineNumbers.width
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: lineNumbers.rowHeight
                    renderType: Text.NativeRendering
                    text: index + 1
                }
            }
        }
    }

    // Snippet view
    FocusScope {
        id: root
        property alias font: sourceView.font
        property alias text: sourceView.text

        height: parent.height - (127 + 20)
        anchors.left: lineNumbers.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        TextArea {
            id: sourceView
            property var curPosRect // rectangle
            property bool disableReciever: false

            focus:true
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

                // https://forum.qt.io/topic/68264/any-way-to-customize-the-appearance-of-textarea-scrollview-scrollbars/7
                incrementControl: null
                decrementControl: null
                handle: Rectangle {
                    implicitWidth: 10
                    implicitHeight: 10
                    color: styleData.pressed ? "dimgray" : "gray"
                    radius: 10
                    opacity:0.7
                }

                corner:Rectangle{
                    color: "#1E000000"
                }
                scrollBarBackground: Rectangle {
                    implicitWidth: 10
                    implicitHeight: 10
                    color: "#1E000000"
                    radius: 10
                }
            }
            anchors.fill: parent
            text: ""
            Component.onCompleted: {
                flickableItem.contentYChanged.connect(update)
            }

            onLineCountChanged: {
                this.disableReciever = true
                this.curPosRect = positionToRectangle(0)
                this.disableReciever = false
            }

            onCursorPositionChanged: {
                if (this.selectionStart && this.selectionEnd)
                {
                    this.disableReciever = true
                    this.curPosRect = cursorRectangle
                    this.disableReciever = false
                }
            }

            function receievePos(postX, postY)
            {
                if (disableReciever == false)
                {
                    var curPos = positionAt(postX, postY + sourceView.flickableItem.contentY)
                    this.curPosRect = positionToRectangle(curPos)
                }
            }

            Rectangle {
                signal dropSignal(string fname)
                id: dropArea
                objectName: "dropArea"
                visible: true
                color: "transparent"
                anchors.fill: parent
                DropArea {
                    id: drop
                    anchors.fill: parent
                    enabled: true

                    onEntered: {
                        parent.color="#670A75FD"
                        dropLayer.visible=true;
                        console.log("entered");
                    }

                    onExited:{
                        parent.color="transparent"
                        dropLayer.visible=false;
                        console.log("exited");
                    }

                    onDropped: function(drag){
                        console.log(drag.text);
                        parent.dropSignal(drag.text);
                        parent.color="transparent"
                        dropLayer.visible=false;
                        console.log("dropped");
                    }
                }
                Column {
                    id:dropLayer
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    visible: false
                    spacing:-15
                    Text{
                        id:plusDrop
                        text:"+"
                        color: "white"
                        font.pointSize: 64
                        font.family: "Consolas"
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        style: Text.Raised;
                        styleColor: "#F0F0F0"

                    }
                    Text {
                        id: textDrop
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Add snippet"
                        color: "white"
                        font.pointSize: 24
                        font.family: "Consolas"
                    }
                }
            }    // drag and drop area
        }

        Rectangle {
            id:highlight
            y: (sourceView.curPosRect) ? (sourceView.curPosRect.y - sourceView.flickableItem.contentY) : 0
            color: "lightsteelblue"
            height: sourceView.cursorRectangle.height
            width: root.width
            visible: (y < sourceView.y - (this.height * 1/3)) ? false : true
            opacity: 0.1
        } // current line highlight

        //https://stackoverflow.com/questions/16183408/mousearea-stole-qml-elements-mouse-events
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
            onClicked: mouse.accepted = false
            onPressed: mouse.accepted = false
            onReleased: mouse.accepted = false
            onDoubleClicked: mouse.accepted = false
            onPositionChanged: {
                mouse.accepted = false
                forward(mouse)
            }

            onPressAndHold:mouse.accepted = false;

            onWheel: function(whell){
                whell.accepted = false
                forward(whell)
            }

            function forward(event) {
                mouseArea.visible = false
                var item = parent.childAt(event.x, event.y)
                mouseArea.visible = true
                if (item && item.receievePos)
                    item.receievePos(mouseX, mouseY)
            }
        }
    }
} // Code viewer

