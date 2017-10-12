import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

// SQLite driver
import QtQuick.LocalStorage 2.0

// View untuk input snippet.
Rectangle {
    id: addSnippetView
    objectName: "addSnippetView"
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
            objectName: "editSnippet"
            frameVisible: false
            anchors.fill: parent
            clip: true
        }
    }

    function clearForm()
    {
        txtContributor.text = ""
        txtTitle.text = ""
        txtCategory.text = ""
        txtLanguages.text = ""
        txtDescription.text = ""
        editSnippet.text = ""
    }

    Button {
        text: "OK"
        onClicked: {
            addSnippetView.visible = false
            db.transaction (function(tx) {
                    tx.executeSql ('insert into TSnippets (contributor, title, category, languages, description, snippet) values (?, ?, ?, ?, ?, ?)', [txtContributor.text, txtTitle.text, txtCategory.text, txtLanguages.text, txtDescription.text, editSnippet.text]);
                    reload();
                }
            )
            clearForm();
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
        onClicked:
        {
            addSnippetView.visible = false
            clearForm();
        }
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
}
