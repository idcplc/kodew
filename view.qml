import QtQuick 2.0

Rectangle {
    width: 800
    height: 500

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
