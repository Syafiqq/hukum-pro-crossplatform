import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kiwi/kiwi.dart';

class FirebaseModule {
  static final FirebaseModule _singleton = FirebaseModule._internal();

  factory FirebaseModule() {
    return _singleton;
  }

  FirebaseModule._internal();

  void build() {
    KiwiContainer container = KiwiContainer();

    // FirebaseDatabase
    container.registerSingleton((c) {
      final app = Firebase.app();
      return FirebaseDatabase(
          app: app, databaseURL: 'https://hukumpro-serverproxy.firebaseio.com');
    });

    // FirebaseCloudStorage
    container.registerSingleton((c) {
      final app = Firebase.app();
      return FirebaseStorage.instanceFor(
          app: app, bucket: 'hukumpro-serverproxy.appspot.com');
    });
  }
}
