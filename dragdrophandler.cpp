#include "dragdrophandler.h"
#include <QDebug>
#include <fstream>
#include <streambuf>

DragDropHandler::DragDropHandler(QObject *parent): QObject(parent)
{

}

void DragDropHandler::runHandler(QString file)
{
    qDebug() << file << "\n";
    // ------------------------------------------------------------------------------------------------------
    // TODO: ini string nya kalau di mac dalam format "file://<path ke file>"
    // Untuk extrak <path ke file> pakai substr(7), menghilangkan 7 karakter di depan
    // Untuk windows (dan linux?) harus di cek dulu format string file supaya bisa di ekstrak path ke file nya
    // ------------------------------------------------------------------------------------------------------
    std::string fpath = file.toStdString().substr(7);
   
    std::ifstream f(fpath);
    std::string fcontents((std::istreambuf_iterator<char>(f)),
                          std::istreambuf_iterator<char>());
    
    QObject *addSnippetView = this->parent()->findChild<QObject*>("addSnippetView");
    if(addSnippetView){
        qDebug() << "addSnippetView" << "\n";
        addSnippetView->setProperty("visible", true);
        QObject *editSnippet = this->parent()->findChild<QObject*>("editSnippet");
        if(editSnippet){
            qDebug() << "editSnippet found" << "\n";
            editSnippet->setProperty("text", fcontents.c_str());
        }
    }
}
