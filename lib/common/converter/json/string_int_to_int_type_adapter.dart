class StringIntToIntTypeAdapter {
  static dynamic toJson(int? value) {
    return value?.toString();
  }

  static int? fromJson(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is num) {
      return value.toInt();
    }
    return int.parse(value);
  }
}
