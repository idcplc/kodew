import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2

// SQLite driver
import QtQuick.LocalStorage 2.0

ApplicationWindow {
    visible: true
    color: "white"
    title: "idcplc-bible"
    width: 800
    height: 500

    Component.onCompleted: {
        // Buat/buka database diawal startup app.
        var db = LocalStorage.openDatabaseSync ("idcplc-bible.sqlite", "1.0", "icplc-bible snippets storage.", 1000000);
        db.transaction (function(tx) {
                tx.executeSql ('create table if not exists TSnippets (xid integer primary key autoincrement, contributor text, snippet text)');
                tx.executeSql ('create index if not exists TSnippetsContributorIndex on TSnippets (contributor)');
                tx.executeSql ('delete from TSnippets');
                tx.executeSql ('insert into TSnippets (contributor, snippet) values (?, ?)', [ 'someone', 'void main()\n{\n\tint var = 100;\n\tprintf(\"Hello world!\");\n)' ]);
                var rs = tx.executeSql ('select contributor, snippet from TSnippets');
                var r = ""
                for (var i = 0; i < rs.rows.length; i++) {
                    r += rs.rows.item(i).contributor + ": " + rs.rows.item(i).snippet + "\n"
                }
                console.log (r);
            }
        )
    }

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
