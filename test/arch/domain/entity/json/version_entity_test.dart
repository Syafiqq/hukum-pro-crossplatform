// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

void main() {
  group('$VersionEntity', () {
    group('parse', () {
      group('fromJson', () {
        test('success parse', () {
          var jsonMap = {
            'detail': {
              'filenames': ['1']
            },
            'milis': 1,
            'timestamp': '1'
          };
          var entity = VersionEntity.fromJson(jsonMap);
          expect(entity.detail?.filenames, ['1']);
          expect(entity.milis, 1);
          expect(entity.timestamp, '1');
        });

        test('success parse from empty json', () {
          var jsonMap = {};
          var entity = VersionEntity.fromJson(jsonMap);
          expect(entity.detail, isNull);
          expect(entity.milis, isNull);
          expect(entity.timestamp, isNull);
        });

        test('success parse from non related json', () {
          var jsonMap = {'a': 1, 'b': 2, 'c': 4};
          var entity = VersionEntity.fromJson(jsonMap);
          expect(entity.detail, isNull);
          expect(entity.milis, isNull);
          expect(entity.timestamp, isNull);
        });

        test('success parse from null value', () {
          var jsonMap = {'detail': null, 'milis': null, 'timestamp': null};
          var entity = VersionEntity.fromJson(jsonMap);
          expect(entity.detail, isNull);
          expect(entity.milis, isNull);
          expect(entity.timestamp, isNull);
        });

        test('failed parse from incorrect data type', () {
          var jsonMap = {'detail': 1, 'milis': 1, 'timestamp': 1};
          expect(() => VersionEntity.fromJson(jsonMap),
              throwsA(predicate((e) => e is TypeError)));
        });
      });

      group('toJson', () {
        test('success parse', () {
          var entity = VersionEntity(VersionDetailEntity([]), 1, '1');
          var jsonMap = entity.toJson();
          expect(jsonMap.keys.length, 3);
          expect(jsonMap['detail'], {'filenames': []});
          expect(jsonMap['milis'], 1);
          expect(jsonMap['timestamp'], '1');
        });

        test('success parse from null value', () {
          var entity = VersionEntity(null, null, null);
          var jsonMap = entity.toJson();
          expect(jsonMap.keys.length, 3);
          expect(jsonMap['detail'], isNull);
          expect(jsonMap['milis'], isNull);
          expect(jsonMap['timestamp'], isNull);
        });
      });
    });

    group('$Equatable', () {
      test('compare same instance', () {
        var entity = VersionEntity(null, null, null);
        expect(entity == entity, true);
      });

      test('compare different instance', () {
        var entity = VersionEntity(null, null, null);
        expect(entity == VersionEntity(null, null, null), true);
      });

      test('failed different value', () {
        var entity = VersionEntity(null, 1, null);
        expect(entity == VersionEntity(null, 2, null), false);
      });
    });
  });
  group('$VersionDetailEntity', () {
    group('parse', () {
      group('fromJson', () {
        test('success parse', () {
          var jsonMap = {
            'filenames': ['1']
          };
          var entity = VersionDetailEntity.fromJson(jsonMap);
          expect(entity.filenames, ['1']);
        });

        test('success parse from empty json', () {
          var jsonMap = {};
          var entity = VersionDetailEntity.fromJson(jsonMap);
          expect(entity.filenames, isNull);
        });

        test('success parse from non related json', () {
          var jsonMap = {'a': 1, 'b': 2, 'c': 4};
          var entity = VersionDetailEntity.fromJson(jsonMap);
          expect(entity.filenames, isNull);
        });

        test('success parse from null value', () {
          var jsonMap = {'filenames': null};
          var entity = VersionDetailEntity.fromJson(jsonMap);
          expect(entity.filenames, isNull);
        });

        test('failed parse from incorrect data type', () {
          var jsonMap = {'filenames': 1};
          expect(() => VersionDetailEntity.fromJson(jsonMap),
              throwsA(predicate((e) => e is TypeError)));
        });
      });

      group('toJson', () {
        test('success parse', () {
          var entity = VersionDetailEntity([]);
          var jsonMap = entity.toJson();
          expect(jsonMap.keys.length, 1);
          expect(jsonMap['filenames'], []);
        });

        test('success parse from null value', () {
          var entity = VersionDetailEntity(null);
          var jsonMap = entity.toJson();
          expect(jsonMap.keys.length, 1);
          expect(jsonMap['filenames'], isNull);
        });
      });
    });

    group('$Equatable', () {
      test('compare same instance', () {
        var entity = VersionDetailEntity(null);
        expect(entity == entity, true);
      });

      test('compare different instance', () {
        var entity = VersionDetailEntity(null);
        expect(entity == VersionDetailEntity(null), true);
      });

      test('failed different value', () {
        var entity = VersionDetailEntity(['1']);
        expect(entity == VersionDetailEntity(['2']), false);
      });
    });
  });
}
