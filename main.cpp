#include <QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QQuickTextDocument>
#include <QObject>
#include "highlighter.h"

int main(int argc, char ** argv)
{
    Highlighter *highlighter;

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

     QObject *root = engine.rootObjects()[0];
    QObject *textEditor = root->findChild <QObject*>("textEditor");
    if (textEditor != NULL)
    {
        printf ("found! editor\n");
        QQuickTextDocument *doc = qvariant_cast<QQuickTextDocument*>(textEditor->property("textDocument"));
        if (doc != NULL)
        {
            printf ("found! doc\n");
            highlighter = new Highlighter(doc->textDocument());

        }
    }
    return app.exec();
}

