import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/models/bookmark_data.dart';
import 'package:movie_app/models/movie_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBServices{

  final String? uid;
  DBServices({this.uid});

  // ! Collection Reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('userProfile');

  // ! Bookmarks Reference
  final CollectionReference bookmarkCollection = FirebaseFirestore.instance.collection('bookmark-items');

  // ! MOVIE COLLECTION BROOO-->

  final CollectionReference movieCollection = FirebaseFirestore.instance.collection('films');
  
  Future updateUserData() async{
    return await userCollection.doc(uid).set({
      'email': FirebaseAuth.instance.currentUser!.email,
      'name': '',
      'genre': '',
      'imageLink': '',
    });
  }

  // ! LISTING MOVIES DATA DISINI--->

  List<MoviesData> _mUserListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return MoviesData(
        title: doc.get('title') ?? '',
        synopsis: doc.get('synopsis') ?? '',
        year: doc.get('year'),
        rate: doc.get('rate'),
        image: doc.get('image')
      );
    }).toList();
  }

  // ! Listing Bookmark
  List<BookmarkData> _bookmarkData(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return BookmarkData(
        title: doc.get('title') ?? '',
        synopsis: doc.get('synopsis') ?? '',
        year: doc.get('year'),
        rate: doc.get('rate'),
        image: doc.get('image'),
      );
    }).toList();
  }

  // Bookmark Stream
  Stream<List<BookmarkData>> get bookmarks{
    FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    return bookmarkCollection.doc(currentUser!.email).collection('items').snapshots().map(_bookmarkData);
  }
  // Movie Stream
  Stream<List<MoviesData>> get movies{
    return movieCollection.snapshots().map(_mUserListFromSnapshot);
  }
}