import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/entity/law_entity.dart';

void main() {
  group('$LawEntity', () {
    group('$Equatable', () {
      test('compare same instance', () {
        var entity = LawEntity()
          ..id = 1
          ..remoteId = '1';
        expect(entity == entity, true);
      });

      test('compare different instance', () {
        var entity = LawEntity()
          ..id = 1
          ..remoteId = '1';
        var entity1 = LawEntity()
          ..id = 1
          ..remoteId = '1';
        expect(entity == entity1, true);
      });

      test('failed different value', () {
        var entity = LawEntity()
          ..id = 1
          ..remoteId = '1';
        var entity1 = LawEntity()
          ..id = 2
          ..remoteId = '1';
        expect(entity == entity1, false);
      });
    });
  });
}
