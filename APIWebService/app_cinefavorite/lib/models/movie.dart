class Movie {
  final int id;
  final String title;
  final String? posterPath;
  double rating;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.rating = 0,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'] ?? map['name'] ?? '',
      posterPath: map['poster_path'],
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'rating': rating,
    };
  }
}