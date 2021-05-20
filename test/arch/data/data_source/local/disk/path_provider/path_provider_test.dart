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
          return '${directory.path}/app-doc-dir/';
        case 'getTemporaryDirectory':
          return '${directory.path}/temp-dir/';
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
  });
}
