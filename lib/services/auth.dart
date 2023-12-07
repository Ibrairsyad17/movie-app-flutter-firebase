import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/models/user.dart';
import 'package:movie_app/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj
  UserCreate? _userFromFirebase(User user){
     // ignore: unnecessary_null_comparison
     return user != null ? UserCreate(uid: user.uid) : null;
  }

  // change user stream
  Stream<UserCreate?> get user{
    return _auth.authStateChanges().map((User? user) => _userFromFirebase(user!));
  }

  // anon
  Future signAnon() async{
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // in email pass

  Future signInEAP(String em, String pass) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: em, password: pass);
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // regist email pass

  Future registerEAP(String em, String pass) async{
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: em, password: pass);
      User? user = result.user;

      await DBServices(uid: user?.uid).updateUserData();

      return _userFromFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // out
  Future signOut() async{
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Add Bookmark to database
  // Future addToBookmark() async{
  //   var currentUser = _auth.currentUser;

  // }
}