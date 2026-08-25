import 'package:biblioteca_api_json/model/loan_model.dart';
import 'package:biblioteca_api_json/service/api_service.dart';

class BookController {
  //fetch //read
  Future<List<LoanModel>> fetchAll() async {
    final list = await ApiService.getList("loans");
    return list.map((item) => LoanModel.fromMap(item)).toList();
  }

  //fetchOne //readOne
  Future<LoanModel> fetchOne(String id) async {
    final Map<String, dynamic> loan = await ApiService.getOne("loans", id);
    return LoanModel.fromMap(loan);
  }

  //create
  Future<LoanModel> create(LoanModel loan) async {
    final map = await ApiService.post("loans", loan.toMap());
    return LoanModel.fromMap(map);
  }

  //update
  Future<LoanModel> update(LoanModel loan) async {
    final map = await ApiService.put("loans", loan.toMap(), loan.id!);
    return LoanModel.fromMap(map);
  }

  //delete
  void delete(String id) async{
    await ApiService.delete("loans", id);
  }
}
