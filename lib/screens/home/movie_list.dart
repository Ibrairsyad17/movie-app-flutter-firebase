import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_data.dart';
import 'package:movie_app/screens/home/movie_tile.dart';
import 'package:provider/provider.dart';

class MoviesList extends StatefulWidget {
  const MoviesList({super.key});

  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  @override
  Widget build(BuildContext context) {
    
    final movies = Provider.of<List<MoviesData>>(context);

    // movies.forEach((movie) {
    //   print(movie.title);
    //   print(movie.synopsis);
    //   print(movie.year);
    //   print(movie.rate);
      
    // });

    return ListView.builder(
      itemCount: movies.length,
      padding: EdgeInsets.all(20.0),
      itemBuilder: (context, index){
        return MovieTile(movie: movies[index]);
      },
    );
    
  }
}
