#include "highlighter.h"

//! [0]
Highlighter::Highlighter(QTextDocument *parent)
    : QSyntaxHighlighter(parent)
{
    HighlightingRule rule;

    QBrush brushKeyword (QColor(185,144,157));
    keywordFormat.setForeground(brushKeyword);
    keywordFormat.setFontFamily("Consolas");
    keywordFormat.setFontWeight(QFont::Normal);
    keywordFormat.setFontPointSize (12.0);
    QStringList keywordPatterns;
    keywordPatterns << "\\bchar\\b" << "\\bclass\\b" << "\\bconst\\b"
                    << "\\bdouble\\b" << "\\benum\\b" << "\\bexplicit\\b"
                    << "\\bfriend\\b" << "\\binline\\b" << "\\bint\\b"
                    << "\\blong\\b" << "\\bnamespace\\b" << "\\boperator\\b"
                    << "\\bprivate\\b" << "\\bprotected\\b" << "\\bpublic\\b"
                    << "\\bshort\\b" << "\\bsignals\\b" << "\\bsigned\\b"
                    << "\\bslots\\b" << "\\bstatic\\b" << "\\bstruct\\b"
                    << "\\btemplate\\b" << "\\btypedef\\b" << "\\btypename\\b"
                    << "\\bunion\\b" << "\\bunsigned\\b" << "\\bvirtual\\b"
                    << "\\bvoid\\b" << "\\bvolatile\\b";
    foreach (const QString &pattern, keywordPatterns) {
        rule.pattern = QRegExp(pattern);
        rule.format = keywordFormat;
        highlightingRules.append(rule);
//! [0] //! [1]
    }
//! [1]

//! [2]
    classFormat.setForeground(Qt::darkMagenta);
    classFormat.setFontFamily ("Consolas");
    classFormat.setFontWeight(QFont::Normal);
    classFormat.setFontPointSize (12.0);
    rule.pattern = QRegExp("\\bQ[A-Za-z]+\\b");
    rule.format = classFormat;
    highlightingRules.append(rule);
//! [2]

//! [3]
    QBrush brushComment (QColor(116,134,143));
    singleLineCommentFormat.setForeground(brushComment);
    singleLineCommentFormat.setFontFamily ("Consolas");
    singleLineCommentFormat.setFontWeight(QFont::Normal);
    singleLineCommentFormat.setFontPointSize (12.0);
    rule.pattern = QRegExp("//[^\n]*");
    rule.format = singleLineCommentFormat;
    highlightingRules.append(rule);

    multiLineCommentFormat.setForeground(brushComment);
    multiLineCommentFormat.setFontFamily ("Consolas");
    multiLineCommentFormat.setFontWeight(QFont::Normal);
    multiLineCommentFormat.setFontPointSize (12.0);
//! [3]

//! [4]
    quotationFormat.setForeground(Qt::darkGreen);
    quotationFormat.setFontFamily ("Consolas");
    quotationFormat.setFontWeight(QFont::Normal);
    quotationFormat.setFontPointSize (12.0);
    rule.pattern = QRegExp("\".*\"");
    rule.format = quotationFormat;
    highlightingRules.append(rule);
//! [4]

//! [5]
//    functionFormat.setFontItalic(false);

    QBrush brushFunction (QColor(115,171,225));
    functionFormat.setForeground(brushFunction);
    functionFormat.setFontFamily ("Consolas");
    functionFormat.setFontWeight(QFont::Normal);
    functionFormat.setFontPointSize (12.0);


    rule.pattern = QRegExp("\\b[A-Za-z0-9_]+(?=\\()");
    rule.format = functionFormat;
    highlightingRules.append(rule);
//! [5]

//! [6]
    commentStartExpression = QRegExp("/\\*");
    commentEndExpression = QRegExp("\\*/");
}
//! [6]

//! [7]
void Highlighter::highlightBlock(const QString &text)
{
    foreach (const HighlightingRule &rule, highlightingRules) {
        QRegExp expression(rule.pattern);
        int index = expression.indexIn(text);
        while (index >= 0) {
            int length = expression.matchedLength();
            setFormat(index, length, rule.format);
            index = expression.indexIn(text, index + length);
        }
    }
//! [7] //! [8]
    setCurrentBlockState(0);
//! [8]

//! [9]
    int startIndex = 0;
    if (previousBlockState() != 1)
        startIndex = commentStartExpression.indexIn(text);

//! [9] //! [10]
    while (startIndex >= 0) {
//! [10] //! [11]
        int endIndex = commentEndExpression.indexIn(text, startIndex);
        int commentLength;
        if (endIndex == -1) {
            setCurrentBlockState(1);
            commentLength = text.length() - startIndex;
        } else {
            commentLength = endIndex - startIndex
                            + commentEndExpression.matchedLength();
        }
        setFormat(startIndex, commentLength, multiLineCommentFormat);
        startIndex = commentStartExpression.indexIn(text, startIndex + commentLength);
    }
}
//! [11]
