part of 'law_entity.dart';

extension JsonConverter on LawEntity {
  static String? _yearToJson(int? value) {
    return value?.toString();
  }

  static int? _yearFromJson(String? value) {
    if (value == null) {
      return null;
    }
    return int.parse(value);
  }
}
