import 'package:flutter/material.dart';
import 'package:schedule_neuron/service/auth.dart';
import 'package:schedule_neuron/shared/glowing_shape.dart';
import 'package:schedule_neuron/shared/hex_color.dart';
import 'package:schedule_neuron/shared/loading.dart';
import 'package:schedule_neuron/shared/paint_diamond.dart';
import 'package:schedule_neuron/shared/paint_triangle.dart';

// register page of authentication
class Register extends StatefulWidget {
  final Function toggleView;

  Register(this.toggleView);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(); // used for TextFieldForm
  String email = '';
  String password = '';
  String error = ''; // error shown when user input is invalid
  bool loading = false; // true to show loading icon, false by default
  bool isHidden = true; // password is hidden by default

  // design related variables
  final backgroundColor = HexColor("#12203D"); // dark blue
  final logInBackgroundColor = HexColor('#FFFFFF'); // white
  final signInSize = 20.0;
  final registerSize = 22.0;
  final registerColor = HexColor("#E46471"); //
  final signInColor = HexColor("#27324D"); // pinkish red
  // for the 2 boxes behind log-in container
  final logInMiddleColor = HexColor("#E6F6FE"); // light blue
  final logInBtmColor = HexColor("#A2FBFF"); // medium blue
  final signInButtonColor = HexColor('#49F8FD'); // teal

