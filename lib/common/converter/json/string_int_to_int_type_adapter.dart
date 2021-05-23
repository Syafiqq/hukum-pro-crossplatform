class StringIntToIntTypeAdapter {
  static dynamic toJson(int? value) {
    return value?.toString();
  }

  static int? fromJson(dynamic value) {
    if (value is num) {
      return value.toInt();
    } else if (value is String) {
      return int.parse(value);
    } else if (value == null) {
      return null;
    }
    return int.parse(value as String);
  }
}
