import 'package:flutter/material.dart';
import 'package:json_path_provider_todo_list/json_helper.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  Map<String,dynamic> _baseUsuarios = {};
  //controlar um um input de texto
  final TextEditingController _nomeUsuario = TextEditingController();

  //initState
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregarUsuarios();
  }

  //carregar os usuários
  void _carregarUsuarios() async{
    final dados = await JsonHelper.lerDados();
    setState(() {
      _baseUsuarios = dados;
    });

  }


  //salvar novo usuário
  void _salvarUsuario() async{
    String nome = _nomeUsuario.text.trim();
    if(nome.isNotEmpty && !_baseUsuarios.containsKey(nome)){
      setState(() {
        _baseUsuarios[nome]=[]; // Cria um usuário com uma lista de tarefas vazia
      });
      JsonHelper.salvarDados(_baseUsuarios);
      _nomeUsuario.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    //pegar os nomes do json
    List<String> usuarios = _baseUsuarios.keys.toList();
    return Scaffold(
      appBar: AppBar(title: Text("Selecione um Usuário"),),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                TextField(
                  controller: _nomeUsuario,
                  decoration: InputDecoration(labelText: "Novo Usuário"),
                ),
                IconButton(
                  onPressed: _salvarUsuario, 
                  icon: Icon(Icons.add, color: Colors.green,))
              ],
            ),
            //Expanded com a Lista de Usuários Cadastrados
            Expanded(child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context,index){
                String usuario = usuarios[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(usuario[0]),),//bola com a primeira Letra do Nome do Usuário
                  title: Text(usuario),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    //navegar para a tela de Tarefas
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TarefasPage(
                      //vai levar informaç~eos do usuário para a página de tarefas
                      nomeUsuario: usuario,
                      db: _baseUsuarios

                    ))).then((value) => _carregarUsuarios()); //atualiza a lista de usuários ao voltar para a página
                  },
                );
              }))
          ],
        ),),
    );
  }
}