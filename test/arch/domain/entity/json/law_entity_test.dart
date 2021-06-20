import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';

void main() {
  group('$LawEntity', () {
    group('parse', () {
      group('fromJson', () {
        group('individually', () {
          group('id', () {
            test('success parse', () {
              var jsonMap = {'_id': 1, 'id': '1'};
              var entity = LawEntity.fromJson(jsonMap);
              expect(entity.id, 1);
            });
            test('throw type error invalid data type', () {
              var jsonMap = {'_id': '1', 'id': '1'};
              expect(
                  () => LawEntity.fromJson(jsonMap),
                  throwsA(isA<TypeError>().having(
                      (e) => e.toString(),
                      'toString',
                      "type 'String' is not a subtype of type 'int' in type cast")));
            });
          });
          group('remoteId', () {
            test('success parse', () {
              var jsonMap = {'_id': 1, 'id': '1'};
              var entity = LawEntity.fromJson(jsonMap);
              expect(entity.remoteId, '1');
            });
            test('throw type error invalid data type', () {
              var jsonMap = {'_id': 1, 'id': 1};
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
                      "type 'Null' is not a subtype of type 'int' in type cast")));
            });
          });
          group('year', () {
            test('success parse from string', () {
              var jsonMap = {'_id': 1, 'id': '1', 'year': '1'};
              var entity = LawEntity.fromJson(jsonMap);
              expect(entity.year, 1);
            });
            test('success parse from int', () {
              var jsonMap = {'_id': 1, 'id': '1', 'year': 1};
              var entity = LawEntity.fromJson(jsonMap);
              expect(entity.year, 1);
            });
            test('success parse not exist value', () {
              var jsonMap = {'_id': 1, 'id': '1'};
              var entity = LawEntity.fromJson(jsonMap);
              expect(entity.year, isNull);
            });
            test('throw type error invalid data type', () {
              var jsonMap = {'_id': 1, 'id': '1', 'year': []};
              expect(
                  () => LawEntity.fromJson(jsonMap),
                  throwsA(isA<TypeError>().having(
                      (e) => e.toString(),
                      'toString',
                      "type 'List<dynamic>' is not a subtype of type 'String'")));
            });
          });
          group('no, description, status, reference, category', () {
            test('success parse', () {
              var jsonMap = {
                '_id': 1,
                'id': '1',
                'no': '1',
                'description': '1',
                'status': '1',
                'reference': '1',
                'category': '1'
              };
              var entity = LawEntity.fromJson(jsonMap);
              expect(entity.no, '1');
              expect(entity.description, '1');
              expect(entity.status, '1');
              expect(entity.reference, '1');
              expect(entity.category, '1');
            });
            test('success parse not exist value', () {
              var jsonMap = {'_id': 1, 'id': '1'};
              var entity = LawEntity.fromJson(jsonMap);
              expect(entity.no, isNull);
              expect(entity.description, isNull);
              expect(entity.status, isNull);
              expect(entity.reference, isNull);
              expect(entity.category, isNull);
            });
            test('throw type error invalid data type', () {
              var jsonMap = {
                '_id': 1,
                'id': '1',
                'no': 1,
                'description': 1,
                'status': 1,
                'reference': 1,
                'category': 1
              };
              expect(
                  () => LawEntity.fromJson(jsonMap),
                  throwsA(isA<TypeError>().having(
                      (e) => e.toString(),
                      'toString',
                      "type 'int' is not a subtype of type 'String?' in type cast")));
            });
          });
          group('date_created', () {
            test('success parse', () {
              var jsonMap = {
                '_id': 1,
                'id': '1',
                'date_created': '2010-10-10T10:10:10.000Z'
              };
              var entity = LawEntity.fromJson(jsonMap);
              expect(entity.dateCreated, isNotNull);
              expect(entity.dateCreated,
                  DateTime.utc(2010, 10, 10, 10, 10, 10, 0, 0));
            });
            test('return null', () {
              var jsonMap = {
                '_id': 1,
                'id': '1',
                'dateCreated': '2010-10-10T10:10:10.000Z'
              };
              var entity = LawEntity.fromJson(jsonMap);
              expect(entity.dateCreated, isNull);
            });
            test('throw type error invalid date string', () {
              var jsonMap = {
                '_id': 1,
                'id': '1',
                'date_created': '2010-10-10Z10:10:10.000Z'
              };
              expect(
                  () => LawEntity.fromJson(jsonMap),
                  throwsA(isA<FormatException>()
                      .having((e) => e.toString(), 'toString',
                          contains('Invalid date format'))
                      .having((e) => e.toString(), 'toString',
                          contains('2010-10-10Z10:10:10.000Z'))));
            });
          });
        });
        test('success parse', () {
          var jsonMap = {
            '_id': 1,
            'id': '1',
            'year': '1',
            'no': '1',
            'description': '1',
            'status': '1',
            'reference': '1',
            'category': '1',
            'date_created': '2010-10-10T10:10:10.000Z'
          };
          var entity = LawEntity.fromJson(jsonMap);
          expect(entity.no, '1');
          expect(entity.year, 1);
          expect(entity.description, '1');
          expect(entity.status, '1');
          expect(entity.reference, '1');
          expect(entity.category, '1');
          expect(
              entity.dateCreated, DateTime.utc(2010, 10, 10, 10, 10, 10, 0, 0));
        });

        test('success parse only id and remote id', () {
          var jsonMap = {'_id': 1, 'id': '1'};
          var entity = LawEntity.fromJson(jsonMap);
          expect(entity.id, 1);
          expect(entity.remoteId, '1');
          expect(entity.no, isNull);
          expect(entity.year, isNull);
          expect(entity.description, isNull);
          expect(entity.status, isNull);
          expect(entity.reference, isNull);
          expect(entity.category, isNull);
          expect(entity.dateCreated, isNull);
        });

        test('throw error no id', () {
          var jsonMap = {'year': '1'};
          expect(
              () => LawEntity.fromJson(jsonMap),
              throwsA(isA<TypeError>().having((e) => e.toString(), 'toString',
                  "type 'Null' is not a subtype of type 'int' in type cast")));
        });

        test('throw error empty json', () {
          var jsonMap = {};
          expect(
              () => LawEntity.fromJson(jsonMap),
              throwsA(isA<TypeError>().having((e) => e.toString(), 'toString',
                  "type 'Null' is not a subtype of type 'int' in type cast")));
        });
      });

      group('toJson', () {
        test('success parse', () {
          var entity = LawEntity(1, '1', 1, '1', '1', '1', '1', '1',
              DateTime.utc(2010, 10, 10, 10, 10, 10, 0, 0));
          var jsonMap = entity.toJson();
          expect(jsonMap.keys.length, 9);
          expect(jsonMap['_id'], 1);
          expect(jsonMap['id'], '1');
          expect(jsonMap['year'], '1');
          expect(jsonMap['no'], '1');
          expect(jsonMap['description'], '1');
          expect(jsonMap['status'], '1');
          expect(jsonMap['reference'], '1');
          expect(jsonMap['category'], '1');
          expect(jsonMap['date_created'], '2010-10-10T10:10:10.000Z');
        });

        test('success parse from explicit null', () {
          var entity =
              LawEntity(1, '1', null, null, null, null, null, null, null);
          var jsonMap = entity.toJson();
          expect(jsonMap.keys.length, 9);
          expect(jsonMap['_id'], 1);
          expect(jsonMap['id'], '1');
          expect(jsonMap['year'], isNull);
          expect(jsonMap['no'], isNull);
          expect(jsonMap['description'], isNull);
          expect(jsonMap['status'], isNull);
          expect(jsonMap['reference'], isNull);
          expect(jsonMap['category'], isNull);
          expect(jsonMap['date_created'], isNull);
        });
      });
    });

    group('$Equatable', () {
      test('compare same instance', () {
        var entity =
            LawEntity(1, '1', null, null, null, null, null, null, null);
        expect(entity == entity, true);
      });

      test('compare different instance', () {
        var entity =
            LawEntity(1, '1', null, null, null, null, null, null, null);
        expect(
            entity ==
                LawEntity(1, '1', null, null, null, null, null, null, null),
            true);
      });

      test('failed different value', () {
        var entity = LawEntity(1, '1', 1, null, null, null, null, null, null);
        expect(
            entity == LawEntity(1, '2', 1, null, null, null, null, null, null),
            false);
      });
    });
  });
}
