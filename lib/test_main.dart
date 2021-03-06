// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hukum_pro/arch/presentation/ui/page/splash_screen.dart';
import 'package:hukum_pro/di/root_injector.dart';
import 'package:path_provider/path_provider.dart';

import 'arch/presentation/ui/view/splash_view.dart';

void main() {
  RootInjector().build();
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('error');
          print(snapshot.error);
          return Container(color: Colors.red);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.amber,
            ),
            home: Scaffold(
              body: SplashScreen(),
            ),
          );
        }
        return Container(color: Colors.white);
      },
    );
  }
}
