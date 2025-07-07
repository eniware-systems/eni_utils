import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class TaggedPrinter extends LogPrinter {
  final _wrappedPrinter = SimplePrinter();
  final String tag;

  TaggedPrinter(this.tag);

  static const _colors = <Level, AnsiColor>{
    Level.all: AnsiColor.none(),
    Level.trace: AnsiColor.fg(5),
    Level.debug: AnsiColor.fg(5),
    Level.info: AnsiColor.fg(2),
    Level.warning: AnsiColor.fg(11),
    Level.error: AnsiColor.fg(1),
    Level.fatal: AnsiColor.fg(1),
    Level.off: AnsiColor.none(),
  };

  @override
  List<String> log(LogEvent event) {
    final color = _colors[event.level] ?? const AnsiColor.none();
    final tagStr = color.call("[$tag]");

    return _wrappedPrinter.log(LogEvent(event.level, "$tagStr ${event.message}",
        time: event.time, error: event.error, stackTrace: event.stackTrace));
  }
}

final _loggers = <(String, Key?), Logger>{};

typedef LoggerFactoryCallback = Logger Function(String component, Key? key);

LoggerFactoryCallback _loggerFactory = defaultLoggerFactory;

void setLoggerFactory(LoggerFactoryCallback createLogger,
    {bool recreate = true}) {
  _loggerFactory = createLogger;
  if (recreate) {
    for (var (component, key) in _loggers.keys) {
      _loggers[(component, key)] = _loggerFactory(component, key);
    }
  }
}

LoggerFactoryCallback defaultLoggerFactory = (component, key) => Logger(
      printer: TaggedPrinter(key == null ? component : "$component($key)"),
    );

Logger loggerFor(String component, [Key? key]) => _loggers
    .putIfAbsent((component, key), () => _loggerFactory(component, key));
