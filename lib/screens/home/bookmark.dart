import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

class BookmarkCon extends StatefulWidget {
  const BookmarkCon({super.key});

  @override
  State<BookmarkCon> createState() => _BookmarkConState();
}

class _BookmarkConState extends State<BookmarkCon> {
  // Elevated

  late ScrollController _controller;
  bool _showFab = true;
  bool _isElevated = true;
  bool _isVisible = true;

  FloatingActionButtonLocation get _fabLocation => _isVisible
      ? FloatingActionButtonLocation.endContained
      : FloatingActionButtonLocation.endFloat;

  void _listen() {
    final ScrollDirection direction = _controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      _show();
    } else if (direction == ScrollDirection.reverse) {
      _hide();
    }
  }

  void _show() {
    if (!_isVisible) {
      setState(() => _isVisible = true);
    }
  }

  void _hide() {
    if (_isVisible) {
      setState(() => _isVisible = false);
    }
  }

  void _onShowFabChanged(bool value) {
    setState(() {
      _showFab = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_listen);
  }

  @override
  void dispose() {
    _controller.removeListener(_listen);
    _controller.dispose();
    super.dispose();
  }

  final CollectionReference _bookmarkListUser = FirebaseFirestore.instance
      .collection('bookmark-items')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('items');

  // ! DELETE ITEMS ===>

  Future<void> _deleteItems(String itemsID) async {
    await _bookmarkListUser.doc(itemsID).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil Menghapus Dari Bookmark')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // ! APPBAR ===>
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.red[800],
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: Text(
          'Bookmark Film Kamu',
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.red[800],
              fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder(
        stream: _bookmarkListUser.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  // ! DETAIL FILM ====>

                  void _showDetails(BuildContext context) =>
                      showModalBottomSheet<void>(
                        backgroundColor: Colors.grey[800],
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 60.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                      child:
                                          Text('${documentSnapshot["title"]}',
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
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  '${documentSnapshot["year"]}',
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
                                          BorderRadius.circular(15.0)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: SizedBox.fromSize(
                                      size: Size.fromRadius(48), // Image radius
                                      child: Image.network(
                                          'https://drive.google.com/uc?export=view&id=${documentSnapshot["image"]}',
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
                                      '${documentSnapshot["rate"]}',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        '${documentSnapshot["synopsis"]}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      );

                  // ! CARD FILM BOOKMARK ==>
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    child: Card(
                      color: Colors.grey[900],
                      shadowColor: Colors.grey[800],
                      elevation: 0.1,
                      child: ListTile(
                        onTap: () => _showDetails(context),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color.fromARGB(255, 144, 10, 0), width: 1),
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
                                  'https://drive.google.com/uc?export=view&id=${documentSnapshot["image"]}')),
                        ),
                        title: Text("${documentSnapshot["title"]}"),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${documentSnapshot["year"]}'),
                            ]),
                        // ! DELETE ICON
                        trailing: IconButton(
                          onPressed: () async {
                            _bookmarkListUser.doc(documentSnapshot.id).delete();

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Berhasil Menghapus Dari Bookmark')));
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red[800],
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  );
                });
          }

          return const Text('Kamu Belum Menambahkan Bookmark');
        },
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Cari Film',
              elevation: _isVisible ? 0.0 : null,
              backgroundColor: Colors.amber[700],
              child: const Icon(Icons.search),
            )
          : null,
      floatingActionButtonLocation: _fabLocation,
      bottomNavigationBar:
          _DemoBottomAppBar(isElevated: _isElevated, isVisible: _isVisible),
    );
  }
}

// ! NAVIGASI BAWAH

class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar({
    required this.isElevated,
    required this.isVisible,
  });

  final bool isElevated;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isVisible ? 80.0 : 0,
      child: BottomAppBar(
        elevation: isElevated ? null : 0.0,
        color: Colors.red[900],
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(
                Icons.person_2_sharp,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
