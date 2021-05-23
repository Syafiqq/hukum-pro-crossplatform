import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_cloud_database.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_menu_order_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';
import 'package:hukum_pro/common/exception/defined_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'law_menu_order_remote_datasource_test.mocks.dart';

void _initializeMethodChannel() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
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
}

@GenerateMocks([FirebaseDatabase, DatabaseReference, Query, DataSnapshot])
void main() {
  _initializeMethodChannel();
  late FirebaseApp app;

  setUpAll(() async {
    app = await Firebase.initializeApp(
      name: 'testApp',
      options: const FirebaseOptions(
        appId: '1:1234567890:ios:42424242424242',
        apiKey: '123',
        projectId: '123',
        messagingSenderId: '1234567890',
      ),
    );
  });

  group('$FirebaseDatabase', () {
    const MethodChannel channel = MethodChannel(
      'plugins.flutter.io/firebase_database',
    );
    int mockHandleId = 0;
    final List<MethodCall> log = <MethodCall>[];

    const String databaseURL = 'https://test.com';
    late FirebaseDatabase database;

    setUp(() async {
      database = FirebaseDatabase(app: app, databaseURL: databaseURL);

      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'Query#observe':
            return mockHandleId++;
          case 'FirebaseDatabase#setPersistenceEnabled':
            return true;
          case 'FirebaseDatabase#setPersistenceCacheSizeBytes':
            return true;
          case 'DatabaseReference#runTransaction':
            late Map<String, dynamic> updatedValue;
            Future<void> simulateEvent(
                int transactionKey, final MutableData mutableData) async {
              await ServicesBinding.instance?.defaultBinaryMessenger
                  ?.handlePlatformMessage(
                channel.name,
                channel.codec.encodeMethodCall(
                  MethodCall(
                    'DoTransaction',
                    <String, dynamic>{
                      'transactionKey': transactionKey,
                      'snapshot': <String, dynamic>{
                        'key': mutableData.key,
                        'value': mutableData.value,
                      },
                    },
                  ),
                ),
                (data) {
                  if (data == null) {
                    return;
                  }
                  updatedValue = channel.codec
                      .decodeEnvelope(data)['value']
                      .cast<String, dynamic>();
                },
              );
            }

            await simulateEvent(
                0,
                MutableData.private(<String, dynamic>{
                  'key': 'fakeKey',
                  'value': <String, dynamic>{'fakeKey': 'fakeValue'},
                }));

            return <String, dynamic>{
              'error': null,
              'committed': true,
              'snapshot': <String, dynamic>{
                'key': 'fakeKey',
                'value': updatedValue
              },
              'childKeys': ['fakeKey']
            };
          default:
            return null;
        }
      });
      log.clear();
    });

    Future<void> simulateEvent(
        int handle, String path, dynamic value, List<String> childKeys) async {
      await ServicesBinding.instance?.defaultBinaryMessenger
          ?.handlePlatformMessage(
              channel.name,
              channel.codec.encodeMethodCall(
                MethodCall('Event', <String, dynamic>{
                  'handle': handle,
                  'snapshot': <String, dynamic>{
                    'key': path,
                    'value': value,
                  },
                  'childKeys': childKeys
                }),
              ),
              (_) {});
    }

    Future<void> simulateError(int handle, String errorMessage) async {
      await ServicesBinding.instance?.defaultBinaryMessenger
          ?.handlePlatformMessage(
              channel.name,
              channel.codec.encodeMethodCall(
                MethodCall('Error', <String, dynamic>{
                  'handle': handle,
                  'error': <String, dynamic>{
                    'code': 0,
                    'message': errorMessage,
                    'details': 'details',
                  },
                }),
              ),
              (_) {});
    }

    group('$FirebaseCloudDatabase', () {
      late FirebaseCloudDatabase firebaseApi;

      setUp(() async {
        firebaseApi = FirebaseCloudDatabase(database);

        expect(firebaseApi, isNotNull);
      });

      test('return law menu', () async {
        var handleId = 87;
        mockHandleId = handleId;

        List<LawMenuOrderEntity>? entity;

        firebaseApi.getMenus().then((result) {
          entity = result;
        }).catchError((e) {});

        await Future<void>.delayed(Duration(seconds: 1));
        await simulateEvent(handleId, 'law_status_order', {
          '0': {'id': '1', 'order': 1, 'name': '1'},
          '1': {'id': '2', 'order': 2, 'name': '2'},
          '2': {'id': '3', 'order': 3, 'name': '3'},
          '3': {'id': '4', 'order': 4, 'name': '4'},
          '4': {'id': '5', 'order': 5, 'name': '5'},
        }, [
          '0',
          '1',
          '2',
          '3',
          '4'
        ]);

        expect(entity, isNotNull);
        expect(entity?.length, 5);
        expect(entity, <Matcher>[
          isA<LawMenuOrderEntity>()
              .having((e) => e.order, 'order', 1)
              .having((e) => e.id, 'id', '1')
              .having((e) => e.name, 'name', '1'),
          isA<LawMenuOrderEntity>()
              .having((e) => e.order, 'order', 2)
              .having((e) => e.id, 'id', '2')
              .having((e) => e.name, 'name', '2'),
          isA<LawMenuOrderEntity>()
              .having((e) => e.order, 'order', 3)
              .having((e) => e.id, 'id', '3')
              .having((e) => e.name, 'name', '3'),
          isA<LawMenuOrderEntity>()
              .having((e) => e.order, 'order', 4)
              .having((e) => e.id, 'id', '4')
              .having((e) => e.name, 'name', '4'),
          isA<LawMenuOrderEntity>()
              .having((e) => e.order, 'order', 5)
              .having((e) => e.id, 'id', '5')
              .having((e) => e.name, 'name', '5'),
        ]);
      });

      test('return empty if not found', () async {
        var handleId = 87;
        mockHandleId = handleId;

        List<LawMenuOrderEntity>? entity;

        firebaseApi.getMenus().then((result) {
          entity = result;
        }).catchError((e) {});

        await Future<void>.delayed(Duration(seconds: 1));
        await simulateEvent(handleId, '', {}, []);

        expect(entity, isNotNull);
        expect(entity?.length, 0);
      });

      test('throws not exist error', () async {
        var handleId = 87;
        mockHandleId = handleId;

        var firebaseDatabase = MockFirebaseDatabase();
        var databaseReference = MockDatabaseReference();
        var databaseQuery = MockQuery();
        var dataSnapshot = MockDataSnapshot();
        when(firebaseDatabase.reference()).thenAnswer((_) => databaseReference);
        when(databaseReference.child(any)).thenAnswer((_) => databaseReference);
        when(databaseReference.orderByKey()).thenAnswer((_) => databaseQuery);
        when(databaseQuery.once()).thenAnswer((_) async => dataSnapshot);
        when(dataSnapshot.value).thenAnswer((_) => null);

        var firebaseApi = FirebaseCloudDatabase(firebaseDatabase);

        Exception? exception;

        firebaseApi.getMenus().then((result) {}).catchError((e) {
          exception = e as Exception;
        });
        await Future<void>.delayed(Duration(seconds: 1));
        await simulateEvent(handleId, 'a', {}, []);

        expect(exception, isNotNull);
        expect(exception, isA<DataNotExistsException>());
      });

      test('throw type error', () async {
        var handleId = 87;
        mockHandleId = handleId;

        Exception? exception;

        firebaseApi.getMenus().then((_) {}).catchError((e) {
          exception = e as Exception?;
        });

        await Future<void>.delayed(Duration(seconds: 1));
        await simulateEvent(handleId, 'law_status_order', {
          '0': {},
        }, [
          '0',
        ]);

        expect(exception, isNotNull);
        expect(
            exception,
            isA<ParseFailedException>().having(
                (e) => e.internalError,
                'internalError',
                isA<TypeError>().having((e) => e.toString(), 'toString',
                    "type 'Null' is not a subtype of type 'String' in type cast")));
      });

      test('throws parse failed error', () async {
        var handleId = 87;
        mockHandleId = handleId;

        Exception? exception;

        firebaseApi.getMenus().then((result) {}).catchError((e) {
          exception = e as Exception?;
        });
        await Future<void>.delayed(Duration(seconds: 1));
        await simulateEvent(handleId, 'law_status_order', {
          '0': {'id': '1', 'order': '1', 'name': '1'},
        }, [
          '0',
        ]);

        expect(exception, isNotNull);
        expect(exception, isA<ParseFailedException>());
      });

      test('throws fetch failed due to firebase error', () async {
        var firebaseDatabase = MockFirebaseDatabase();
        when(firebaseDatabase.reference())
            .thenThrow(FirebaseException(plugin: '0'));
        var firebaseApi = FirebaseCloudDatabase(firebaseDatabase);

        expect(
            () async => await firebaseApi.getMenus(),
            throwsA(isInstanceOf<DataFetchFailureException>().having(
                (e) => e.internalException,
                'internalException',
                isInstanceOf<FirebaseException>()
                    .having((e) => e.plugin, 'plugin', '0'))));
      });

      test('throws fetch failed due to database error', () async {
        var handleId = 99;
        mockHandleId = handleId;

        Exception? exception;

        firebaseApi.getMenus().then((result) {}).catchError((e) {
          exception = e as Exception;
        });
        await Future<void>.delayed(Duration(seconds: 1));
        await simulateError(handleId, '0');

        expect(exception, isNotNull);
        expect(
            exception,
            isA<DataFetchFailureException>().having(
                (e) => e.internalException,
                'internalException',
                isInstanceOf<DefinedException>()
                    .having((e) => e.message, 'message', '0')));
      });
    });
  });
}
