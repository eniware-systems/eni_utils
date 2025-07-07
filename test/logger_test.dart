import 'package:eni_utils/eni_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('can get logger', () {
    final logger = loggerFor("myComponent");
    expect(logger, isNotNull);
  });

  test('getting logger different component returns new instance', () {
    final logger = loggerFor("myComponent");
    final logger2 = loggerFor("myComponent2");
    expect(logger2, isNot(logger));
  });

  test('getting logger for same component returns same instance', () {
    final logger = loggerFor("myComponent");
    final logger2 = loggerFor("myComponent");
    expect(logger2, logger);
  });
}
