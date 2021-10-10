import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hukum_pro/di/root_injector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: (() async {
        await Firebase.initializeApp();
        RootInjector().build();
      })(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(color: Colors.red);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(color: Colors.blue);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(color: Colors.green);
      },
    );
  }
}
