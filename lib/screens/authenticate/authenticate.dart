import 'package:flutter/material.dart';
import 'package:movie_app/screens/authenticate/register.dart';
import 'package:movie_app/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showPage = true;
  void togglePage(){
    setState(() => showPage = !showPage);
  }

  @override
  Widget build(BuildContext context) {
    if (showPage) {
      return Register(togglePage: togglePage);
    } else {
      return SignIn(togglePage: togglePage);
    }
  }
}