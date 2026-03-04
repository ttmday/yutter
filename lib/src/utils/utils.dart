String sanitizeString(String input) {
  final defaultstr = "yutter_${DateTime.now().toString()}";
  if (input.isEmpty) return defaultstr;

  String result = input.replaceAll(
    RegExp(r'[^\p{L}\p{N}\s\.\-_]', unicode: true),
    '',
  );

  result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

  return result.isEmpty ? defaultstr : result;
}
