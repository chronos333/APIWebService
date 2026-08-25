import 'package:biblioteca_api_json/model/book_model.dart';
import 'package:biblioteca_api_json/service/api_service.dart';

class BookController {
  //fetch //read
  Future<List<BookModel>> fetchAll() async {
    final list = await ApiService.getList("books");
    return list.map((item) => BookModel.fromMap(item)).toList();
  }

  //fetchOne //readOne
  Future<BookModel> fetchOne(String id) async {
    final Map<String, dynamic> book = await ApiService.getOne("books", id);
    return BookModel.fromMap(book);
  }

  //create
  Future<BookModel> create(BookModel book) async {
    final map = await ApiService.post("books", book.toMap());
    return BookModel.fromMap(map);
  }

  //update
  Future<BookModel> update(BookModel book) async {
    final map = await ApiService.put("books", book.toMap(), book.id!);
    return BookModel.fromMap(map);
  }

  //delete
  void delete(String id) async{
    await ApiService.delete("books", id);
  }
}
