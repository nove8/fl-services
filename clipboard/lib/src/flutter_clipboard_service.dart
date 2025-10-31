import 'package:async/async.dart';
import 'package:clipboard_service/src/clipboard_service.dart';
import 'package:clipboard_service/src/failure/clipboard_failure.dart';
import 'package:clipboard_service/src/util/future_util.dart';
import 'package:flutter/services.dart';

/// Default implementation of [ClipboardService] using flutter.
final class FlutterClipboardService implements ClipboardService {
  /// Creates a [FlutterClipboardService].
  const FlutterClipboardService();

  @override
  Future<Result<void>> setTextToClipboard({required String text}) {
    final ClipboardData clipboardData = ClipboardData(text: text);
    return Clipboard.setData(clipboardData).mapToResult(SetTextToClipboardFailure.new);
  }
}
