import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:hukum_pro/di/root_injector.dart';
import 'package:kiwi/kiwi.dart';

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
          KiwiContainer container = KiwiContainer();
          print(container.resolve<FirebaseDatabase>());
          print(container.resolve<FirebaseStorage>());
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
}
