#ifndef LINENUMBERS_H
#define LINENUMBERS_H

#include <QQuickPaintedItem>

class LineNumbers : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(int lineCount READ lineCount WRITE setLineCount NOTIFY lineCountChanged)
    Q_PROPERTY(int scrollY READ scrollY WRITE setScrollY NOTIFY scrollYChanged)
    Q_PROPERTY(float lineHeight READ lineHeight WRITE setLineHeight NOTIFY lineHeightChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE setCursorPosition NOTIFY cursorPositionChanged)
    Q_PROPERTY(int selectionStart READ selectionStart WRITE setSelectionStart NOTIFY selectionStartChanged)
    Q_PROPERTY(int selectionEnd READ selectionEnd WRITE setSelectionEnd NOTIFY selectionEndChanged)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged) // add font size

public:
    explicit LineNumbers(QQuickPaintedItem *parent = nullptr);
    virtual void paint(QPainter *painter) override;

public:
    int lineCount() const;
    int scrollY() const;
    float lineHeight() const;
    QString text() const;
    int cursorPosition() const;
    int selectionStart() const;
    int selectionEnd() const;
    int fontSize() const; // add font size

public slots:
    void setLineCount(int lineCount);
    void setScrollY(int scrollY);
    void setLineHeight(float lineHeight);
    void setText(QString text);
    void setCursorPosition(int cursorPosition);
    void setSelectionStart(int selectionStart);
    void setSelectionEnd(int selectionEnd);
    void setFontSize(int fontSize); // add font size

signals:
    void lineCountChanged(int lineCount);
    void scrollYChanged(int scrollY);
    void lineHeightChanged(float lineHeight);
    void textChanged(QString text);
    void cursorPositionChanged(int cursorPosition);
    void selectionStartChanged(int selectionStart);
    void selectionEndChanged(int selectionEnd);
    void fontSizeChanged(int fontSize); // add font size

private:
    int m_lineCount = 0;
    int m_scrollY = 0;
    float m_lineHeight = 0;
    int m_cursorPosition = 0;
    QString m_text;
    int m_selectionStart = 0;
    int m_selectionEnd = 0;
    int m_fontSize = 0; // add font size
};

#endif // LINENUMBERS_H
