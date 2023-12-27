import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:movie_app/screens/home/profile_page.dart';
import 'package:movie_app/screens/home/search.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

String idEdit = '';

class _ProfileDetailState extends State<ProfileDetail> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // ! APP BAR
      appBar: AppBar(
        leading: IconButton(
          // * KEMBALI
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.red[800],
        ),
        backgroundColor: Colors.grey[900],
        title: Text(
          'Profil Kamu',
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.red[800],
              fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userProfile')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            // ! TAMPIL PROFIL
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  idEdit = documentSnapshot.id;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    child: Card(
                      color: Colors.grey[900],
                      shadowColor: Colors.grey[800],
                      elevation: 0.1,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProfileEdit(id: idEdit)));
                        },
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
                                  '${documentSnapshot['imageLink']}')),
                        ),
                        title: Text("${documentSnapshot["name"]}"),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${documentSnapshot["genre"]}'),
                            ]),
                        trailing: IconButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProfileEdit(
                                        id: idEdit,
                                      ))),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.red[800],
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  );
                });
          }
          return const Text('Kamu Belum Menambahkan Profile');
        },
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SearchPage())),
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
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileEdit(
                            id: idEdit,
                          ))),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(18.0),
                  elevation: 2.0,
                  shape: StadiumBorder(),
                  backgroundColor: Colors.amber[500]),
              child: Text(
                'Edit Atau Tambah Profil',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
