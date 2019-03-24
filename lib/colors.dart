import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class Colors extends StatelessWidget {
  final List<dynamic> colors;
  final int inFocus;
  final Function addColor;
  final Function deleteColor;
  final Function focusColor;
  final ScrollController _scrollCont = new ScrollController();

  Colors(this.colors, {this.inFocus, this.addColor, this.deleteColor, this.focusColor});

  Widget _buildColorCard(BuildContext context, int index) {
    Color colorVal = colors[index];
    return ColorCard(colorVal, index, focusColor: focusColor, inFocus: inFocus == index);
  }

  Widget _buildColorsList(BuildContext context) {
    return Column(
      children: <Widget>[
        colors.length > 0 ?
        Expanded(
          child: ListView.builder(
              itemBuilder: _buildColorCard,
              itemCount: colors.length,
              controller: _scrollCont),
        ) :
        Expanded(child: Center(child: Text('Add colors to create a color palette. \n Scroll horizontally on colors to change their hue. \n Tap and hold on a color to edit it.', textAlign: TextAlign.center,),),),
        GestureDetector(
          child: inFocus != null ? Button(Color(0xFFFF0000), 'Remove Color', false) : Button(Color(0xFF333333), 'Add Color', false),
          onTap: () {
            if (inFocus != null) {
              deleteColor();
            } else {
              addColor();
              if (_scrollCont.position.maxScrollExtent > 0) {
                _scrollCont.animateTo(
                    _scrollCont.position.maxScrollExtent + 70,
                    curve: Curves.easeInOut,
                    duration: const Duration(seconds: 1));
              }
            }
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildColorsList(context);
  }
}

class ColorCard extends StatefulWidget {
  final Color color;
  final int index;
  final Function focusColor;
  final bool inFocus;

  ColorCard(this.color, this.index, {this.focusColor, this.inFocus});

  @override
  State<StatefulWidget> createState() {
    return _ColorCardState();
  }
}

class _ColorCardState extends State<ColorCard> {
  Color _color;

  @override
  void initState() {
    setState(() {
      _color = widget.color;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _colorStr = '#' + _color.value.toRadixString(16).toUpperCase();
    return GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          HSLColor hslCol = HSLColor.fromColor(_color);
          double newHue = hslCol.hue + (details.delta.dx.round() * 0.5);
          if (newHue >= 0 && newHue <= 360) {
            setState(() {
              _color = hslCol.withHue(newHue).toColor();
            });
          }
        },
        onLongPress: () {
          widget.focusColor(widget.index);
        },
        child: Button(_color, _colorStr, widget.inFocus));
  }
}

class Button extends StatelessWidget {
  final Color bgColor;
  final String text;
  final TextStyle _textStyle = TextStyle(color: CupertinoColors.white);
  final bool inFocus;

  Button(this.bgColor, this.text, this.inFocus);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: inFocus ? [BoxShadow(color: Color(0xFF333333), blurRadius: 2.0)] : null,
        color: bgColor,
      ),
      child: Center(
        child: Text(text, style: _textStyle),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      height: 60.0,
      duration: const Duration(milliseconds: 200),
    );
  }
}
