import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.lerp(
                      Alignment.topCenter, Alignment.bottomCenter, 0.4) ??
                      Alignment.center,
                  child: Image(
                    image: AssetImage('res/images/ic_hukum_pro_logo_2_192.png'),
                    color: Color(0xFF313131),
                    width: 128,
                    height: 128,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Hukum Pro',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      color: Color(0xFF313131),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
              child: Column(
                children: [
                  SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(),
                  ),
                  Text(
                    'Check Version',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      color: Color(0xFF313131),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
