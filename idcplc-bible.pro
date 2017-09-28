QT += qml quick

SOURCES += main.cpp \
    highlighter.cpp \
    linenumbers.cpp \
    dragdrophandler.cpp

RESOURCES += idcplc-bible.qrc

target.path = bin/macos
INSTALLS += target

HEADERS += \
    highlighter.h \
    linenumbers.h \
    dragdrophandler.h

