import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

// SQLite driver
import QtQuick.LocalStorage 2.0

ApplicationWindow {
    property var db;
    property var categories;
    property var mdl;

    id: mainWindow
    visible: true
    color: "white"
    title: "kodew"
    width: 900
    height: 600
    minimumWidth: 800
    minimumHeight: 600

    function reload() {
        db.transaction (function(tx) {
                // Load up categories to categoryBrowser.
                var rs = tx.executeSql ('select distinct category from TSnippets');
                mainWindow.categories = [];
                mainWindow.categories.push({"category" : "All"});
                for (var i = 0; i < rs.rows.length; i++) {
                    var cat = rs.rows.item(i).category;
                    if(cat.toUpperCase() === "ALL") {
                        continue;
                    }
                    mainWindow.categories.push({"category" : cat});
                }
                categoryBrowser.browser.model = mainWindow.categories;
                reloadSnippets();
            }
        )
    }

    function reloadSnippets() {
        var activeCategory = categoryBrowser.browser.model[ categoryBrowser.browser.currentIndex ].category;
        var filter = snippetBrowser.txtSearch.text;
        db.transaction (function(tx) {
                var rs;
                if (activeCategory == 'All')
                    rs = tx.executeSql ("select xid from TSnippets where title like '%" + filter + "%'");
                else
                    rs = tx.executeSql ('select xid from TSnippets where category=?', [activeCategory]);
                mainWindow.mdl = [];
                for (var i = 0; i < rs.rows.length; i++) {
                    mainWindow.mdl.push({"xid" : rs.rows.item(i).xid});
                }
                snippetBrowser.browser.model = mainWindow.mdl
            }
        )
    }


    Component.onCompleted: {
        // Buat/buka database diawal startup app.
        var dbVer = "1.2";
        db = LocalStorage.openDatabaseSync ("kodew.sqlite", "", "icplc-bible snippets storage.", 1000000);
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

    // Main screen terbagi 3 panel:  Category browser | Snippet browser | Code viewer
    SplitView {
        id: splitView

        anchors.fill: parent
        orientation: Qt.Horizontal

        handleDelegate: Rectangle {
            width: 1
            color: "#3D4451"
        }

        CategoryBrowser {
            id: categoryBrowser
        }

        SnippetBrowser {
            id: snippetBrowser
        }

        CodeViewer {
            id: codeViewer
        }

    } // SplitView

    // View untuk input snippet.
    AddSnippetView {
        id: addSnippetView
    }
}
