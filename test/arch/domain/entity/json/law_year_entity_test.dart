import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';

void main() {
  group('$LawYearEntity', () {
    group('parse', () {
      group('fromJson', () {
        test('success parse', () {
          var jsonMap = {
            'id': 1,
            'year': 1,
            'count': 1,
          };
          var entity = LawYearEntity.fromJson(jsonMap);
          expect(entity.id, 1);
          expect(entity.year, 1);
          expect(entity.count, 1);
        });

        test('throw error empty json', () {
          var jsonMap = {};
          expect(
              () => LawYearEntity.fromJson(jsonMap),
              throwsA(isA<TypeError>().having((e) => e.toString(), 'toString',
                  "type 'Null' is not a subtype of type 'int' in type cast")));
        });
      });

      group('toJson', () {
        test('success parse', () {
          var entity = LawYearEntity(1, 1, 1);
          var jsonMap = entity.toJson();
          expect(jsonMap.keys.length, 3);
          expect(jsonMap['id'], 1);
          expect(jsonMap['year'], 1);
          expect(jsonMap['count'], 1);
        });
      });
    });

    group('$Equatable', () {
      test('compare same instance', () {
        var entity = LawYearEntity(1, 1, 1);
        expect(entity == entity, true);
      });

      test('compare different instance', () {
        var entity = LawYearEntity(1, 1, 1);
        expect(entity == LawYearEntity(1, 1, 2), true);
      });

      test('failed different id', () {
        var entity = LawYearEntity(1, 1, 1);
        expect(entity == LawYearEntity(2, 1, 1), false);
      });

      test('failed different year', () {
        var entity = LawYearEntity(1, 1, 1);
        expect(entity == LawYearEntity(1, 2, 1), false);
      });
    });
  });
}
