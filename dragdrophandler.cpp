#include "dragdrophandler.h"
#include <QDebug>
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
