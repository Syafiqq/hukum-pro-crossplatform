import 'package:flutter/material.dart';
import 'package:hukum_pro/arch/presentation/ui/page/law_screen.dart';
import 'package:hukum_pro/arch/presentation/ui/view/splash_view.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashView((BuildContext context) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LawScreen()),
          ModalRoute.withName("/dashboard"));
    });
  }
}
