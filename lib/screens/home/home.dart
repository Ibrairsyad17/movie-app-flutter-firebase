import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_app/models/movie_data.dart';
import 'package:movie_app/screens/home/bookmark.dart';
import 'package:movie_app/screens/home/movie_list.dart';
import 'package:movie_app/screens/home/profile.dart';
import 'package:movie_app/screens/home/search.dart';
import 'package:movie_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/services/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
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

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: StreamProvider<List<MoviesData>?>.value(
        initialData: [],
        value: DBServices(uid: '').movies,

        // ! APPBAR------>

        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[900],
            centerTitle: true,
            title: Text('Daftar Film', style: TextStyle(
                fontSize: 20.0,
                color: Colors.red[800],
                fontWeight: FontWeight.bold
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () async{
                  await _auth.signOut();
                }, 
                icon: Icon(Icons.logout_outlined),
                iconSize: 30.0,
                color: Colors.amber,
              )
            ],
          ),

          // ! FILM CARD >>>>>

          body: MoviesList(),
          backgroundColor: Colors.grey[900],
          floatingActionButton: _showFab
              ? FloatingActionButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) => SearchPage())),
                  tooltip: 'Cari Film',
                  elevation: _isVisible ? 0.0 : null,
                  backgroundColor: Colors.amber[700],
                  child: const Icon(Icons.search),
                )
              : null,
          floatingActionButtonLocation: _fabLocation,
          bottomNavigationBar:
              _DemoBottomAppBar(isElevated: _isElevated, isVisible: _isVisible),
        ),
      ),
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
            // * PROFIL --->
            
            IconButton(
              tooltip: 'Profil Kamu',
              icon: const Icon(Icons.person_2_sharp, color: Colors.white,),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) => ProfileDetail())),
            ),
            
            // * BOOKMARK --->
            IconButton(
              tooltip: 'Bookmark',
              icon: const Icon(Icons.bookmark, color: Colors.white),
              onPressed: () => Navigator.of(context).push( MaterialPageRoute(builder: (BuildContext context) => const BookmarkCon())),
            ),
          ],
        ),
      ),
    );
  }
}