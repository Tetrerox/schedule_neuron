import 'package:flutter/material.dart';

// used for sign-in and register page design
// ignore: must_be_immutable
class GlowShape extends StatefulWidget {
  late Color color;
  late BoxShape shape;

  GlowShape(this.color, this.shape);

  @override
  _GlowShapeState createState() => _GlowShapeState();
}

class _GlowShapeState extends State<GlowShape> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13, // control shape size
      width: 13, // control shape size
      decoration: BoxDecoration(
        color: widget.color,
        shape: widget.shape,
        boxShadow: [
          BoxShadow(
            color: widget.color,
            //spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
      ),
    );
  }
}
