import 'package:mockito/mockito.dart' as _i1;
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart' as _i2;
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart'
    as _i3;
import 'dart:async' as _i4;
import 'package:hukum_pro/arch/data/data_source/local/cache/contract/version_cache_datasource.dart'
    as _i5;

class _FakeVersionEntity extends _i1.Fake implements _i2.VersionEntity {}

/// A class which mocks [VersionRemoteDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockVersionRemoteDatasource extends _i1.Mock
    implements _i3.VersionRemoteDatasource {
  MockVersionRemoteDatasource() {
    _i1.throwOnMissingStub(this);
  }

  _i4.Future<_i2.VersionEntity> getVersion() => super.noSuchMethod(
      Invocation.method(#getVersion, []), Future.value(_FakeVersionEntity()));
}

/// A class which mocks [VersionCacheDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockVersionCacheDatasource extends _i1.Mock
    implements _i5.VersionCacheDatasource {
  MockVersionCacheDatasource() {
    _i1.throwOnMissingStub(this);
  }

  _i4.Future<_i2.VersionEntity?> getVersion() => super.noSuchMethod(
      Invocation.method(#getVersion, []), Future.value(_FakeVersionEntity()));
  _i4.Future<void> setVersion(_i2.VersionEntity? version) => super.noSuchMethod(
      Invocation.method(#setVersion, [version]), Future.value(null));
}
