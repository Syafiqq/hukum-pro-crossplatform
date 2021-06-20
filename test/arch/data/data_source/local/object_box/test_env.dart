import 'dart:io';

import 'package:test/test.dart';

import 'package:hukum_pro/objectbox.g.dart';

class TestEnv {
  final Directory dir;
  final Store store;

  factory TestEnv(String name, {bool? queryCaseSensitive}) {
    final dir = Directory('testdata-' + name);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    final store = queryCaseSensitive == null
        ? Store(getObjectBoxModel(), directory: dir.path)
        : Store(getObjectBoxModel(),
            directory: dir.path,
            queriesCaseSensitiveDefault: queryCaseSensitive);
    return TestEnv._(dir, store);
  }

  TestEnv._(this.dir, this.store);

  void close() {
    store.close();
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }
}

const defaultTimeout = Duration(milliseconds: 1000);

/// "Busy-waits" until the predicate returns true.
bool waitUntil(bool Function() predicate, {Duration timeout = defaultTimeout}) {
  var success = false;
  final until = DateTime.now().add(timeout);

  while (!(success = predicate()) && until.isAfter(DateTime.now())) {
    sleep(const Duration(milliseconds: 1));
  }
  return success;
}

/// same as package:test unorderedEquals() but statically typed
Matcher sameAsList<T>(List<T> list) => unorderedEquals(list);

// Yield execution to other isolates.
//
// We need to do this to receive an event in the stream before processing
// the remainder of the test case.
final yieldExecution = () async => await Future<void>.delayed(Duration.zero);