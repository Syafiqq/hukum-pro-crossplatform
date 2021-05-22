// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'library/mock.dart';

MockReferencePlatform mockReference = MockReferencePlatform();
MockListResultPlatform mockListResultPlatform = MockListResultPlatform();
MockUploadTaskPlatform mockUploadTaskPlatform = MockUploadTaskPlatform();
MockDownloadTaskPlatform mockDownloadTaskPlatform = MockDownloadTaskPlatform();

void main() {
  setupFirebaseStorageMocks();
  FirebaseStorage storage;

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
  });
}
