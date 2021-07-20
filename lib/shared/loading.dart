import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// shared class among many classes that requires the loading icon
//  when delayed data is obtained / sent to Firebase.
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400],
      child: Center(
        child: SpinKitFadingCircle( // loading icon
          color: Colors.grey,
          size: 40.0,
        ),
      ),
    );
  }
}