import 'package:flutter/material.dart';
import 'package:hukum_pro/arch/presentation/ui/view/splash_view.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SplashView(),
      ),
    );
  }
}
