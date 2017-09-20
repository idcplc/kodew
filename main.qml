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
        var dbVer = "1.2";
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
        }
        reload();
    }

    // Main screen terbagi 2 panel kiri (browser) dan kanan (TextEdit) dipisahkan dengan splitview.
    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        handleDelegate: Rectangle {
            width: 1
            color: "#3D4451"
        }

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
                x: 0
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
                highlight: Rectangle {
                    color: "#2B303B"
                }
                focus: true
                model: mdl

                delegate: Component {
                    Item {
                        x: 10
                        width: parent.width
                        height: 25
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
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
                                        var rs = tx.executeSql ('select title, description, snippet from TSnippets where xid=?', [model.modelData.xid]);
                                        labelTitle.text = rs.rows.item(0).title;
                                        labelDescription.text = rs.rows.item(0).description;
                                        sourceView.text = rs.rows.item(0).snippet;
                                    }
                                )
                            }
                        }
                    }
                } // delegate

                // Navigate snippet using key up.
                Keys.onUpPressed: {
                    if (count > 0 && currentIndex > 0)
                    {
                        currentIndex--;
                        db.transaction (function(tx) {
                                var rs = tx.executeSql ('select title, description, snippet from TSnippets where xid=?', [model[ currentIndex ].xid]);
                                labelTitle.text = rs.rows.item(0).title;
                                labelDescription.text = rs.rows.item(0).description;
                                sourceView.text = rs.rows.item(0).snippet;
                            }
                        )
                    }
                }

                // Navigate snippet using key down.
                Keys.onDownPressed: {
                    if (currentIndex < (count-1))
                    {
                        currentIndex++;
                        db.transaction (function(tx) {
                                var rs = tx.executeSql ('select title, description, snippet from TSnippets where xid=?', [model[ currentIndex ].xid]);
                                labelTitle.text = rs.rows.item(0).title;
                                labelDescription.text = rs.rows.item(0).description;
                                sourceView.text = rs.rows.item(0).snippet;
                            }
                        )
                    }
                }
            }
        }

        // Container untuk source code/snippet.
        Rectangle {
            id: rightcontainer
            color: "#2E333E"
            height: parent.height
            anchors.left: leftcontainer.right
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

            // Snippet view
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
                y: (127 + 10)
                height: parent.height - (127 + 20)
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.bottomMargin: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: ""
            }

        }

    } // SplitView

    // View untuk input snippet.
    Rectangle {
        id: addView
        visible: false
        color: "#495264"
        width: 500
        height: 450
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

        TextField {
            id: txtCategory
            placeholderText: qsTr("Category")
            x: 20
            y: 100
            width: 250
            height: 30
        }

        TextField {
            id: txtLanguages
            placeholderText: qsTr("Languages")
            x: 20
            y: 140
            width: 250
            height: 30
        }

        TextField {
            id: txtDescription
            placeholderText: qsTr("Description")
            x: 20
            y: 180
            width: 460
            height: 30
        }
        Rectangle {
            color: "white"
            x: 20
            y: 220
            width: 460
            height: 180
            TextArea {
                id: editSnippet
                frameVisible: false
                anchors.fill: parent
                clip: true
            }
        }

        Button {
            text: "OK"
            onClicked: {
                addView.visible = false
                db.transaction (function(tx) {
                        tx.executeSql ('insert into TSnippets (contributor, title, category, languages, description, snippet) values (?, ?, ?, ?, ?, ?)', [txtContributor.text, txtTitle.text, txtCategory.text, txtLanguages.text, txtDescription.text, editSnippet.text]);
                        reload();
                    }
                )
            }
            x: 0
            y: 420
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
            y: 420
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

    } // SplitView
}
