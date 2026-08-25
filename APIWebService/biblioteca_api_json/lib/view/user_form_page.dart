import 'package:biblioteca_api_json/controller/user_controller.dart';
import 'package:biblioteca_api_json/model/user_model.dart';
import 'package:flutter/material.dart';

class UserFormPage extends StatefulWidget {
  //atributos
  final UserModel? user; // pode ser nulo
  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  //atributos
  final _formkey =
      GlobalKey<
        FormState
      >(); // armazenas as informações preenchidas no form e permite fazer validações
  final _userController = UserController();
  final _nameInput = TextEditingController();
  final _emailInput = TextEditingController();
  String idUser = "";

  //métodos
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // estou trazendo as informaç~eos do usuários da página anterior , não é uma conexão com a api
    if (widget.user != null) {
      idUser = widget.user!.id!;
      _nameInput.text = widget.user!.name;
      _emailInput.text = widget.user!.email;
    }
  }

  void create() async {
    if (_formkey.currentState!.validate()) {
      final user = UserModel(
        name: _nameInput.text.trim(),
        email: _emailInput.text.trim(),
      );
      try {
        await _userController.create(user);
      } catch (e) {
        //tratar erro
      }
      Navigator.pop(context); //volta para a tela de listagem dos usuários
    }
  }

  void update() async {
    if (_formkey.currentState!.validate()) {
      final user = UserModel(
        id: idUser,
        name: _nameInput.text.trim(),
        email: _emailInput.text.trim(),
      );
      try {
        await _userController.update(user);
      } catch (e) {
        //tratar erro
      }
      Navigator.pop(context); //volta para a tela de listagem dos usuários
    }
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(idUser == "" ? "Novo Usuário" : "Editar Usuário ${_nameInput.text}"),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameInput,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value)=>value!.isEmpty ? "Informe o nome": null,
              ),
              TextFormField(
                controller: _emailInput,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value)=>value!.isEmpty ? "Informe o Email": null,
              ),
              SizedBox(height: 16,),
              ElevatedButton(
                onPressed: widget.user ==null ? create : update,
                child: Text(widget.user == null ? "Salvar" : "Atualizar"))
            ],
          )),),
    );
  }
}
