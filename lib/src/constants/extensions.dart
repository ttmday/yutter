extension DurationExtension on Duration {
  String get formatStr {
    return [
      if (inHours > 0) inHours.toString().padLeft(2, '0'),
      inMinutes.remainder(60).toString().padLeft(2, '0'),
      inSeconds.remainder(60).toString().padLeft(2, '0')
    ].join(":");
  }
}

extension StringExtension on String? {
  String setDefaultIfNullOrEmpty(String dflt) {
    if (this == null) {
      return dflt;
    }

    if (this!.isEmpty) {
      return dflt;
    }

    return this!;
  }

  bool get isNullOrEmpty {
    if (this == null) {
      return true;
    }

    if (this == "") {
      return true;
    }

    return this!.isEmpty;
  }
}
