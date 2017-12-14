QT += qml quick

SOURCES += src/main.cpp \
    src/highlighter.cpp \
    src/dragdrophandler.cpp

RESOURCES += qml.qrc \
    resources.qrc

target.path = bin/macos
INSTALLS += target

HEADERS += \
    src/highlighter.h \
    src/dragdrophandler.h

