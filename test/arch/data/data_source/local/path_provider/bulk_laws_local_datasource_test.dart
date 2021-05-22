import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/bulk_laws_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/disk_path_provider.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BulkLawsLocalDatasource datasource;

  const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );

  Directory directory = await Directory.systemTemp.createTemp();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getApplicationDocumentsDirectory':
          return '${directory.path}/app-doc-dir';
        case 'getApplicationSupportDirectory':
          return '${directory.path}/app-sup-dir';
        case 'getTemporaryDirectory':
          return '${directory.path}/temp-dir';
        default:
          return null;
      }
    });
    datasource = DiskPathProvider();
  });

  group('$BulkLawsLocalDatasource', () {
    test('return app-doc-dir', () async {
      var id = '1';
      var names = ['1.json', '2.json', '3.json'];

      var filenames = await datasource.getBulkDiskReferences(id, names);
      expect(filenames, <Matcher>[
        isInstanceOf<File>()
            .having((e) => e.path, 'path', contains('/1/'))
            .having((e) => e.path, 'path', contains('/1.json')),
        isInstanceOf<File>()
            .having((e) => e.path, 'path', contains('/1/'))
            .having((e) => e.path, 'path', contains('/2.json')),
        isInstanceOf<File>()
            .having((e) => e.path, 'path', contains('/1/'))
            .having((e) => e.path, 'path', contains('/3.json')),
      ]);
    });
  });
}
