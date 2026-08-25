import 'package:biblioteca_api_json/controller/user_controller.dart';
import 'package:biblioteca_api_json/model/user_model.dart';
import 'package:biblioteca_api_json/view/user_form_page.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  //atributos
  List<UserModel> _users = [];
  List<UserModel> _filterUser = [];
  final _userSearch = TextEditingController(); //controlador de Input
  String _error = "";
  bool _isLoading = true;

  final _userController = UserController();

  //métodos

  //método para carregar informações antes do build da página
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load();
  }

  void _load() async{ //Renderização ao Lado do Servidor (back) SSR
    setState(() {
      _isLoading = true;
    });
    //estabelecer conexão com a api (request)
    try {
      _users = await _userController.fetchAll();
      _filterUser = _users;
    } catch (e) {
      //tratar o erro
      _error = e.toString();
    }
    setState(() {
      _isLoading = false;
    });
  }

  //método para filtar usuários
  void _usersFiltered(){ // renderização ao lado do Cliente(front) CSR
    final busca = _userSearch.text.trim().toLowerCase();// joguei para minusculo e tirei os espaços
    setState(() {
      //fazer um filtro por partes do nome ou partes do email
      _filterUser = _users.where((user){
        return user.name.toLowerCase().contains(busca) || user.email.toLowerCase().contains(busca);
      }).toList();
    });
  }

  //deletar usuário
  void delete(UserModel user) async{
    final confirm = await showDialog(
      context: context, 
      builder: (context)=> AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Deseja realmente excluir o usuário ${user.name}"),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(context,false), child: Text("Cancelar")),
          TextButton(onPressed: ()=>Navigator.pop(context,true), child: Text("Excluir"))
        ],
      ));
      //depois de fechar o alert Dialog
      if(confirm) {
        try {
          _userController.delete(user.id!);
        } catch (e) {
          _error = e.toString();
        }
      }
  }

  //método de navegação para a tela de Formulário
  void _operForm({UserModel? user}) async{
    await Navigator.push(context, MaterialPageRoute(builder: (context)=>UserFormPage(user:user)));
    _load();// atualiza os dados dos usuários
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Usuários"),),
      body: _isLoading 
      ? Center(child: CircularProgressIndicator(),)
      : _error!="" ? Center(child: Text(_error),)
      : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _userSearch,
              decoration: InputDecoration(
                labelText: "Pesquisar Usuário",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 16,),
            Expanded(child: ListView.builder(
              itemCount: _filterUser.length,
              itemBuilder: (context,index){
                final user = _filterUser[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: IconButton(onPressed: ()=> delete(user), icon: Icon(Icons.delete), color: Colors.red,),
                  leading: IconButton(onPressed: ()=> _operForm(user:user), icon: Icon(Icons.edit)),
                );
              }))
          ],
        ),),
      floatingActionButton: FloatingActionButton(onPressed: ()=>_operForm(), child: Icon(Icons.add),),
    );
  }
}