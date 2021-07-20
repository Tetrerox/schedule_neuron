import 'package:flutter/material.dart';
import 'package:schedule_neuron/service/auth.dart';

// welcome back page
class HomePage extends StatelessWidget {
  final AuthService _auth = AuthService(); // app-bar method

  // background of home-page
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: appBarDesign(context, _auth),
        body: homePageBody(context),
      ),
    );
  }

  // method: app bar of home-page
  AppBar appBarDesign(BuildContext context, AuthService _auth) {
    return AppBar(
      title: Text('Home Page'),
      backgroundColor: Colors.red[400],
      elevation: 0.0,
      actions: <Widget>[
        TextButton.icon(
          onPressed: () async {
            await _auth.signOut(); // user log-outs when pressed
          },
          icon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          label: Text('Logout', style: TextStyle(color: Colors.black)),
        )
      ],
    );
  }

  // method: body of the home-page which consists of a column of 3 catergories
  Widget homePageBody(BuildContext context) {
    return Container(
      alignment: Alignment.center, // align column to centre
      child: Column(
        children: <Widget>[
          SizedBox(height: 50.0),
          _welcomeBackText(),
          SizedBox(height: 30.0),
          _avatarIcon(),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Container(
              height: 300,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 8,
                childAspectRatio: 1.30,
                children: [
                  _featureIcon('Feature 1'),
                  _featureIcon('Feature 2'),
                  _featureIcon('Feature 3'),
                  _featureIcon('Feature 4'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // method: text at the top of circle avatar
  Widget _welcomeBackText() {
    return Text(
      'Welcome Back',
      style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // method: circle avatar at the top
  Widget _avatarIcon() {
    return CircleAvatar(
      backgroundImage: AssetImage('assets/Schedule.jpg'),
      radius: 80,
    );
  }

  // method: button to navigate from home-page to calendar page
  Widget _featureIcon(String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(text, style: TextStyle(fontSize: 20.0)),
      ),
    );
  }
}
