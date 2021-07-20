import 'package:flutter/material.dart';
import 'package:schedule_neuron/shared/hex_color.dart';

class Credits extends StatelessWidget {

  String credits = 'We would like to thank some channels\n' +
  'which we had learnt a lot from.\n \nSome of them includes ' +
  'TheNetNinja\n- Authentication & Firebase & Johannes\n Milke - ' +
  'Calendar and Drop-Down\nButton-related features. \n \n' +
  'Please refer to their youtube\nchannels below: \n \n' +
  'TheNetNinja - https://www.youtube.\ncom/channel/UCW5YeuERMmlnq\no4oq8vwUpg \n \n'+
  'Milke - https://www.youtube.com/cha\nnnel/UC0FD2apauvegCcsvqIBceLA \n \n'+
  'For design ideas, please refer to \nhttps://dribbble.com/. \n \n' +
  'Lastly, we would like to thank NUS for\ngiving us this opportunity ' +
  'to do\nSchedule Neuron as part of our\nOrbital Project.';
  
  // design-related variables
  final pageHeaderColor = HexColor('#000000'); // 'Calendar' Text (black)
  final pageBackgroundColor =
      HexColor('#FFF9EB'); // Scaffold Background Color (light yellow)
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: Stack(
        children: <Widget>[
          pageHeader(90, 40), // top-left
          closeButton(context, 80, 30), // top-right
          creditsText(150, 30), //top-left
        ],
      ),
    );
  }

  Widget pageHeader(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Text(
        'Credits',
        style: TextStyle(
          fontSize: 30,
          color: pageHeaderColor,
        ),
        ),
    );
  }

  Widget closeButton(BuildContext context, double first, double second) {
    return Positioned(
      top: first,
      right: second,
      child: CloseButton(onPressed: () {
        Navigator.pop(context);
      }),
    );
  }

  Widget creditsText(double first, double second) {
    return Positioned(
      top: first,
      left: second,
      child: Container(
        //color: Colors.red, // debug purpose
        constraints: BoxConstraints(
          minWidth: 290,
          minHeight: 600,
        ),
        child: Text(
          credits,
          style: TextStyle(
            fontSize: 20,
          ),
          ),
      ),
    );
  }
}
