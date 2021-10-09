import 'package:flutter/material.dart';

class LawPerYearScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _LawPerYearScreenStateful();
  }
}

class _LawPerYearScreenStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LawPerYearScreenStatefulState();
}

class _LawPerYearScreenStatefulState extends State<_LawPerYearScreenStateful> {
  var _title = "Hukum Pro";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Container(),
    );
  }
}
