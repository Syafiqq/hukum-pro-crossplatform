// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/bulk_laws_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_cloud_storage.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:mockito/mockito.dart';

import 'library/mock.dart';

MockReferencePlatform mockReference = MockReferencePlatform();
MockListResultPlatform mockListResultPlatform = MockListResultPlatform();
MockUploadTaskPlatform mockUploadTaskPlatform = MockUploadTaskPlatform();
MockDownloadTaskPlatform mockDownloadTaskPlatform = MockDownloadTaskPlatform();
MockTaskSnapshotPlatform mockTaskSnapshotPlatform = MockTaskSnapshotPlatform();

void main() {
  setupFirebaseStorageMocks();
  late Directory directory;

  late FirebaseStorage storage;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp();
  });

  group('$Reference', () {
    setUpAll(() async {
      FirebaseStoragePlatform.instance = kMockStoragePlatform;

      await Firebase.initializeApp();
      storage = FirebaseStorage.instance;

      when(kMockStoragePlatform.ref(any)).thenReturn(mockReference);
    });

    group('writeToFile()', () {
      test('verify delegate method is called', () async {
        var testFile = await createFile('foo.txt');
        var testRef = storage.ref();

        when(mockReference.writeToFile(testFile))
            .thenReturn(mockDownloadTaskPlatform);

        final result = testRef.writeToFile(testFile);

        expect(result, isA<Task>());

        verify(mockReference.writeToFile(testFile));
      });
    });

    group('$BulkLawsRemoteDatasource', () {
      late BulkLawsRemoteDatasource datasource;
      late File file;

      setUp(() async {
        datasource = FirebaseCloudStorage(storage);
        file = File('${directory.path}/test.json');
        await file.deleteIfExists();
      });

      test('success download file', () async {
        when(mockReference.writeToFile(file))
            .thenReturn(mockDownloadTaskPlatform);
        when(mockDownloadTaskPlatform.snapshot)
            .thenReturn(mockTaskSnapshotPlatform);
        when(mockDownloadTaskPlatform.onComplete).thenAnswer((_) async {
          await file.create();
          return mockTaskSnapshotPlatform;
        });

        expect(await file.exists(), false);

        await datasource.downloadBulkLaws('a', file);

        expect(await file.exists(), true);
        verify(mockReference.writeToFile(file));
      });

      test('throw firebase exception', () async {
        when(mockReference.writeToFile(file))
            .thenReturn(mockDownloadTaskPlatform);
        when(mockDownloadTaskPlatform.snapshot)
            .thenReturn(mockTaskSnapshotPlatform);
        when(mockDownloadTaskPlatform.onComplete).thenAnswer((_) async {
          throw FirebaseException(plugin: '0');
        });

        expect(
            () async => await datasource.downloadBulkLaws('a', file),
            throwsA(isInstanceOf<DataFetchFailureException>().having(
                (e) => e.internalException,
                'internalException',
                isInstanceOf<FirebaseException>()
                    .having((e) => e.plugin, 'plugin', '0'))));
      });

      test('throw file system exception', () async {
        when(mockReference.writeToFile(file))
            .thenReturn(mockDownloadTaskPlatform);
        when(mockDownloadTaskPlatform.snapshot)
            .thenReturn(mockTaskSnapshotPlatform);
        when(mockDownloadTaskPlatform.onComplete).thenAnswer((_) async {
          throw FileSystemException('0');
        });

        expect(
            () async => await datasource.downloadBulkLaws('a', file),
            throwsA(isInstanceOf<DataFetchFailureException>().having(
                (e) => e.internalException,
                'internalException',
                isInstanceOf<FileSystemException>()
                    .having((e) => e.message, 'message', '0'))));
      });
    });
  });
}

extension FileRemoval on File {
  Future<void> deleteIfExists() async {
    try {
      await this.delete();
    } on FileSystemException {}
  }
}
