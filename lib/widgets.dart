import 'package:flutter/material.dart';

formatColor(Color color) =>
    '#${color.value.toRadixString(16).toUpperCase().substring(2)}';

class ColorCard extends StatelessWidget {
  final int idx;
  final Color color;
  final Function onDrag;
  final Function onHold;

  ColorCard(this.idx, this.color, {this.onDrag, this.onHold});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        onDrag(idx, color, details.delta.dx.round() * 0.5);
      },
      onLongPress: () => onHold(idx),
      child: Card(
        child: AnimatedContainer(
          child: Center(
            child: Text(
              formatColor(color),
              style: Theme.of(context).textTheme.button,
            ),
          ),
          height: 60,
          duration: const Duration(milliseconds: 200),
        ),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        color: color,
      ),
    );
  }
}

class FooterBtn extends StatelessWidget {
  final String label;
  final Function onTap;

  FooterBtn(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.button,
          ),
        ),
        color: Theme.of(context).primaryColor,
        height: 60,
      ),
      onTap: () => onTap(),
    );
  }
}

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Colorfinity')),
      body: Container(
        child: Text(
          '1. Add colors to create a color palette.\n2. Scroll horizontally on colors to change their value.\n3. Double tap to change edit value.\n4. Tap and hold to remove color.',
        ),
        margin: EdgeInsets.all(20.0),
      ),
    );
  }
}
