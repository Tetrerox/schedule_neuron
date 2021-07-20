// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_neuron/model/my_user.dart';
import 'package:schedule_neuron/screen/wrapper.dart';
import 'package:schedule_neuron/service/auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      initialData: null,
      value: AuthService().user, // access the user of the AuthService class
      catchError: (_, __) => null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
