import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

// SQLite driver
import QtQuick.LocalStorage 2.0

ApplicationWindow {
    property var db;
    property var mdl: [];
    id: mainWindow
    visible: true
    color: "white"
    title: "idcplc-bible"
    width: 800
    height: 500

    Component.onCompleted: {
        // Buat/buka database diawal startup app.
        db = LocalStorage.openDatabaseSync ("idcplc-bible.sqlite", "1.0", "icplc-bible snippets storage.", 1000000);
        db.transaction (function(tx) {
                tx.executeSql ('create table if not exists TSnippets (xid integer primary key autoincrement, contributor text, title text, snippet text)');
                tx.executeSql ('create index if not exists TSnippetsContributorIndex on TSnippets (contributor)');
                var rs = tx.executeSql ('select contributor, title, snippet from TSnippets');
                mdl = [];
                for (var i = 0; i < rs.rows.length; i++) {
                    mdl.push({"title" : rs.rows.item(i).title, "snippet" : rs.rows.item(i).snippet});
                }
                browser.model = mdl
            }
        )
    }

    // Main screen terbagi 2 panel kiri (browser) dan kanan (TextEdit) dipisahkan dengan splitview.
    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Rectangle {
            id: leftcontainer
            color: "white"
            width: 250
            height: parent.height

            Button {
                text: "Add Snippet"
                onClicked: addView.visible = true
                width: 250
                height: 30
                anchors.left: parent.left
                anchors.right: parent.right
                style: ButtonStyle {
                    background: Rectangle {
                        color: "lightgray"
                        border.width: 0
                        radius: 0
                    }
                }
            }

            ListView{
                id: browser
                y: 30
                width: 250
                height: parent.height
                anchors.left: parent.left
                anchors.right: parent.right
                highlight: Rectangle { color: "lightsteelblue"}
                focus: true
                model: mdl
                delegate: Component{
                    Item{
                        property variant itemData: model.modelData
                        width: parent.width
                        height: 20
                        Column{
                            Text {text: model.modelData.title}
                        }
                        MouseArea{
                            id: itemMouseArea
                            anchors.fill: parent
                            onClicked: {
                                browser.currentIndex = index
                                sourceView.text = mdl[ index ].snippet;
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
                id: sourceView
                objectName: "sourceView"
                clip: true
                anchors.fill: parent
                text: "void main()\n{\n\tint var = 100;\n\tprintf(\"Hello world!\");\n)"
            }
        }

    } // SplitView

    Rectangle {
        id: addView
        visible: false
        color: "yellow"
        width: 500
        height: 350
        anchors.centerIn: parent

        TextField {
            id: txtContributor
            placeholderText: qsTr("Contributor")
            x: 20
            y: 20
            width: 300
            height: 30
        }

        TextField {
            id: txtTitle
            placeholderText: qsTr("Title")
            x: 20
            y: 60
            width: 460
            height: 30
        }

        Rectangle {
            color: "white"
            x: 20
            y: 110
            width: 460
            height: 180
            TextEdit {
                id: editSnippet
                anchors.fill: parent
                clip: true
            }
        }

        Button {
            text: "OK"
            onClicked: {
                addView.visible = false
                db.transaction (function(tx) {
                        tx.executeSql ('insert into TSnippets (contributor, title, snippet) values (?, ?, ?)', [txtContributor.text, txtTitle.text, editSnippet.text]);
                        var rs = tx.executeSql ('select contributor, title, snippet from TSnippets');
                        mdl = [];
                        for (var i = 0; i < rs.rows.length; i++) {
                            mdl.push({"title" : rs.rows.item(i).title, "snippet" : rs.rows.item(i).snippet});
                        }
                        browser.model = mdl
                    }
                )
            }
            x: 0
            y: 320
            width: 250
            height: 30
            style: ButtonStyle {
                background: Rectangle {
                    color: "darkgray"
                    border.width: 0
                    radius: 0
                }
            }
        }

        Button {
            text: "Cancel"
            onClicked: addView.visible = false
            x: 250
            y: 320
            width: 250
            height: 30
            style: ButtonStyle {
                background: Rectangle {
                    color: "lightgray"
                    border.width: 0
                    radius: 0
                }
            }
        }



    }
}
