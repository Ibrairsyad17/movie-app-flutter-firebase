import 'package:flutter/material.dart';
import 'package:movie_app/models/user.dart';
import 'package:movie_app/screens/authenticate/authenticate.dart';
import 'package:movie_app/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserCreate?>(context);
    print(user);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}