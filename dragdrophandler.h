#ifndef DRAGDROPHANDLER_H
#define DRAGDROPHANDLER_H

#include <QObject>

class DragDropHandler: public QObject
{
    Q_OBJECT
public:
    explicit DragDropHandler(QObject *parent = 0);
public slots:
    void runHandler(QString file);
};

#endif
