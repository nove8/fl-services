import 'package:flutter/widgets.dart';

/// Provides current [BuildContext] of the app.
abstract interface class ContextProvider {
  /// Current [BuildContext] of the app.
  BuildContext get context;
}
