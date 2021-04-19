// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

void main() {
  group('version entity json parser', () {
    test('test parse valid version entity', () {
      String json = """
      {
        "detail": {
          "filenames": [
            "1603971592286-1-1.json",
            "1603971592286-2-1.json",
            "1603971592286-3-1.json",
            "1603971592286-4-1.json",
            "1603971592286-5-1.json",
            "1603971592286-6-1.json"
          ]
        },
        "milis": 1603971592286,
        "timestamp": "2020-10-29 18:39:52"
      }
      """;
      Map<String, dynamic>? jsonMap = jsonDecode(json);
      VersionEntity? entity;
      if (jsonMap != null) {
        entity = VersionEntity.fromJson(jsonMap);
      }
      expect(jsonMap, isNotNull);
      expect(entity, isNotNull);
      expect(entity?.detail, isNotNull);
      expect(entity?.milis, isNotNull);
      expect(entity?.timestamp, isNotNull);
      print(entity);
    });

    test('test parse empty json', () {
      String json = """
      {
      }
      """;
      Map<String, dynamic>? jsonMap = jsonDecode(json);
      VersionEntity? entity;
      if (jsonMap != null) {
        entity = VersionEntity.fromJson(jsonMap);
      }
      expect(jsonMap, isNotNull);
      expect(entity, isNotNull);
      expect(entity?.detail, isNull);
      expect(entity?.milis, isNull);
      expect(entity?.timestamp, isNull);
      print(entity);
    });

    test('test parse non related json', () {
      String json = """
      {
        "a": 1,
        "b": 2,
        "c": 4
      }
      """;
      Map<String, dynamic>? jsonMap = jsonDecode(json);
      VersionEntity? entity;
      if (jsonMap != null) {
        entity = VersionEntity.fromJson(jsonMap);
      }
      expect(jsonMap, isNotNull);
      expect(entity, isNotNull);
      expect(entity?.detail, isNull);
      expect(entity?.milis, isNull);
      expect(entity?.timestamp, isNull);
      print(entity);
    });

    test('test parse explicit null value', () {
      String json = """
      {
        "detail": null,
        "milis": null,
        "timestamp": null
      }
      """;
      Map<String, dynamic>? jsonMap = jsonDecode(json);
      VersionEntity? entity;
      if (jsonMap != null) {
        entity = VersionEntity.fromJson(jsonMap);
      }
      expect(jsonMap, isNotNull);
      expect(entity, isNotNull);
      expect(entity?.detail, isNull);
      expect(entity?.milis, isNull);
      expect(entity?.timestamp, isNull);
      print(entity);
    });

    test('test parse invalid data type', () {
      String json = """
      {
        "detail": 1,
        "milis": 2,
        "timestamp": 3
      }
      """;
      Map<String, dynamic>? jsonMap = jsonDecode(json);
      if (jsonMap != null) {
        expect(() => VersionEntity.fromJson(jsonMap),
            throwsA(predicate((e) => e is TypeError)));
      }
    });
  });
}
