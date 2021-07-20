import 'package:flutter/material.dart';

// to make an arc
// to do so, simply wrap a container with ClipPath(clipper: Clipper, child: <WhateverYouNeed>)
// For example:
/*Widget buildTopArcContainer(double first, double second) {
    return Positioned(
      bottom: first,
      left: second,
      child: ClipPath(
        clipper: ClipperUpwards(),
        child: Container(
          height: 595,
          width: 392,
          decoration: BoxDecoration(
            color: HexColor('#F9BE7C'),
          ),
          child: Text(''),
        ),
      ),
    );
  }*/

// arc facing downwards
class ClipperDownwards extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    return path;
  }

  // return true when you want to add new information
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// arc facing upwards
class ClipperUpwards extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 40);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);
    path.lineTo(size.width, 40);
    path.lineTo(size.width, 0);
    //print('height: ${size.height}'); // 595
    //print('width: ${size.width}');   // 400
    return path;
  }

  // return true when you want to add new information
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
