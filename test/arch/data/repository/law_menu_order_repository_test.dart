import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_menu_order_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/law_menu_order_remote_datasource.dart';
import 'package:hukum_pro/arch/data/repository/law_menu_order_repository_impl.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/arch/domain/repository/version_repository.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'law_menu_order_repository_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<LawMenuOrderRemoteDatasource>(
      as: #BaseMockLawMenuOrderRemoteDatasource, returnNullOnMissingStub: true),
  MockSpec<LawMenuOrderLocalDatasource>(
      as: #BaseMockLawMenuOrderLocalDatasource, returnNullOnMissingStub: true),
])
void main() {
  group('$VersionRepository', () {
    late BaseMockLawMenuOrderRemoteDatasource mockLawMenuOrderRemoteDatasource;
    late BaseMockLawMenuOrderLocalDatasource mockLawMenuOrderLocalDatasource;
    late LawMenuOrderRepositoryImpl repository;

    setUp(() {
      mockLawMenuOrderRemoteDatasource = BaseMockLawMenuOrderRemoteDatasource();
      mockLawMenuOrderLocalDatasource = BaseMockLawMenuOrderLocalDatasource();
      repository = LawMenuOrderRepositoryImpl(
          mockLawMenuOrderRemoteDatasource, mockLawMenuOrderLocalDatasource);
    });

    group('fetchFromRemote', () {
      test('success get menus', () async {
        when(mockLawMenuOrderRemoteDatasource.getMenus())
            .thenAnswer((_) async => [LawMenuOrderEntity('1', '1', 1)]);

        var entity = await repository.fetchFromRemote();
        expect(entity.length, 1);
        expect(entity.first.id, '1');
        expect(entity.first.name, '1');
        expect(entity.first.order, 1);
        verify(mockLawMenuOrderRemoteDatasource.getMenus()).called(1);
      });

      test('throw parse failed exception', () async {
        when(mockLawMenuOrderRemoteDatasource.getMenus()).thenAnswer(
            (_) => Future.error(ParseFailedException(Iterable, null, null)));

        await expectLater(
            repository.fetchFromRemote(),
            throwsA(isA<ParseFailedException>()
                .having((e) => e.message, 'message', contains('Iterable'))));

        verify(mockLawMenuOrderRemoteDatasource.getMenus()).called(1);
      });

      test('throw data fetch failure exception', () async {
        when(mockLawMenuOrderRemoteDatasource.getMenus()).thenAnswer(
            (_) => Future.error(DataFetchFailureException(null, null)));

        await expectLater(
            repository.fetchFromRemote(),
            throwsA(isA<DataFetchFailureException>()
                .having((e) => e.internalError, 'internalError', isNull)));

        verify(mockLawMenuOrderRemoteDatasource.getMenus()).called(1);
      });
    });

    group('fetchFromLocal', () {
      test('success get menus', () async {
        when(mockLawMenuOrderLocalDatasource.getMenusOrEmpty())
            .thenAnswer((_) async => [LawMenuOrderEntity('1', '1', 1)]);

        var entity = await repository.fetchFromLocal();
        expect(entity.length, 1);
        expect(entity.first.id, '1');
        expect(entity.first.name, '1');
        expect(entity.first.order, 1);
        verify(mockLawMenuOrderLocalDatasource.getMenusOrEmpty()).called(1);
      });

      test('throw parse failed exception', () async {
        when(mockLawMenuOrderLocalDatasource.getMenusOrEmpty()).thenAnswer(
            (_) => Future.error(ParseFailedException(Iterable, null, null)));

        await expectLater(
            repository.fetchFromLocal(),
            throwsA(isA<ParseFailedException>()
                .having((e) => e.message, 'message', contains('Iterable'))));

        verify(mockLawMenuOrderLocalDatasource.getMenusOrEmpty()).called(1);
      });
    });

    group('saveToLocal', () {
      test('set menus', () async {
        var entity = [LawMenuOrderEntity('1', null, null)];
        when(mockLawMenuOrderLocalDatasource.setMenus(any))
            .thenAnswer((_) => Future.value(null));

        await repository.saveToLocal(entity);

        expect(
            verify(mockLawMenuOrderLocalDatasource.setMenus(captureAny))
                .captured,
            [
              [isA<LawMenuOrderEntity>().having((e) => e.id, 'id', '1')]
            ]);
      });
    });
  });
}
