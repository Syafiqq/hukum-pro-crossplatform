import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_menu_order_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/law_year_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/contract/version_local_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/cache_shared_preferences.dart';
import 'package:hukum_pro/arch/data/data_source/local/impl/object_box_database_storage.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/bulk_laws_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/law_menu_order_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/contract/version_remote_datasource.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_cloud_database.dart';
import 'package:hukum_pro/arch/data/data_source/remote/impl/firebase_cloud_storage.dart';
import 'package:hukum_pro/arch/infrastructure/local_database/object_box/store_provider.dart';
import 'package:hukum_pro/di/contract/object_resolver.dart';
import 'package:hukum_pro/di/root_injector.dart';
import 'package:kiwi/kiwi.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].

  Future<void> _initializeApp() async {
    // Firebase
    await Firebase.initializeApp();

    // DI
    RootInjector().build();

    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("hasError = ${snapshot.hasError}");
          print(snapshot.error);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print("hasData = ${snapshot.hasData}");
          print(snapshot.data);
          print(Firebase.app());
          checkKiwi();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        print("Loading");
        return Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: Text(
              'Hello World',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 32,
                color: Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  void checkKiwi() {
    KiwiContainer container = KiwiContainer();
    print('checkKiwi');
    checkObject(Firebase.app());
    checkObject(container.resolve<FirebaseApp>());
    checkObject(container.resolve<FirebaseApp>());
    checkObject(container.resolve<FirebaseDatabase>());
    checkObject(container.resolve<FirebaseDatabase>());
    checkObject(container.resolve<FirebaseStorage>());
    checkObject(container.resolve<FirebaseStorage>());
    checkObject(container.resolve<FirebaseCloudDatabase>());
    checkObject(container.resolve<FirebaseCloudDatabase>());
    checkObject(container.resolve<VersionRemoteDatasource>());
    checkObject(container.resolve<VersionRemoteDatasource>());
    checkObject(container.resolve<LawMenuOrderRemoteDatasource>());
    checkObject(container.resolve<LawMenuOrderRemoteDatasource>());
    checkObject(container.resolve<FirebaseCloudStorage>());
    checkObject(container.resolve<FirebaseCloudStorage>());
    checkObject(container.resolve<BulkLawsRemoteDatasource>());
    checkObject(container.resolve<BulkLawsRemoteDatasource>());
    checkObject(container.resolve<Future<SharedPreferences>>());
    checkObject(container.resolve<Future<SharedPreferences>>());
    checkObject(container.resolve<CacheSharedPreferences>());
    checkObject(container.resolve<CacheSharedPreferences>());
    checkObject(container.resolve<VersionLocalDatasource>());
    checkObject(container.resolve<VersionLocalDatasource>());
    checkObject(container.resolve<LawMenuOrderLocalDatasource>());
    checkObject(container.resolve<LawMenuOrderLocalDatasource>());
    checkObject(container.resolve<Store>());
    checkObject(container.resolve<Store>());
    checkObject(container.resolve<ObjectResolver>());
    checkObject(container.resolve<ObjectResolver>());
    checkObject(container.resolve<StoreProvider>());
    checkObject(container.resolve<StoreProvider>());
    checkObject(container.resolve<ObjectBoxDatabaseStorage>());
    checkObject(container.resolve<ObjectBoxDatabaseStorage>());
    checkObject(container.resolve<LawLocalDatasource>());
    checkObject(container.resolve<LawLocalDatasource>());
    checkObject(container.resolve<LawYearLocalDatasource>());
    checkObject(container.resolve<LawYearLocalDatasource>());
  }

  void checkObject(Object x) {
    print("${x.hashCode} - $x");
  }
}
