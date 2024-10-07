import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    colors: true,
    dateTimeFormat: DateTimeFormat.none,
  ),
);
