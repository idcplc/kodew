#include <QGuiApplication>
#include <QStringList>
#include <qqmlengine.h>
#include <qqmlcontext.h>
#include <qqml.h>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickview.h>

int main(int argc, char ** argv)
{
    QGuiApplication app(argc, argv);

    QStringList dataList;
    dataList.append("Snippet 1");
    dataList.append("Snippet 2");
    dataList.append("Snippet 3");
    dataList.append("Snippet 4");
    QQuickView view;
    QQmlContext *ctxt = view.rootContext();
    ctxt->setContextProperty("snippetBrowserModel", QVariant::fromValue(dataList));

    view.setSource(QUrl("qrc:view.qml"));
    view.show();

    return app.exec();
}

