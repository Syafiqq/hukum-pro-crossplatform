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
    // Firebase App
    container.registerSingleton((c) => Firebase.app());

    // FirebaseDatabase
    container.registerSingleton((c) {
      return FirebaseDatabase(
          app: c<FirebaseApp>(),
          databaseURL: 'https://hukumpro-serverproxy.firebaseio.com');
    });

    // FirebaseCloudStorage
    container.registerSingleton((c) {
      return FirebaseStorage.instanceFor(
          app: c<FirebaseApp>(), bucket: 'hukumpro-serverproxy.appspot.com');
    });
  }
}
