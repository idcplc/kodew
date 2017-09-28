#include "dragdrophandler.h"
#include <QDebug>
#include <fstream>
#include <streambuf>
#include <QFile>




DragDropHandler::DragDropHandler(QObject *parent): QObject(parent)
{

}

void DragDropHandler::runHandler(QString file)
{
    int substactor;
#ifdef __APPLE__
    substactor = 7;
#elif _WIN32
    substactor = 8;
#elif __linux__
    substactor = 7;
#endif

    qDebug() << file << "\n";
    // ------------------------------------------------------------------------------------------------------
    // TODO: ini string nya kalau di mac dalam format "file://<path ke file>"
    // Untuk extrak <path ke file> pakai substr(7), menghilangkan 7 karakter di depan
    // Untuk windows (dan linux?) harus di cek dulu format string file supaya bisa di ekstrak path ke file nya
    // ------------------------------------------------------------------------------------------------------
    /*std::string fpath = file.toStdString().substr(7);
   
    std::ifstream f(fpath);
    std::string fcontents((std::istreambuf_iterator<char>(f)),
                          std::istreambuf_iterator<char>());*/

    QFile files(file.right(file.length() - substactor));

    files.open(QIODevice::ReadOnly);

    QTextStream in(&files);
    
    QObject *addSnippetView = this->parent()->findChild<QObject*>("addSnippetView");
    if(addSnippetView){
        qDebug() << "addSnippetView" << "\n";
        addSnippetView->setProperty("visible", true);
        QObject *editSnippet = this->parent()->findChild<QObject*>("editSnippet");
        if(editSnippet){
            qDebug() << "editSnippet found" << "\n";
            editSnippet->setProperty("text", in.readAll());
        }
    }
}
