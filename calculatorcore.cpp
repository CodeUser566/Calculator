#include "calculatorcore.h"
#include <cmath>
#include <QRegularExpression>
#include <QStack>

CalculatorCore::CalculatorCore(QObject *parent)  : QObject(parent) {}

QString CalculatorCore::Result(const QString &Expression) {
    if(Expression.trimmed().isEmpty())
    {
        return "";
    }

    try {
        auto tokens = tokenize(Expression);
        auto postfix = infixToPostfix(tokens);
        return evaluatePostfix(postfix);
    } catch (...) {
        return "Error";
    }
}

QList<QString> CalculatorCore::tokenize(const QString& expr) {
    QList<QString> tokens;
    QString current;
    const QString operators = "()+-*÷%";
    bool lastWasOperator = true;

    for (int i = 0; i < expr.length(); i++) {
        const QChar& c = expr[i];

        if (c.isDigit() || c == '.') {
            current += c;
            lastWasOperator = false;
        } else if (operators.contains(c)) {
            if (c == '-' && (lastWasOperator || i == 0)) {
                current += c;
            }
            else if (c == '+' && (lastWasOperator || i == 0)) {
            }
            else {
                if (!current.isEmpty()) {
                    tokens << current;
                    current.clear();
                }
                tokens << QString(c);

                if (c != ')') {
                    lastWasOperator = true;
                } else {
                    lastWasOperator = false;
                }
            }
        }
    }

    if (!current.isEmpty()) tokens << current;
    return tokens;
}

int CalculatorCore::precedence(const QString& op){
    if (op == "+" || op == "-") return 1;
    if (op == "*" || op == "÷" || op == "%") return 2;
    return 0;
}

QList<QString> CalculatorCore::infixToPostfix(const QList<QString>& tokens) {
    QList<QString> output;
    QStack<QString> stack;

    for (const QString& token : tokens) {
        bool isNumber = false;
        token.toDouble(&isNumber);

        if (isNumber || token == ".") {
            output << token;
        } else if (token == "(") {
            stack.push(token);
        } else if (token == ")") {
            while (!stack.isEmpty() && stack.top() != "(") {
                output << stack.pop();
            }
            if (!stack.isEmpty()) stack.pop();
        } else {
            while (!stack.isEmpty() &&
                   precedence(stack.top()) >= precedence(token)) {
                output << stack.pop();
            }
            stack.push(token);
        }
    }

    while (!stack.isEmpty()) {
        output << stack.pop();
    }

    return output;
}


QString CalculatorCore::evaluatePostfix(const QList<QString>& postfix) {
    QStack<double> stack;


    for (const QString& token : postfix) {
        bool ok;
        double value = token.toDouble(&ok);

        if (ok) {
            stack.push(value);
        } else {
            if (stack.size() < 2) {
                if (token == "-" && stack.size() == 1) {
                    double a = stack.pop();
                    stack.push(-a);
                    continue;
                }
                return "Error";
            }

            double b = stack.pop();
            double a = stack.pop();

            if (token == "+") stack.push(a + b);
            else if (token == "-") stack.push(a - b);
            else if (token == "*") stack.push(a * b);
            else if (token == "÷") {
                if (b == 0) return "Error";
                stack.push(a / b);
            }
            else if (token == "%") stack.push(std::fmod(a,b));
        }
    }

    if (stack.size() != 1) return "Error";

    double result = stack.pop();
    QString strResult = QString::number(result, 'g', 15);

    if (strResult.contains('.')) {
        int n = strResult.length() - 1;
        while (n >= 0 && strResult[n] == '0') n--;
        if (n >= 0 && strResult[n] == '.') n--;
        strResult = strResult.left(n + 1);
    }

    return strResult;
}