  // toggle password visibility
  void toggleHidden() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading() // shows loading icon when there is delayed data
        : Scaffold(
            // else shows the sign-in page
            backgroundColor: backgroundColor,
            resizeToAvoidBottomInset: false,
            /*appBar: AppBar(
              backgroundColor: Colors.red[400],
              elevation: 0.0,
              title: Text('Register'),
              actions: <Widget>[
                TextButton.icon(
                    icon: Icon(Icons.person, color: Colors.black),
                    label: Text('Sign in',
                    style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      widget.toggleView();
                    }),
              ],
            ),*/
            body: Stack(
              children: <Widget>[
                circleShape(710, 156, Colors.blueAccent), // top-right
                circleShape(337, 373, Colors.greenAccent), // top-right
                circleShape(100, 321, Colors.redAccent), // top-right
                squareShape(707, 320, Colors.purpleAccent), // top-right
                squareShape(694, 30, Colors.brown), // top-right
                squareShape(65, 204, Colors.tealAccent), // top-right
                triangleShape1(545, 337), // top-right
                diamondShape1(770, 257), // top-right
                diamondShape2(493, 47), // top-right
                diamondShape3(85, 56), // top-right
                // btm-left-height-width
                phoneContainer(270, 110, 390, 180),
                // btm-left-height-width
                circleContainer(285, 190, 23, 23),
                // btm-right-height-width-color
                logInDesignContainer(
                    328, 95, 270, 210, logInBtmColor), // btm-left
                // btm-right-height-width
                logInDesignContainer(
                    345, 65, 270, 270, logInMiddleColor), // btm-left
                // background for log in and register
                // top-right-height-width
                logInRegisterContainer(170, 30, 270, 330),
                signInToggleButton(185, 100), // top-left
                registerToggleButton(185, 190), // top-left
                welcomeText(570, 90, 'Welcome to'), // top-right
                welcomeText(620, 40, 'Schedule Neuron'), // top-right
                Column(
                  children: <Widget>[
                    SizedBox(height: 190),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                                height:
                                    20.0), // filler to space the different components for design

                            // email box
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Enter a valid email';
                                } else {
                                  return null; // email is valid
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                fillColor: Colors.white, // box color
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),

                                // border appears in this color when not clicked by user
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: Colors.white, // border color
                                    width: 1.0,
                                  ),
                                ),

                                // border appears in this color when clicked by user
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: Colors.black, // border color
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            // password box
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              validator: (val) {
                                if (val!.length < 6) {
                                  // password must be at least 6 characters long
                                  return 'Enter A Password With At Least 6 Characters'; // password is invalid
                                } else {
                                  return null; // password is valid
                                }
                              },
                              obscureText:
                                  isHidden, // shows * when true, or letters when false
                              decoration: InputDecoration(
                                hintText: 'Password',
                                fillColor: Colors.white, // box color
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                  ),
                                suffixIcon: IconButton(
                                  color: Colors.grey,
                                  onPressed: () {
                                    toggleHidden();
                                  },
                                  icon: isHidden
                                      ? Icon(Icons.security)
                                      : Icon(Icons.visibility_off),
                                ),
                                // border appears in this color when not clicked by user
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: Colors.white, // border color
                                    width: 1.0,
                                  ),
                                ),
                                // border appears in this color when clicked by user
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: Colors.black, // border color
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20.0),

                            // button to click when registering
                            TextButton(
                                child: Text('Enter'),
                                style: TextButton.styleFrom(
                                  primary: Colors.black,
                                  backgroundColor: signInButtonColor,
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onPressed: () async {
                                  // display loading screen
                                  setState(() {
                                    loading = true;
                                  });

                                  dynamic result = await _auth
                                      .registerWithEmail(email, password);

                                  if (result == null) {
                                    setState(() {
                                      error = 'Email is taken or Password is shorter than 6 letters';
                                      loading =
                                          false; //remove loading screen since data is received
                                    });
                                  }
                                }),
                            SizedBox(height: 20.0),
                            errorText(
                                error), // error at bottom of register page
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  // error text at bottom of button
  Widget errorText(String error) {
    return Text(
      // if user input an invalid email or password
      error,
      style: TextStyle(
        color: Colors.red,
        fontSize: 10.0,
      ),
    );
  }

  // white background behind log-in
  Widget logInRegisterContainer(
      double first, double second, double height, double width) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: logInBackgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 0,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  // white-blue background behind log-in
  Widget logInDesignContainer(double first, double second, double height,
      double width, HexColor color) {
    return Positioned(
      bottom: first,
      left: second,
      child: Opacity(
        opacity: 0.9,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 0,
                color: color,
              )
            ],
          ),
        ),
      ),
    );
  }

  // phone container
  Widget phoneContainer(
      double first, double second, double height, double width) {
    return Positioned(
      bottom: first,
      left: second,
      child: Opacity(
        opacity: 0.7,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            border: Border.all(width: 5, color: Colors.white),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 0,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  // circle icon in phone design
  Widget circleContainer(
      double first, double second, double height, double width) {
    return Positioned(
      bottom: first,
      left: second,
      child: Opacity(
        opacity: 0.7,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(width: 3, color: Colors.white),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 0,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  // sign in button to navigate to sign in page
  Widget signInToggleButton(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: TextButton(
        child: Text(
          'Sign In',
          style: TextStyle(
            color: signInColor,
            fontSize: signInSize,
          ),
        ),
        onPressed: () {
          widget.toggleView(); // toggle between sign-in and register page
        },
      ),
    );
  }

  // register button with no function
  Widget registerToggleButton(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: TextButton(
        child: Text(
          'Register',
          style: TextStyle(
            color: registerColor,
            fontSize: registerSize,
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  // welcome text at the bottom
  Widget welcomeText(double first, double second, String text) {
    return Positioned(
      top: first,
      right: second,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9), // max is 1
          fontSize: 40.0,
          fontWeight: FontWeight.w900, // bold degree
          shadows: [
            Shadow(
              color: Colors.white,
              blurRadius: 3.0,
            ),
          ],
        ),
      ),
    );
  }

  // background shapes design methods are below
  Widget circleShape(double first, double second, Color color) {
    return Positioned(
      top: first,
      right: second,
      child: GlowShape(color, BoxShape.circle),
    );
  }

  Widget squareShape(double first, double second, Color color) {
    return Positioned(
      top: first,
      right: second,
      child: GlowShape(color, BoxShape.rectangle),
    );
  }

  Widget triangleShape1(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        color: backgroundColor,
        //color: Colors.white, //debug purpose
        width: 15,
        height: 15,
        child: CustomPaint(
          foregroundPainter: TrianglePainter1(),
        ),
      ),
    );
  }

  Widget diamondShape1(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        color: backgroundColor,
        //color: Colors.white, //debug purpose
        width: 25,
        height: 25,
        child: CustomPaint(
          foregroundPainter: DiamondPainter1(),
        ),
      ),
    );
  }

  Widget diamondShape2(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        color: backgroundColor,
        //color: Colors.white, //debug purpose
        width: 25,
        height: 25,
        child: CustomPaint(
          foregroundPainter: DiamondPainter2(),
        ),
      ),
    );
  }

  Widget diamondShape3(double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: Container(
        color: backgroundColor,
        //color: Colors.white, //debug purpose
        width: 25,
        height: 25,
        child: CustomPaint(
          foregroundPainter: DiamondPainter3(),
        ),
      ),
    );
  }
}
