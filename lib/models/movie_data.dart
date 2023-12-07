class MovUser{

  final String? genre;
  final int? bookmarkTotal;

  MovUser({this.genre, this.bookmarkTotal});

}

class MoviesData{
  final String? title;
  final String? synopsis;
  final int? year;
  final int? rate;
  final String? image;

  MoviesData({required this.title, this.synopsis, this.year, this.rate, this.image});
}