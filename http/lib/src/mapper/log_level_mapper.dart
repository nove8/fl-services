part of '../http_service_impl.dart';

/// Mapper that transforms service log levels to library log levels.
final class _LogLevelServiceToLibMapper {
  /// Creates a [_LogLevelServiceToLibMapper].
  const _LogLevelServiceToLibMapper();

  /// Transforms a [LogLevel] to its corresponding [pretty_http_logger.LogLevel].
  pretty_http_logger.LogLevel transform(LogLevel logLevel) {
    return switch (logLevel) {
      .none => .NONE,
      .all => .BODY,
    };
  }
}
