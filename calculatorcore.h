#ifndef CALCULATORCORE_H
#define CALCULATORCORE_H

#include <QObject>
#include <QObject>
#include <QString>

class CalculatorCore : public QObject {
    Q_OBJECT
public:
    explicit CalculatorCore(QObject *parent = nullptr);
    Q_INVOKABLE QString Result(const QString &Expression);
private:
    QList<QString> tokenize(const QString& Expression);
    QList<QString> infixToPostfix(const QList<QString>& tokens);
    QString evaluatePostfix(const QList<QString>& postfix);
    int precedence(const QString& op);
};

#endif // CALCULATORCORE_H
