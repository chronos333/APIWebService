import 'user_model.dart';
import 'book_model.dart';

class LoanModel {
  String? id;
  UserModel user;
  BookModel book;
  DateTime startDate;
  DateTime dueDate;
  bool returned;

   //constructor
  LoanModel({
    this.id,
    required this.user,
    required this.book,
    required this.startDate,
    required this.dueDate,
    required this.returned
  });

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': user.id,
      'bookId': book.id,
      'startDate': startDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returned': returned,
    };
  }

  //factory => constructor alternativo ao constructor principal
  factory LoanModel.fromMap(
    Map<String, dynamic> map, {
    required UserModel user,
    required BookModel book,
  }) {
    return LoanModel(
      id: map['id'].toString(),
      user: user, // UserModel.fromMap(map["user"])
      book: book,// BookModel.fromMap(map["book"])
      startDate: DateTime.parse(map['startDate'].toString()),
      dueDate: DateTime.parse(map['dueDate'].toString()),
      returned: map['returned'] == true ? true : false,
    );
  }
}