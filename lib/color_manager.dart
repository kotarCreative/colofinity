import 'package:flutter/cupertino.dart';
import './colors.dart';

import 'dart:math' as math;

class ColorManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ColorManagerState();
  }
}

class _ColorManagerState extends State<ColorManager> {
  List<Color> _colors = <Color>[];
  int focusedColor;

  void _addColor() {
    Color color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
    setState(() {
      _colors.add(color);
    });
  }

  void _deleteColor() {
    setState(() {
      _colors.removeAt(focusedColor);
      focusedColor = null;
    });
  }

  void _focusColor(int index) {
    print('focus up');
    setState(() {
      focusedColor = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Colors(_colors,
        addColor: _addColor,
        deleteColor: _deleteColor,
        focusColor: _focusColor,
        inFocus: focusedColor);
  }
}
