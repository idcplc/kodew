#include <QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QQuickTextDocument>
#include <QObject>
#include "highlighter.h"

int main(int argc, char ** argv)
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    // Cari textEditor object di qml hirarki untuk dipasangkan highlighter.
    Highlighter *highlighter;
    QObject *root = engine.rootObjects()[0];
    QObject *textEditor = root->findChild <QObject*>("textEditor");
    if (textEditor != NULL)
    {
        QQuickTextDocument *doc = qvariant_cast<QQuickTextDocument*>(textEditor->property("textDocument"));
        if (doc != NULL)
            highlighter = new Highlighter(doc->textDocument());
    }
    return app.exec();
}

