import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );
  final List<MethodCall> log = <MethodCall>[];

  Directory directory = await Directory.systemTemp.createTemp();

  setUpAll(() async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getApplicationDocumentsDirectory':
          return '${directory.path}/app-doc-dir';
        case 'getTemporaryDirectory':
          return '${directory.path}/temp-dir';
        default:
          return null;
      }
    });
  });

  setUp(() {
    log.clear();
  });

  group('Path', () {
    test('return app-doc-dir', () async {
      var directory = await getApplicationDocumentsDirectory();
      expect(directory.path, contains('app-doc-dir'));
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getApplicationDocumentsDirectory',
            arguments: null,
          ),
        ],
      );
    });

    test('return temp-dir', () async {
      var directory = await getTemporaryDirectory();
      expect(directory.path, contains('temp-dir'));
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getTemporaryDirectory',
            arguments: null,
          ),
        ],
      );
    });

    Future<File> getFile(String path) async {
      return File(path);
    }

    Future<File> writeCounter(File file, int counter) async {
      return file.writeAsString('$counter');
    }

    Future<int> readCounter(File file) async {
      final contents = await file.readAsString();
      return int.parse(contents);
    }

    group('File', () {
      late String path;
      late Directory directory;
      late File file;
      setUpAll(() async {
        directory = await getApplicationDocumentsDirectory();
        path = '${directory.path}/file.json';
      });

      setUp(() async {
        file = await getFile(path);
        try {
          await file.delete(recursive: true);
        } on FileSystemException catch (e) {
          if (e.message != 'Deletion failed') {
            throw e;
          }
        }
      });

      test('cannot create file because not exist directory', () async {
        expect(await file.exists(), false);
        await expectLater(file.create(), throwsA(isA<FileSystemException>()));
      });

      test('create file because exists directory', () async {
        await directory.create();
        expect(await file.exists(), false);
        await file.create();
        expect(await file.exists(), true);
      });

      group('Operation', () {
        test('create file automatically while write', () async {
          expect(await file.exists(), false);
          await writeCounter(file, 1);
          expect(await file.exists(), true);
          expect(await readCounter(file), 1);
        });

        test('cannot create file automatically while read', () async {
          expect(await file.exists(), false);
          await expectLater(
              readCounter(file),
              throwsA(isA<FileSystemException>()
                  .having((e) => e.message, 'message', 'Cannot open file')));
        });
      });
    });
  });
}
