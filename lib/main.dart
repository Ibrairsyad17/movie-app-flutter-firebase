import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_app/screens/wrapper.dart';
import 'package:movie_app/services/auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/models/user.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserCreate?>.value(
      value: AuthService().user,
      catchError: (User, UserCreate) {
        return null;
      },
      initialData: null,
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}