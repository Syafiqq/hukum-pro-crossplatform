import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_api.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/common/exception/built_in.dart';

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
                  .handlePlatformMessage(
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
          .handlePlatformMessage(
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

    group('$FirebaseApi', () {
      late FirebaseApi firebaseApi;

      setUp(() async {
        firebaseApi = FirebaseApi(database);

        expect(firebaseApi, isNotNull);
      });

      test('retrieve version', () async {
        var handleId = 87;
        mockHandleId = handleId;

        VersionEntity? entity;

        firebaseApi.getVersion().then((result) {
          entity = result;
        }).catchError((e) {});

        await Future<void>.delayed(Duration(seconds: 1));
        await simulateEvent(handleId, 'versions_new/v1', {
          '1': {'detail': {}, 'milis': 0, 'timestamp': ''}
        }, [
          '1'
        ]);

        expect(entity, isNotNull);
        expect(entity, isA<VersionEntity>());

        expect(entity?.detail, isNotNull);
        expect(entity?.milis, 0);
        expect(entity?.timestamp, '');
      });

      test('retrieve not exist error ', () async {
        var handleId = 87;
        mockHandleId = handleId;

        Exception? exception;

        firebaseApi.getVersion().then((result) {}).catchError((e) {
          exception = e as Exception?;
        });
        await Future<void>.delayed(Duration(seconds: 1));
        await simulateEvent(handleId, '', {}, []);

        expect(exception, isNotNull);
        expect(exception, isA<DataNotExistsException>());
      });

      test('retrieve parse failed error ', () async {
        var handleId = 87;
        mockHandleId = handleId;

        Exception? exception;

        firebaseApi.getVersion().then((result) {}).catchError((e) {
          exception = e as Exception?;
        });
        await Future<void>.delayed(Duration(seconds: 1));
        await simulateEvent(handleId, 'versions_new/v1', {
          '1': {'detail': 1, 'milis': 2, 'timestamp': 3}
        }, [
          '1'
        ]);

        expect(exception, isNotNull);
        expect(exception, isA<ParseFailedException>());
      });
    });
  });
}
