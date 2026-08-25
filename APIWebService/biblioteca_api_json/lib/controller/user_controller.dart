// classe controller => dica: SlimController

import 'package:biblioteca_api_json/model/user_model.dart';
import 'package:biblioteca_api_json/service/api_service.dart';

class UserController {
  //não precisa criar um obj da classe ApiService ( Static)

  //métodos

  //fetch //read
  Future<List<UserModel>> fetchAll() async {
    final list = await ApiService.getList("users"); //estabelece a conexão
    return list
        .map((item) => UserModel.fromMap(item))
        .toList(); // transforma o resulta em uma lista de objetos
  }

  //fetchOne //readOne
  Future<UserModel> fetchOne(String id) async {
    Map<String, dynamic> user = await ApiService.getOne("users", id);
    return UserModel.fromMap(user);
  }

  //create
  Future<UserModel> create(UserModel user) async {
    final Map = await ApiService.post("users", user.toMap());
    return UserModel.fromMap(Map);
  }

  //update
  Future<UserModel> update(UserModel user) async {
    final map = await ApiService.put(
      "users",
      user.toMap(),
      user.id!,
    ); // qual a diferencça entre ! e ??
    //!: força o valor a ser nulo, ??: tem um valor reserva caso seja nulo
    return UserModel.fromMap(map);
  }

  // delete
  void delete(String id) async {
    await ApiService.delete("users", id);
  }
}
