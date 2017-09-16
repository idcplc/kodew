import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2

ApplicationWindow {
    visible: true
    color: "white"
    title: "idcplc-bible"
    width: 800
    height: 500

    Rectangle {
        id: leftcontainer
        color: "lightgray"
        width: 250
        height: parent.height

        ListView{
            id: listview
            width: 250
            height: parent.height
            highlight: Rectangle { color: "lightsteelblue"}
            focus: true
            model: ["Snippet 1", "Snippet 2", "Snippet 3", "Snippet 4",
                "Snippet 5", "Snippet 6", "Snippet 7"]

            delegate: Component{
                Item{
                    property variant itemData: model.modelData
                    width: parent.width
                    height: 12
                    Column{
                        Text {text: model.modelData}
                    }
                    MouseArea{
                        id: itemMouseArea
                        anchors.fill: parent
                        onClicked: {
                            listview.currentIndex = index
                        }
                    }
                }
            }
        }
    }


    Rectangle {
        id: rightcontainer
        color: "white"
        height: parent.height
        anchors.left: leftcontainer.right
        anchors.right: parent.right

        TextEdit {
            id: texteditor
            objectName: "textEditor"
            clip: true
            anchors.fill: parent
            text: "void main()\n{\n\tint var = 100;\n\tprintf(\"Hello world!\");\n)"
        }
   }

}
