// @dart=2.9

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_api.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';

void main() {
  FirebaseDatabase firebaseDatabase;
  FirebaseApi firebaseApi;

  MockFirebaseDatabase.instance.reference().set(firebaseDataCorrect);
  setUp(() {
    firebaseDatabase = MockFirebaseDatabase.instance;
    firebaseApi = FirebaseApi(firebaseDatabase);

    expect(firebaseDatabase, isNotNull);
    expect(firebaseApi, isNotNull);
  });

  test('test it should produce correct VersionEntity', () async {
    VersionEntity version = await firebaseApi.getVersion();

    expect(version, isNotNull);
  });
}

const firebaseDataCorrect = {
  'versions_new': {
    'v1': {
      '1603971592286': {
        'detail': {
          'filenames': [
            '1603971592286-1-1.json',
            '1603971592286-2-1.json',
            '1603971592286-3-1.json',
            '1603971592286-4-1.json',
            '1603971592286-5-1.json',
            '1603971592286-6-1.json'
          ]
        },
        'milis': 1603971592286,
        'timestamp': '2020-10-29 18:39:52'
      }
    }
  }
};
