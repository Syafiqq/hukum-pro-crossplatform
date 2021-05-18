import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_api.dart';

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

    Future<void> simulateEvent(int handle, String path, dynamic value) async {
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
                }),
              ),
              (_) {});
    }

    group('$Query', () {
      test('read data once', () async {
        var handleId = 87;
        mockHandleId = handleId;

        const String path = 'foo';
        final Query query = database.reference().child(path);

        Future<DataSnapshot> futureSnapshot = query.once();
        await Future<void>.delayed(const Duration(seconds: 1));
        await simulateEvent(handleId, path, '1');
        DataSnapshot snapshot = await futureSnapshot;

        expect(snapshot.key, path);
        expect(snapshot.value, '1');

        expect(
          log,
          <Matcher>[
            isMethodCall(
              'Query#observe',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': path,
                'parameters': <String, dynamic>{},
                'eventType': '_EventType.value',
              },
            ),
            isMethodCall(
              'Query#removeObserver',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': path,
                'parameters': <String, dynamic>{},
                'handle': 87,
              },
            ),
          ],
        );
      });
    });

    group('$FirebaseApi', () {
      late FirebaseApi firebaseApi;

      setUp(() async {
        firebaseApi = FirebaseApi(database);

        expect(firebaseApi, isNotNull);
      });

      test('it should successfully retrieve version', () async {
        var handleId = 87;
        mockHandleId = handleId;

        const String path = 'versions_new/v1';

        var futureSnapshot = firebaseApi.getVersion();
        await Future<void>.delayed(const Duration(seconds: 1));

        await simulateEvent(handleId, path, {
          '1603971592286': {
            'detail': {
              'filenames': [
                '1603971592286-1-1.json',
              ]
            },
            'milis': 1603971592286,
            'timestamp': '2020-10-29 18:39:52'
          }
        });

        var snapshot = await futureSnapshot;
        expect(snapshot, isNotNull);
      });
    });
  });
}
