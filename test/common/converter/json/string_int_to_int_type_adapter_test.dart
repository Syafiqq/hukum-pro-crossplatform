import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/common/converter/json/string_int_to_int_type_adapter.dart';

void main() {
  group('$StringIntToIntTypeAdapter', () {
    group('toJson', () {
      test('return from nullable int', () {
        int? value;
        var result = StringIntToIntTypeAdapter.toJson(value);
        expect(result, null);
      });

      test('return from int', () {
        int? value = 5;
        var result = StringIntToIntTypeAdapter.toJson(value);
        expect(result, '5');
      });
    });

    group('fromJson', () {
      test('return from nullable string', () {
        String? value;
        var result = StringIntToIntTypeAdapter.fromJson(value);
        expect(result, null);
      });
      test('return from string', () {
        String? value = '5';
        var result = StringIntToIntTypeAdapter.fromJson(value);
        expect(result, 5);
      });
      test('return from nullable int', () {
        int? value;
        var result = StringIntToIntTypeAdapter.fromJson(value);
        expect(result, null);
      });
      test('return from int', () {
        int? value = 5;
        var result = StringIntToIntTypeAdapter.fromJson(value);
        expect(result, 5);
      });
      test('throw type error from list', () {
        var value = <String>[];
        expect(() => StringIntToIntTypeAdapter.fromJson(value),
            throwsA(isA<TypeError>()));
      });
      test('throw format exception from non int string', () {
        var value = 'x';
        expect(() => StringIntToIntTypeAdapter.fromJson(value),
            throwsA(isA<FormatException>()));
      });
    });
  });
}
