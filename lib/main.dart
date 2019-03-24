import 'package:flutter/material.dart';
import 'dart:math' as math;

main() => runApp(Colorfinity());

class Colorfinity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF333333),
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white),
        ),
      ),
      home: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Colorfinity'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Info(),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: AppManager(),
      ),
    );
  }
}

class AppManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {
  List<Color> cols = <Color>[];
  String editMode = 'Hue';
  final ScrollController _scrollCont = new ScrollController();

  void addCol() {
    Color color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
    setState(() => cols.add(color));
    double maxScroll = _scrollCont.position.maxScrollExtent;
    if (maxScroll > 0) {
      _scrollCont.animateTo(
        maxScroll + 70,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  void removeCol(int idx) => setState(() => cols.removeAt(idx));

  void alterEditMode() {
    String val = 'Saturation';
    if (editMode == 'Saturation') {
      val = 'Lightness';
    } else if (editMode == 'Lightness') {
      val = 'Hue';
    }
    setState(() => editMode = val);
  }

  void updateCol(int idx, Color color, double dx) {
    HSLColor hslCol = HSLColor.fromColor(color);
    if (editMode == 'Hue') {
      double hue = hslCol.hue + dx;
      if (hue >= 0 && hue <= 360) {
        setState(() => cols[idx] = hslCol.withHue(hue).toColor());
      }
    } else if (editMode == 'Saturation') {
      double sat = hslCol.saturation + dx / 100;
      if (sat >= 0 && sat <= 1) {
        setState(() => cols[idx] = hslCol.withSaturation(sat).toColor());
      }
    } else if (editMode == 'Lightness') {
      double lig = hslCol.lightness + dx / 100;
      if (lig >= 0 && lig <= 1) {
        setState(() => cols[idx] = hslCol.withLightness(lig).toColor());
      }
    }
  }

  Widget _buildColorCard(BuildContext context, int idx) {
    return ColCard(idx, cols[idx], onDrag: updateCol, onHold: removeCol);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            child: ListView.builder(
              itemBuilder: _buildColorCard,
              itemCount: cols.length,
              controller: _scrollCont,
            ),
            onDoubleTap: alterEditMode,
          ),
        ),
        Container(
          child: Text(
            'Edit Mode: $editMode',
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.all(20),
        ),
        GestureDetector(
          child: Container(
            child: Center(
              child: Text(
                'Add Color',
                style: Theme.of(context).textTheme.button,
              ),
            ),
            color: Theme.of(context).primaryColor,
            height: 60,
          ),
          onTap: addCol,
        )
      ],
    );
  }
}

class ColCard extends StatelessWidget {
  final int idx;
  final Color col;
  final Function onDrag;
  final Function onHold;

  ColCard(this.idx, this.col, {this.onDrag, this.onHold});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        onDrag(idx, col, details.delta.dx.round() * 0.5);
      },
      onLongPress: () => onHold(idx),
      child: Card(
        child: AnimatedContainer(
          child: Center(
            child: Text(
              '#${col.value.toRadixString(16).toUpperCase().substring(2)}',
              style: Theme.of(context).textTheme.button,
            ),
          ),
          height: 60,
          duration: const Duration(milliseconds: 200),
        ),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        color: col,
      ),
    );
  }
}

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Actions')),
      body: Container(
        child: Text(
          '1. Scroll horizontally on colors to edit.\n2. Double tap to change edit value.\n3. Tap and hold to remove color.',
          style: TextStyle(fontSize: 18),
        ),
        margin: EdgeInsets.all(20.0),
      ),
    );
  }
}