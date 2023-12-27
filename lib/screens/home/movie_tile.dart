import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_data.dart';

class MovieTile extends StatelessWidget {
  final MoviesData movie;

  MovieTile({super.key, required this.movie});

  // Add Bookmark to Firebase

  @override
  Widget build(BuildContext context) {
    // ! TAMBAH BOOKMARK ==>

    Future<dynamic> addToBookmark() async {
      FirebaseAuth _auth = FirebaseAuth.instance;
      var currentUser = _auth.currentUser;
      CollectionReference _collectionReference =
          FirebaseFirestore.instance.collection('bookmark-items');

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil Menambahkan ke Bookmark')));

      return _collectionReference
          .doc(currentUser!.email)
          .collection('items')
          .doc()
          .set({
        "title": movie.title,
        "year": movie.year,
        "rate": movie.rate,
        "synopsis": movie.synopsis,
        "image": movie.image
      }).then((value) => print('Ditambahkan ke bookmark'));
    }

    // ! DETAIL FILM ===>

    // ignore: no_leading_underscores_for_local_identifiers
    void _showDetails(BuildContext context) => showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.grey[900],
        context: context,
        builder: (BuildContext context) => Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 25,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Center(
                          child: Text('${movie.title}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                wordSpacing: 0,
                                letterSpacing: 0,
                                fontSize: 25,
                                color: Colors.red[800],
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      '${movie.year}',
                      style: TextStyle(
                          color: Colors.red[500],
                          fontSize: 15.0,
                          fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: 120,
                      height: 180, // Border width
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(48), // Image radius
                          child: Image.network(
                              'https://drive.google.com/uc?export=view&id=${movie.image}',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          '${movie.rate}',
                          style: TextStyle(
                              color: Colors.red[800],
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Text(
                          '/10',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sinopsis',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            '${movie.synopsis}',
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ]),
            ));

    // ! CARD FILM ===>

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        shadowColor: Colors.grey[800],
        elevation: 5.0,
        child: ListTile(
          textColor: Colors.white,
          onTap: () => _showDetails(context),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
                color: Color.fromARGB(255, 144, 10, 0), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: Colors.grey[900],
          hoverColor: Colors.grey[800],
          contentPadding: const EdgeInsets.all(20.0),
          leading: Container(
            padding: EdgeInsets.only(right: 15.0),
            width: 100,
            child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://drive.google.com/uc?export=view&id=${movie.image}')),
          ),
          title: Text("${movie.title}"),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${movie.year}'),
          ]),
          trailing: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('bookmark-items')
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection('items')
                .where('title', isEqualTo: movie.title)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text('no data found');
              }

              return IconButton(
                onPressed: addToBookmark,
                icon: snapshot.data.docs.length == 0
                    ? Icon(
                        Icons.bookmark_add_outlined,
                        color: Colors.red[800],
                      )
                    : Icon(
                        Icons.bookmark_add,
                        color: Colors.red[800],
                      ),
              );
            },
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
