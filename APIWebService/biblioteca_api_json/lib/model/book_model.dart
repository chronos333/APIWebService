class BookModel {
  String? id;
  String title;
  String author;
  bool available;

   //constructor
  BookModel({
    this.id,
    required this.title,
    required this.author,
    this.available = true,
  });

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'author': author,
      'available': available,
    };
  }

  //factory => constructor alternativo ao constructor principal
  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id']?.toString(),
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      available: map['available'] ?? true,
    );
  }
}