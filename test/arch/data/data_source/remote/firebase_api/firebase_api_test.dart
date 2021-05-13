// Copyright 2020, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

void initializeMethodChannel() {
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
  initializeMethodChannel();
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

    const String databaseURL = 'https://fake-database-url2.firebaseio.com';
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
              await ServicesBinding.instance!.defaultBinaryMessenger
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
                  updatedValue = channel.codec
                      .decodeEnvelope(data!)['value']
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

    test('setPersistenceEnabled', () async {
      expect(await database.setPersistenceEnabled(false), true);
      expect(await database.setPersistenceEnabled(true), true);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'FirebaseDatabase#setPersistenceEnabled',
            arguments: <String, dynamic>{
              'app': app.name,
              'databaseURL': databaseURL,
              'enabled': false,
            },
          ),
          isMethodCall(
            'FirebaseDatabase#setPersistenceEnabled',
            arguments: <String, dynamic>{
              'app': app.name,
              'databaseURL': databaseURL,
              'enabled': true,
            },
          ),
        ],
      );
    });

    test('setPersistentCacheSizeBytes', () async {
      expect(await database.setPersistenceCacheSizeBytes(42), true);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'FirebaseDatabase#setPersistenceCacheSizeBytes',
            arguments: <String, dynamic>{
              'app': app.name,
              'databaseURL': databaseURL,
              'cacheSize': 42,
            },
          ),
        ],
      );
    });

    test('goOnline', () async {
      await database.goOnline();
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'FirebaseDatabase#goOnline',
            arguments: <String, dynamic>{
              'app': app.name,
              'databaseURL': databaseURL,
            },
          ),
        ],
      );
    });

    test('goOffline', () async {
      await database.goOffline();
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'FirebaseDatabase#goOffline',
            arguments: <String, dynamic>{
              'app': app.name,
              'databaseURL': databaseURL,
            },
          ),
        ],
      );
    });

    test('purgeOutstandingWrites', () async {
      await database.purgeOutstandingWrites();
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'FirebaseDatabase#purgeOutstandingWrites',
            arguments: <String, dynamic>{
              'app': app.name,
              'databaseURL': databaseURL,
            },
          ),
        ],
      );
    });

    group('$DatabaseReference', () {
      test('set', () async {
        final dynamic value = <String, dynamic>{'hello': 'world'};
        final dynamic serverValue = <String, dynamic>{
          'qux': ServerValue.increment(8)
        };
        const int priority = 42;
        await database.reference().child('foo').set(value);
        await database.reference().child('bar').set(value, priority: priority);
        await database.reference().child('baz').set(serverValue);
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'DatabaseReference#set',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'foo',
                'value': value,
                'priority': null,
              },
            ),
            isMethodCall(
              'DatabaseReference#set',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'bar',
                'value': value,
                'priority': priority,
              },
            ),
            isMethodCall(
              'DatabaseReference#set',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'baz',
                'value': {
                  'qux': {
                    '.sv': {'increment': 8}
                  }
                },
                'priority': null,
              },
            ),
          ],
        );
      });
      test('update', () async {
        final dynamic value = <String, dynamic>{'hello': 'world'};
        await database.reference().child('foo').update(value);
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'DatabaseReference#update',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'foo',
                'value': value,
              },
            ),
          ],
        );
      });

      test('setPriority', () async {
        const int priority = 42;
        await database.reference().child('foo').setPriority(priority);
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'DatabaseReference#setPriority',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'foo',
                'priority': priority,
              },
            ),
          ],
        );
      });

      test('runTransaction', () async {
        final TransactionResult transactionResult = await database
            .reference()
            .child('foo')
            .runTransaction((MutableData mutableData) {
          mutableData.value['fakeKey'] =
              'updated ${mutableData.value['fakeKey']}';
          return Future.value(mutableData);
        });
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'DatabaseReference#runTransaction',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'foo',
                'transactionKey': 0,
                'transactionTimeout': 5000,
              },
            ),
          ],
        );
        expect(transactionResult.committed, equals(true));
        expect(
          transactionResult.dataSnapshot!.value,
          equals(<String, dynamic>{'fakeKey': 'updated fakeValue'}),
        );
      });
    });

    group('$OnDisconnect', () {
      test('set', () async {
        final dynamic value = <String, dynamic>{'hello': 'world'};
        const int priority = 42;
        final DatabaseReference ref = database.reference();
        await ref.child('foo').onDisconnect().set(value);
        await ref.child('bar').onDisconnect().set(value, priority: priority);
        await ref.child('psi').onDisconnect().set(value, priority: 'priority');
        await ref.child('por').onDisconnect().set(value, priority: value);
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'OnDisconnect#set',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'foo',
                'value': value,
                'priority': null,
              },
            ),
            isMethodCall(
              'OnDisconnect#set',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'bar',
                'value': value,
                'priority': priority,
              },
            ),
            isMethodCall(
              'OnDisconnect#set',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'psi',
                'value': value,
                'priority': 'priority',
              },
            ),
            isMethodCall(
              'OnDisconnect#set',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'por',
                'value': value,
                'priority': value,
              },
            ),
          ],
        );
      });
      test('update', () async {
        final dynamic value = <String, dynamic>{'hello': 'world'};
        await database.reference().child('foo').onDisconnect().update(value);
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'OnDisconnect#update',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'foo',
                'value': value,
              },
            ),
          ],
        );
      });
      test('cancel', () async {
        await database.reference().child('foo').onDisconnect().cancel();
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'OnDisconnect#cancel',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'foo',
              },
            ),
          ],
        );
      });
      test('remove', () async {
        await database.reference().child('foo').onDisconnect().remove();
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'OnDisconnect#set',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': 'foo',
                'value': null,
                'priority': null,
              },
            ),
          ],
        );
      });
    });

    group('$Query', () {
      test('keepSynced, simple query', () async {
        const String path = 'foo';
        final Query query = database.reference().child(path);
        await query.keepSynced(true);
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'Query#keepSynced',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': path,
                'parameters': <String, dynamic>{},
                'value': true,
              },
            ),
          ],
        );
      });
      test('keepSynced, complex query', () async {
        const int startAt = 42;
        const String path = 'foo';
        const String childKey = 'bar';
        const bool endAt = true;
        const String endAtKey = 'baz';
        final Query query = database
            .reference()
            .child(path)
            .orderByChild(childKey)
            .startAt(startAt)
            .endAt(endAt, key: endAtKey);
        await query.keepSynced(false);
        final Map<String, dynamic> expectedParameters = <String, dynamic>{
          'orderBy': 'child',
          'orderByChildKey': childKey,
          'startAt': startAt,
          'endAt': endAt,
          'endAtKey': endAtKey,
        };
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'Query#keepSynced',
              arguments: <String, dynamic>{
                'app': app.name,
                'databaseURL': databaseURL,
                'path': path,
                'parameters': expectedParameters,
                'value': false
              },
            ),
          ],
        );
      });
      test('observing error events', () async {
        mockHandleId = 99;
        const int errorCode = 12;
        const String errorDetails = 'Some details';
        final Query query = database.reference().child('some path');
        Future<void> simulateError(String errorMessage) async {
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
                  channel.name,
                  channel.codec.encodeMethodCall(
                    MethodCall('Error', <String, dynamic>{
                      'handle': 99,
                      'error': <String, dynamic>{
                        'code': errorCode,
                        'message': errorMessage,
                        'details': errorDetails,
                      },
                    }),
                  ),
                  (_) {});
        }

        final AsyncQueue<DatabaseError> errors = AsyncQueue<DatabaseError>();

        // Subscribe and allow subscription to complete.
        final StreamSubscription<Event> subscription =
            query.onValue.listen((_) {}, onError: errors.add);
        await Future<void>.delayed(const Duration());

        await simulateError('Bad foo');
        await simulateError('Bad bar');
        final DatabaseError error1 = await errors.remove();
        final DatabaseError error2 = await errors.remove();
        await subscription.cancel();
        expect(error1.toString(), 'DatabaseError(12, Bad foo, Some details)');
        expect(error1.code, errorCode);
        expect(error1.message, 'Bad foo');
        expect(error1.details, errorDetails);
        expect(error2.code, errorCode);
        expect(error2.message, 'Bad bar');
        expect(error2.details, errorDetails);
      });

      test('observing value events', () async {
        mockHandleId = 87;
        const String path = 'foo';
        final Query query = database.reference().child(path);
        Future<void> simulateEvent(String value) async {
          await ServicesBinding.instance!.defaultBinaryMessenger
              .handlePlatformMessage(
                  channel.name,
                  channel.codec.encodeMethodCall(
                    MethodCall('Event', <String, dynamic>{
                      'handle': 87,
                      'snapshot': <String, dynamic>{
                        'key': path,
                        'value': value,
                      },
                    }),
                  ),
                  (_) {});
        }

        final AsyncQueue<Event> events = AsyncQueue<Event>();

        // Subscribe and allow subscription to complete.
        final StreamSubscription<Event> subscription =
            query.onValue.listen(events.add);
        await Future<void>.delayed(const Duration());

        await simulateEvent('1');
        await simulateEvent('2');
        final Event event1 = await events.remove();
        final Event event2 = await events.remove();
        expect(event1.snapshot.key, path);
        expect(event1.snapshot.value, '1');
        expect(event2.snapshot.key, path);
        expect(event2.snapshot.value, '2');

        // Cancel subscription and allow cancellation to complete.
        await subscription.cancel();
        await Future<void>.delayed(const Duration());

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
  });
}

/// Queue whose remove operation is asynchronous, awaiting a corresponding add.
class AsyncQueue<T> {
  Map<int, Completer<T>> _completers = <int, Completer<T>>{};
  int _nextToRemove = 0;
  int _nextToAdd = 0;

  void add(T element) {
    _completer(_nextToAdd++).complete(element);
  }

  Future<T> remove() {
    return _completer(_nextToRemove++).future;
  }

  Completer<T> _completer(int index) {
    if (_completers.containsKey(index)) {
      return _completers.remove(index)!;
    } else {
      return _completers[index] = Completer<T>();
    }
  }
}
