#include "linenumbers.h"
#include <QDebug>
#include <QPainter>
#include <algorithm>
#include <cmath>
LineNumbers::LineNumbers(QQuickPaintedItem *parent) : QQuickPaintedItem(parent)
{
}

int LineNumbers::lineCount() const
{
    return m_lineCount;
}

int LineNumbers::scrollY() const
{
    return m_scrollY;
}

float LineNumbers::lineHeight() const
{
    return m_lineHeight;
}

QString LineNumbers::text() const
{
    return m_text;
}

int LineNumbers::cursorPosition() const
{
    return m_cursorPosition;
}

int LineNumbers::selectionStart() const
{
    return m_selectionStart;
}

int LineNumbers::selectionEnd() const
{
    return m_selectionEnd;
}

int LineNumbers::fontSize() const
{
    return m_fontSize;
}

void LineNumbers::setLineCount(int lineCount)
{
    if (m_lineCount == lineCount)
        return;

    m_lineCount = lineCount;
    emit lineCountChanged(lineCount);
}

void LineNumbers::setScrollY(int scrollY)
{
    if (m_scrollY == scrollY)
        return;

    m_scrollY = scrollY;
    emit scrollYChanged(scrollY);
}

void LineNumbers::setLineHeight(float lineHeight)
{
    if (m_lineHeight == lineHeight)
            return;

    m_lineHeight = lineHeight;
    emit lineHeightChanged(lineHeight);
}

void LineNumbers::setText(QString text)
{
    if (m_text == text)
            return;

    m_text = text;
    emit textChanged(text);
}

void LineNumbers::setCursorPosition(int cursorPosition)
{
    if (m_cursorPosition == cursorPosition)
            return;

    m_cursorPosition = cursorPosition;
    emit cursorPositionChanged(cursorPosition);
}

void LineNumbers::setSelectionStart(int selectionStart)
{
    if (m_selectionStart == selectionStart)
            return;

    m_selectionStart = selectionStart;
    emit selectionStartChanged(selectionStart);
}

void LineNumbers::setSelectionEnd(int selectionEnd)
{
    if (m_selectionEnd == selectionEnd)
            return;

    m_selectionEnd = selectionEnd;
    emit selectionEndChanged(selectionEnd);
}

void LineNumbers::setFontSize(int fontSize)
{
    if (m_fontSize == fontSize)
        return;

    m_fontSize = fontSize;
    emit fontSizeChanged(fontSize);
}

void LineNumbers::paint(QPainter *painter)
{
    // Find current line
    QString untilSelectedText = m_text.mid(0, selectionStart());
    int selectedTextStartLine = untilSelectedText.count(QRegExp("[\r\n]"))+1;

    QString selectedText = m_text.mid(selectionStart(), (selectionEnd() - selectionStart()));
    int numLinesSelected = selectedText.count(QRegExp("[\r\n]"))+1;

    QString textUntilCursorPosition = m_text.mid(0, m_cursorPosition);
    int cursorLine = textUntilCursorPosition.count(QRegExp("[\r\n]"))+1;

    int firstLineVisible = m_scrollY / m_lineHeight;
    // The last visible line is either the last line in the textfield or if we have scrolled as far as we get with current size
    int lastLineVisible = std::min(firstLineVisible+int(height() / m_lineHeight)+1, m_lineCount);
    int numLines = lastLineVisible - firstLineVisible;

    for (int i=0; i<numLines; i++)
    {
        int lineNumber = i+firstLineVisible+1;
        QFont font("times", 24);
        QFontMetrics fm(font);
        QString text = QString("%1").arg(lineNumber);
        int textWidth = fm.width(text);
        int textHeight = m_lineHeight;
        float x = width()-textWidth*0.5 - 5;
        float y = 4 + i * m_lineHeight;
        QRectF textRect(x,y,textWidth,textHeight);

        painter->setFont(QFont("Consolas", m_fontSize));

        if (lineNumber >= selectedTextStartLine && lineNumber < selectedTextStartLine+numLinesSelected)
        {
            QRectF selectedTextRect(0,y,width(),(m_fontSize + 1));
            painter->setPen(QColor("#eee"));
            painter->drawRect(selectedTextRect);
            painter->fillRect(selectedTextRect, QColor("#eee"));
        }

        if (lineNumber == cursorLine)
        {
            QRectF selectedTextRect(0,y,width(),(m_fontSize + 1));
            painter->setPen(QColor("steelBlue"));
            painter->drawRect(selectedTextRect);
            painter->fillRect(selectedTextRect, QColor("steelBlue"));
        }

        painter->setPen(Qt::lightGray);
        painter->drawText(textRect, text);
    }
}
