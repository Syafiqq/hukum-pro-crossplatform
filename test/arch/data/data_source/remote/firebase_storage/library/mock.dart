// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

typedef Callback = Function(MethodCall call);

const String kTestString = 'Hello World';
const String kBucket = 'gs://fake-storage-bucket-url.com';
const String kSecondaryBucket = 'gs://fake-storage-bucket-url-2.com';

const String testString = 'Hello World';
const String testBucket = 'test-bucket';

const String testName = 'bar';
const String testFullPath = 'foo/$testName';

const String testToken = 'mock-token';
const String testParent = 'test-parent';
const String testDownloadUrl = 'test-download-url';
const Map<String, dynamic> testMetadataMap = <String, dynamic>{
  'contentType': 'gif'
};
const int testMaxResults = 1;
const String testPageToken = 'test-page-token';

final MockFirebaseStorage kMockStoragePlatform = MockFirebaseStorage();

void setupFirebaseStorageMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
            'storageBucket': kBucket
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    return null;
  });

  // Mock Platform Interface Methods
  when(kMockStoragePlatform.delegateFor(
          app: anyNamed('app'), bucket: anyNamed('bucket')))
      .thenReturn(kMockStoragePlatform);
}

// Platform Interface Mock Classes

// FirebaseStoragePlatform Mock
class MockFirebaseStorage extends Mock
    with
        // ignore: prefer_mixin, plugin_platform_interface needs to migrate to use `mixin`
        MockPlatformInterfaceMixin
    implements
        TestFirebaseStoragePlatform {
  MockFirebaseStorage() {
    TestFirebaseStoragePlatform();
  }

  @override
  final int maxOperationRetryTime = 0;
  @override
  final int maxDownloadRetryTime = 0;
  @override
  final int maxUploadRetryTime = 0;

  @override
  FirebaseStoragePlatform delegateFor({FirebaseApp app, String bucket}) {
    return super.noSuchMethod(
        Invocation.method(#delegateFor, [], {#app: app, #bucket: bucket}),
        TestFirebaseStoragePlatform());
  }

  @override
  ReferencePlatform ref(String path) {
    return super.noSuchMethod(Invocation.method(#ref, [path]),
        TestReferencePlatform());
  }

  @override
  Future<void> useEmulator(String host, int port) async {
    return super.noSuchMethod(Invocation.method(#useEmulator, [host, port]));
  }
}

class TestFirebaseStoragePlatform extends FirebaseStoragePlatform {
  TestFirebaseStoragePlatform() : super(bucket: testBucket);

  @override
  FirebaseStoragePlatform delegateFor({FirebaseApp app, String bucket}) {
    return this;
  }
}

// ReferencePlatform Mock
class TestReferencePlatform extends ReferencePlatform {
  TestReferencePlatform() : super(TestFirebaseStoragePlatform(), testFullPath);
// @override
}

// ReferencePlatform Mock
class MockReferencePlatform extends Mock
    with
        // ignore: prefer_mixin, plugin_platform_interface needs to migrate to use `mixin`
        MockPlatformInterfaceMixin
    implements
        ReferencePlatform {
  @override
  Future<ListResultPlatform> list([ListOptions options]) {
    return super.noSuchMethod(Invocation.method(#list, [options]),
        neverEndingFuture<ListResultPlatform>());
  }

  @override
  TaskPlatform putData(Uint8List data, [SettableMetadata metadata]) {
    return super.noSuchMethod(Invocation.method(#putData, [data, metadata]),
        TestUploadTaskPlatform());
  }

  @override
  TaskPlatform putFile(File file, [SettableMetadata metadata]) {
    return super.noSuchMethod(Invocation.method(#putFile, [file, metadata]),
        TestUploadTaskPlatform());
  }

  @override
  Future<FullMetadata> updateMetadata(SettableMetadata metadata) {
    return super.noSuchMethod(Invocation.method(#updateMetadata, [metadata]),
        neverEndingFuture<FullMetadata>());
  }

  @override
  String get bucket {
    return super.noSuchMethod(Invocation.getter(#bucket),
        testBucket);
  }

  @override
  String get fullPath {
    return super.noSuchMethod(Invocation.getter(#fullPath),
        testFullPath);
  }

  @override
  String get name {
    return super.noSuchMethod(Invocation.getter(#name),
        testName);
  }

  @override
  ReferencePlatform get parent {
    return super.noSuchMethod(Invocation.getter(#parent),
        TestListResultPlatform());
  }

  @override
  TaskPlatform putBlob(dynamic data, [SettableMetadata metadata]) {
    return super.noSuchMethod(Invocation.method(#putBlob, [data, metadata]),
        TestUploadTaskPlatform());
  }

  @override
  TaskPlatform writeToFile(File file) {
    return super.noSuchMethod(Invocation.method(#writeToFile, [file]),
        TestUploadTaskPlatform());
  }

  @override
  ReferencePlatform get root {
    return super.noSuchMethod(Invocation.getter(#root),
        TestReferencePlatform());
  }

  @override
  ReferencePlatform child(String path) {
    return super.noSuchMethod(Invocation.method(#child, [], {#path: path}),
        TestReferencePlatform());
  }

  @override
  Future<void> delete() {
    return super.noSuchMethod(Invocation.method(#delete, []),
        neverEndingFuture<void>());
  }

  @override
  TaskPlatform putString(String data, PutStringFormat format,
      [SettableMetadata metadata]) {
    return super.noSuchMethod(
        Invocation.method(#child, [data, format, metadata]),
        TestUploadTaskPlatform());
  }

  @override
  Future<String> getDownloadURL() {
    return super.noSuchMethod(Invocation.method(#getDownloadURL, []),
        neverEndingFuture<String>());
  }

  @override
  Future<FullMetadata> getMetadata() {
    return super.noSuchMethod(Invocation.method(#getMetadata, []),
        neverEndingFuture<FullMetadata>());
  }

  @override
  Future<ListResultPlatform> listAll() {
    return super.noSuchMethod(Invocation.method(#listAll, []),
        neverEndingFuture<ListResultPlatform>());
  }
}

// UploadTaskPlatform Mock
class MockUploadTaskPlatform extends Mock
    with
        // ignore: prefer_mixin, plugin_platform_interface needs to migrate to use `mixin`
        MockPlatformInterfaceMixin
    implements
        TaskPlatform {
  @override
  TaskSnapshotPlatform get snapshot {
    return super.noSuchMethod(Invocation.getter(#snapshot),
        TestTaskSnapshotPlatform());
  }

  @override
  Stream<TaskSnapshotPlatform> get snapshotEvents {
    return super.noSuchMethod(Invocation.getter(#snapshotEvents),
        const Stream<TaskSnapshotPlatform>.empty());
  }

  @override
  Future<TaskSnapshotPlatform> get onComplete {
    return super.noSuchMethod(Invocation.getter(#onComplete),
        neverEndingFuture<TaskSnapshotPlatform>());
  }

  @override
  Future<bool> pause() {
    return super.noSuchMethod(Invocation.method(#pause, []),
        Future.value(false));
  }

  @override
  Future<bool> resume() {
    return super.noSuchMethod(Invocation.method(#resume, []),
        Future.value(false));
  }

  @override
  Future<bool> cancel() {
    return super.noSuchMethod(Invocation.method(#cancel, []),
        Future.value(false));
  }
}

class TestListResultPlatform extends ReferencePlatform {
  TestListResultPlatform() : super(TestFirebaseStoragePlatform(), testFullPath);
}

class TestTaskSnapshotPlatform extends TaskSnapshotPlatform {
  TestTaskSnapshotPlatform() : super(TaskState.running, {});
}

// ListResultPlatform Mock
class MockListResultPlatform extends Mock
    with
        // ignore: prefer_mixin, plugin_platform_interface needs to migrate to use `mixin`
        MockPlatformInterfaceMixin
    implements
        ListResultPlatform {
  @override
  List<ReferencePlatform> get items {
    return super.noSuchMethod(Invocation.getter(#items),
        <ReferencePlatform>[]);
  }

  @override
  String get nextPageToken {
    return super.noSuchMethod(Invocation.getter(#nextPageToken),
        testToken);
  }

  @override
  List<ReferencePlatform> get prefixes {
    return super.noSuchMethod(Invocation.getter(#prefixes),
        <ReferencePlatform>[]);
  }
}

class TestUploadTaskPlatform extends TaskPlatform {
  TestUploadTaskPlatform() : super();
}

// DownloadTaskPlatform Mock
class MockDownloadTaskPlatform extends Mock
    with
        // ignore: prefer_mixin, plugin_platform_interface needs to migrate to use `mixin`
        MockPlatformInterfaceMixin
    implements
        TaskPlatform {}

// TaskSnapshotPlatform Mock
class MockTaskSnapshotPlatform extends Mock
    with
        // ignore: prefer_mixin, plugin_platform_interface needs to migrate to use `mixin`
        MockPlatformInterfaceMixin
    implements
        TaskSnapshotPlatform {
  @override
  int get bytesTransferred {
    return super.noSuchMethod(Invocation.getter(#bytesTransferred),
        0);
  }

  @override
  int get totalBytes {
    return super.noSuchMethod(Invocation.getter(#totalBytes),
        0);
  }

  @override
  ReferencePlatform get ref {
    return super.noSuchMethod(Invocation.getter(#ref),
        TestReferencePlatform());
  }

  @override
  TaskState get state {
    return super.noSuchMethod(Invocation.getter(#state),
        TaskState.running);
  }
}

// Creates a test file with a specified name to
// a locally directory
Future<File> createFile(String name) async {
  final Directory systemTempDir = Directory.systemTemp;
  final File file = await File('${systemTempDir.path}/$name').create();
  await file.writeAsString(kTestString);
  return file;
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}