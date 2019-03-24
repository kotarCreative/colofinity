import 'package:flutter/material.dart';
import './color_manager.dart';

main() => runApp(Colorfinity());

class Colorfinity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: ColorManager(),
        ),
      ),
    );
  }
}