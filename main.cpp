#include <QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QQuickTextDocument>
#include <QObject>
#include "highlighter.h"

int main(int argc, char ** argv)
{
    QGuiApplication app(argc, argv);
    QFontDatabase::addApplicationFont(":/Consolas.ttf");
    QQmlApplicationEngine engine(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    // Cari sourceView object di qml hirarki untuk dipasangkan highlighter.
    Highlighter *highlighter;
    QObject *root = engine.rootObjects()[0];
    QObject *sourceView = root->findChild <QObject*>("sourceView");
    if (sourceView != NULL)
    {
        QQuickTextDocument *doc = qvariant_cast<QQuickTextDocument*>(sourceView->property("textDocument"));
        if (doc != NULL)
        {
            highlighter = new Highlighter(doc->textDocument());

            // Override tab width menjadi 30 device unit.
            QTextOption textOptions = doc->textDocument()->defaultTextOption();
            textOptions.setTabStop(30);
            doc->textDocument()->setDefaultTextOption(textOptions);
        }
    }
    return app.exec();
}

