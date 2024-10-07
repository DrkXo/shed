// error_state.dart
typedef RetryCallback = Future<void> Function();

class ErrorState {
  final String? message;
  final RetryCallback? retry;

  ErrorState({this.message, this.retry});

  bool get hasError => message != null && message!.isNotEmpty;
}
