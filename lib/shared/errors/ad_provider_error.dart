class AdProviderError implements Exception {
  final String message;

  AdProviderError(this.message);

  @override
  String toString() {
    return "AdProviderError: $message";
  }
}
