import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

// SQLite driver
import QtQuick.LocalStorage 2.0

ApplicationWindow {
    property var db;
    property var mdl;
    id: mainWindow
    visible: true
    color: "white"
    title: "idcplc-bible"
    width: 800
    height: 500
    minimumWidth: 800
    minimumHeight: 500

    // Reload list of snippet dari db dan tampilan.
    function reload() {
        db.transaction (function(tx) {
                var rs = tx.executeSql ('select xid from TSnippets');
                mdl = [];
                for (var i = 0; i < rs.rows.length; i++) {
                    mdl.push({"xid" : rs.rows.item(i).xid});
                }
                browser.model = mdl
            }
        )
    }

    Component.onCompleted: {
        // Buat/buka database diawal startup app.
        var dbVer = "1.1";
        db = LocalStorage.openDatabaseSync ("idcplc-bible.sqlite", "", "icplc-bible snippets storage.", 1000000);
        if (db.version != dbVer)
        {
            console.log ("current db version: " + db.version + ", need to upgrade db to version " + dbVer);
            db.changeVersion (db.version, dbVer, function(tx) {
                    console.log ("upgrading db to version " + dbVer);
                    tx.executeSql ('drop table if exists TSnippets');
                    tx.executeSql ('create table if not exists TSnippets (xid integer primary key, contributor text, title text, description text, snippet text, platforms text, languages text, dialects text, category text, tag text, src text, checksum text, updated integer)');
                    tx.executeSql ('create index if not exists TSnippetsContributorIndex on TSnippets (contributor)');
                }
            )
            reload();
        }
    }

    // Main screen terbagi 2 panel kiri (browser) dan kanan (TextEdit) dipisahkan dengan splitview.
    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        // Container untuk button add snippet dan listview
        // Minimal width 200, maximal width 400, default width 250 (@geger009)
        Rectangle {
            id: leftcontainer
            color: "#323844"
            width: 250
            height: parent.height
            Layout.minimumWidth: 100
            Layout.maximumWidth: 400

            Button {
                text: "Add Snippet"
                anchors.top: parent.top
                anchors.topMargin: 0
                onClicked: addView.visible = true
                width: 250
                height: 30
                anchors.left: parent.left
                anchors.right: parent.right
                style: ButtonStyle {
                    background: Rectangle {
                        color: "#3C4351"
                        border.width: 0
                        radius: 0
                    }

                    label: Text {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: "lightgray"
                        text: control.text
                    }
                }
            }

            // View untuk menampilkan daftar snippets (panel kiri).
            ListView {
                id: browser
                width: 250
                anchors.top: parent.top
                anchors.topMargin: 30
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                flickableDirection: Flickable.HorizontalFlick
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.left: parent.left
                anchors.right: parent.right
                highlight: Rectangle { color: "#2B303B"}
                focus: true
                model: mdl

                delegate: Component {
                    Item {
                        width: parent.width
                        height: 20
                        Column {
                            Text {
                                text: {
                                    db.transaction (function(tx) {
                                            var rs = tx.executeSql ('select title from TSnippets where xid=?', [model.modelData.xid]);
                                            text = rs.rows.item(0).title;
                                        }
                                    )
                                }
                                color: "lightgray"
                            }
                        }

                        MouseArea {
                            id: itemMouseArea
                            anchors.fill: parent

                            // On select item with mouse click
                            onClicked: {
                                browser.focus = true
                                browser.currentIndex = index
                                db.transaction (function(tx) {
                                        var rs = tx.executeSql ('select snippet from TSnippets where xid=?', [model.modelData.xid]);
                                        sourceView.text = rs.rows.item(0).snippet;
                                    }
                                )
                            }
                        }

                        // On select item by keyboard.
                        onActiveFocusChanged: {
                            db.transaction (function(tx) {
                                    var rs = tx.executeSql ('select snippet from TSnippets where xid=?', [mdl[ browser.currentIndex ].xid]);
                                    sourceView.text = rs.rows.item(0).snippet;
                                }
                            )
                        }
                    }
                }
            }
        }

        // Container untuk source code/snippet.
        Rectangle {
            id: rightcontainer
            color: "white"
            height: parent.height
            anchors.left: leftcontainer.right
            anchors.right: parent.right

            // View untuk menampilkan snippet source code dengan higlighter (panel kanan).
            TextArea {
                id: sourceView
                objectName: "sourceView"
                frameVisible: false
                font.family: "Consolas"
                font.pointSize: 12
                readOnly: true

                style: TextAreaStyle {
                    textColor: "lightgray"
                    selectionColor: "steelblue"
                    selectedTextColor: "#eee"
                    backgroundColor: "#2E333E"
                }

                clip: true
                anchors.fill: parent
                text: ""
            }

        }

    } // SplitView

    // View untuk input snippet.
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
                        reload();
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
