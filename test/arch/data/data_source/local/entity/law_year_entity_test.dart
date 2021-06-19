import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_year_entity.dart';

void main() {
  group('$LawYearEntity', () {
    group('$Equatable', () {
      test('compare same instance', () {
        var entity = LawYearEntity()
          ..id = 1
          ..year = 1;
        expect(entity == entity, true);
      });

      test('compare different instance', () {
        var entity = LawYearEntity()
          ..id = 1
          ..year = 1;
        var entity1 = LawYearEntity()
          ..id = 1
          ..year = 1;
        expect(entity == entity1, true);
      });

      test('failed different value', () {
        var entity = LawYearEntity()
          ..id = 1
          ..year = 1;
        var entity1 = LawYearEntity()
          ..id = 2
          ..year = 1;
        expect(entity == entity1, false);
      });
    });
  });
}
