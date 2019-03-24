import 'package:flutter/material.dart';
import 'dart:math' as math;
import './widgets.dart';

main() => runApp(Colorfinity());

class Colorfinity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xFF333333),
          textTheme: TextTheme(button: TextStyle(color: Colors.white))),
      home: MainApp()
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Colorfinity'), actions: [
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Info(),
              )),
        )
      ]),
      body: Container(
        child: ColorManager(),
      ),
    );
  }
}

class ColorManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ColorManagerState();
  }
}

class _ColorManagerState extends State<ColorManager> {
  List<Color> _colors = <Color>[];
  String editMode = 'hue';
  final ScrollController _scrollCont = new ScrollController();

  void _add() {
    Color color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
    setState(() => _colors.add(color));
    double maxScroll = _scrollCont.position.maxScrollExtent;
    if (maxScroll > 0) {
      _scrollCont.animateTo(maxScroll + 70,
          curve: Curves.easeInOut, duration: const Duration(milliseconds: 500));
    }
  }

  void remove(int idx) {
    setState(() => _colors.removeAt(idx));
  }

  void changeEditType() {
    String newType;
    if (editMode == 'hue') {
      newType = 'saturation';
    } else if (editMode == 'saturation') {
      newType = 'lightness';
    } else if (editMode == 'lightness') {
      newType = 'hue';
    }
    setState(() => editMode = newType);
  }

  void updateColor(int idx, Color color, double delta) {
    HSLColor hslCol = HSLColor.fromColor(color);
    if (editMode == 'hue') {
      double newHue = hslCol.hue + delta;
      if (newHue >= 0 && newHue <= 360) {
        setState(() => _colors[idx] = hslCol.withHue(newHue).toColor());
      }
    } else if (editMode == 'saturation') {
      double newSat = hslCol.saturation + delta / 100;
      if (newSat >= 0 && newSat <= 1) {
        setState(() => _colors[idx] = hslCol.withSaturation(newSat).toColor());
      }
    } else if (editMode == 'lightness') {
      double newLig = hslCol.lightness + delta / 100;
      if (newLig >= 0 && newLig <= 1) {
        setState(() => _colors[idx] = hslCol.withLightness(newLig).toColor());
      }
    }
  }

  Widget _buildColorCard(BuildContext context, int idx) {
    Color colorVal = _colors[idx];
    return ColorCard(idx, colorVal, onDrag: updateColor, onHold: remove);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: _buildColorCard,
              itemCount: _colors.length,
              controller: _scrollCont,
            ),
          ),
          Container(
              child: Text(
                'Slide to edit $editMode',
                textAlign: TextAlign.center,
              ),
              margin: EdgeInsets.all(20)),
          FooterBtn('Add Color', _add)
        ],
      ),
      onDoubleTap: changeEditType,
    );
  }
}
