import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';

void main() {
  group('$LawMenuOrderEntity', () {
    group('parse', () {
      group('fromJson', () {
        group('individually', () {
          group('id', () {
            test('success parse', () {
              var jsonMap = {'id': '1'};
              var entity = LawEntity.fromJson(jsonMap);
              expect(entity.id, '1');
            });
            test('throw type error invalid data type', () {
              var jsonMap = {'id': 1};
              expect(
                  () => LawEntity.fromJson(jsonMap),
                  throwsA(isA<TypeError>().having(
                      (e) => e.toString(),
                      'toString',
                      "type 'int' is not a subtype of type 'String' in type cast")));
            });
            test('throw type error not exist value', () {
              var jsonMap = {};
              expect(
                  () => LawEntity.fromJson(jsonMap),
                  throwsA(isA<TypeError>().having(
                      (e) => e.toString(),
                      'toString',
                      "type 'Null' is not a subtype of type 'String' in type cast")));
            });
          });
        });
        test('success parse', () {
          var jsonMap = {'id': '1', 'order': 1, 'name': '1'};
          var entity = LawMenuOrderEntity.fromJson(jsonMap);
          expect(entity.id, '1');
          expect(entity.order, 1);
          expect(entity.name, '1');
        });

        test('success parse only id', () {
          var jsonMap = {'id': '1'};
          var entity = LawMenuOrderEntity.fromJson(jsonMap);
          expect(entity.id, '1');
          expect(entity.order, isNull);
          expect(entity.name, isNull);
        });

        test('throw error no id', () {
          var jsonMap = {'order': 1, 'name': '1'};
          expect(
              () => LawMenuOrderEntity.fromJson(jsonMap),
              throwsA(isA<TypeError>().having((e) => e.toString(), 'toString',
                  "type 'Null' is not a subtype of type 'String' in type cast")));
        });

        test('throw error empty json', () {
          var jsonMap = {};
          expect(
              () => LawMenuOrderEntity.fromJson(jsonMap),
              throwsA(isA<TypeError>().having((e) => e.toString(), 'toString',
                  "type 'Null' is not a subtype of type 'String' in type cast")));
        });

        test('throw error invalid data type', () {
          var jsonMap = {'id': 1};
          expect(
              () => LawMenuOrderEntity.fromJson(jsonMap),
              throwsA(isA<TypeError>().having((e) => e.toString(), 'toString',
                  "type 'int' is not a subtype of type 'String' in type cast")));
        });
      });

      group('toJson', () {
        test('success parse', () {
          var entity = LawMenuOrderEntity('1', '1', 1);
          var jsonMap = entity.toJson();
          expect(jsonMap.keys.length, 3);
          expect(jsonMap['id'], '1');
          expect(jsonMap['name'], '1');
          expect(jsonMap['order'], 1);
        });

        test('success parse from explicit null', () {
          var entity = LawMenuOrderEntity('1', null, null);
          var jsonMap = entity.toJson();
          expect(jsonMap.keys.length, 3);
          expect(jsonMap['id'], '1');
          expect(jsonMap['name'], isNull);
          expect(jsonMap['order'], isNull);
        });
      });
    });

    group('$Equatable', () {
      test('compare same instance', () {
        var version = LawMenuOrderEntity('1', null, null);
        expect(version == version, true);
      });

      test('compare different instance', () {
        var version = LawMenuOrderEntity('1', null, null);
        expect(version == LawMenuOrderEntity('1', null, null), true);
      });

      test('failed different value', () {
        var version = LawMenuOrderEntity('1', '1', null);
        expect(version == LawMenuOrderEntity('1', '2', null), false);
      });
    });
  });
}
