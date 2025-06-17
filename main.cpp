#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <calculatorcore.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    CalculatorCore calculator;
    engine.rootContext()->setContextProperty("calcCore", &calculator);

    engine.loadFromModule("Calculator_colibi", "Main");
    return app.exec();
}
