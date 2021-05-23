class StringToIntTypeAdapter {
  static String? toJson(int? value) {
    return value?.toString();
  }

  static int? fromJson(String? value) {
    if (value == null) {
      return null;
    }
    return int.parse(value);
  }
}
