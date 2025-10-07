import 'package:database_service/src/util/database_bool_util.dart';

/// Extension methods for formatting database arguments.
extension DatabaseArgumentExtensions on Object {
  /// Formats the value for use in SQL statements with proper escaping and type conversion.
  String get formattedValue {
    final Object notFormattedValue = this;
    return notFormattedValue is String
        ? "'$notFormattedValue'"
        : notFormattedValue is bool
        ? notFormattedValue.toInt().toString()
        : notFormattedValue.toString();
  }
}
