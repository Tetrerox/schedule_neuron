import 'package:flutter/material.dart';
import 'package:schedule_neuron/screen/authenticate/register.dart';
import 'package:schedule_neuron/screen/authenticate/sign_in.dart';

// class to toggle between sign-in page and register page
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  // toggle between sign-in page and registration page
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // when showSignIn is true, sign-in page is shown,
    // else register page is shown
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      return Register(toggleView);
    }
  }
}
