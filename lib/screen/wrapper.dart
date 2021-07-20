import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_neuron/model/my_user.dart';
import 'package:schedule_neuron/screen/authenticate/authenticate.dart';
import 'package:schedule_neuron/screen/home/navigation.dart';

// class that splits into either the sign-in/register page or home-page
class Wrapper extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser>(context);

    if (user == null) {
      return Authenticate(); // user not present/valid
    } else {
      return Navigation(); // user is present and valid
    }
  }
}