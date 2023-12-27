import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/screens/home/bookmark.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        resizeToAvoidBottomInset: false,

        // ! APPBAR --->

        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.red[800],
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.grey[900],

          // ! KOLOM SEARCH

          title: TextField(
            style: const TextStyle(color: Colors.red),
            cursorColor: Colors.red,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                filled: true,
                fillColor: Colors.red[100],
                hintText: 'Cari Film....',
                hintStyle: TextStyle(color: Colors.red[800]),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.red[800],
                )),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
          // ! KE HALAMAN BOOKMARK -->
          // * ----->
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const BookmarkCon()));
              },
              icon: Icon(Icons.bookmark),
              color: Colors.red[800],
            )
          ],
        ),
        body:
            // ! FILM FILM ---->
            // *
            StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('films').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;

                      // ! METHOD TAMBAH KE BOOKMARK ---->

                      Future<dynamic> addToBookmark() async {
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        var currentUser = _auth.currentUser;
                        CollectionReference _collectionReference =
                            FirebaseFirestore.instance
                                .collection('bookmark-items');

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Berhasil Menambahkan ke Bookmark')));

                        return _collectionReference
                            .doc(currentUser!.email)
                            .collection('items')
                            .doc()
                            .set({
                          "title": data['title'],
                          "year": data['year'],
                          "rate": data['rate'],
                          "synopsis": data['synopsis'],
                          "image": data['image']
                        }).then((value) => print('Ditambahkan ke bookmark'));
                      }

                      // ! DETAIL FILM ------>

                      void _showDetails(BuildContext context) =>
                          showModalBottomSheet<void>(
                              isScrollControlled: true,
                              backgroundColor: Colors.grey[900],
                              context: context,
                              builder: (BuildContext context) => Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 60.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
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
                                                child: Text('${data["title"]}',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      wordSpacing: 0,
                                                      letterSpacing: 0,
                                                      fontSize: 25,
                                                      color: Colors.red[800],
                                                    )),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text(
                                            '${data["year"]}',
                                            style: TextStyle(
                                                color: Colors.red[500],
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Container(
                                            width: 120,
                                            height: 180, // Border width
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: SizedBox.fromSize(
                                                size: Size.fromRadius(
                                                    48), // Image radius
                                                child: Image.network(
                                                    'https://drive.google.com/uc?export=view&id=${data["image"]}',
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber[600],
                                              ),
                                              const SizedBox(
                                                width: 20.0,
                                              ),
                                              Text(
                                                '${data["rate"]}',
                                                style: TextStyle(
                                                    color: Colors.red[800],
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              const Text(
                                                '/10',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Sinopsis',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                  '${data["synopsis"]}',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ));

                      // ! CARD FILM ------>

                      if (name.isEmpty) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
                          child: Card(
                            color: Colors.grey[900],
                            elevation: 0.1,
                            child: ListTile(
                              onTap: () => _showDetails(context),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.red, width: 0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor: Colors.grey[900],
                              hoverColor: Colors.grey[800],
                              textColor: Colors.white,
                              contentPadding: const EdgeInsets.all(20.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 15.0),
                                width: 100,
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://drive.google.com/uc?export=view&id=${data['image']}')),
                              ),
                              title: Text("${data['title']}"),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${data['year']}'),
                                  ]),
                              trailing: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('bookmark-items')
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .collection('items')
                                    .where('title', isEqualTo: data['title'])
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
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

                      // ! CARD FILM CARI ====>

                      if (data['title']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
                          child: Card(
                            color: Colors.grey[900],
                            elevation: 0.1,
                            child: ListTile(
                              onTap: () => _showDetails(context),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.red, width: 0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor: Colors.grey[900],
                              hoverColor: Colors.grey[800],
                              textColor: Colors.white,
                              contentPadding: const EdgeInsets.all(20.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 15.0),
                                width: 100,
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://drive.google.com/uc?export=view&id=${data['image']}')),
                              ),
                              title: Text("${data['title']}"),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${data['year']}'),
                                  ]),
                              trailing: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('bookmark-items')
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .collection('items')
                                    .where('title', isEqualTo: data['title'])
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
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
                      return Container();
                    });
          },
        ),
        // ! BACKGROUND COLOR ==>
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}
