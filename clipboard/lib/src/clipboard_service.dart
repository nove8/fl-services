import 'package:async/async.dart';

/// A service interface for interactions with device clipboard.
abstract interface class ClipboardService {
  /// Putting text to device clipboard.
  Future<Result<void>> setTextToClipboard({required String text});
}
