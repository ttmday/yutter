class YResult {
  final String? message;
  final dynamic data;

  const YResult(this.message, {this.data});
}

class EResult {
  final String message;
  final dynamic error;

  const EResult({required this.message, this.error});
}
