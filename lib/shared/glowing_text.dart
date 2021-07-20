import 'package:flutter/material.dart';

// used for sign-in and register page design
// ignore: must_be_immutable
class GlowText extends StatefulWidget {
  double height = 0.0;
  double width = 0.0;
  bool curve = false;
  bool changeColor = false;

  GlowText(this.height, this.width, this.curve, this.changeColor);

  @override
  _GlowTextState createState() => _GlowTextState();
}

class _GlowTextState extends State<GlowText> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(microseconds: 200),
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: widget.curve ? BorderRadius.circular(20) : null,
        boxShadow: [
          BoxShadow(
            color: widget.changeColor ? Colors.redAccent : Colors.white,
            spreadRadius: 2,
            blurRadius: 3,
            //offset: Offset(-16, 8),
          ),],
      ),
    );
  }
}