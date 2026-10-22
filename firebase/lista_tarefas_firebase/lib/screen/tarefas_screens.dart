//Tela e exibição das tarefas
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  //atributos
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser; // pega dados do usuário atual autenticado
  final TextEditingController _tarefaController = TextEditingController();

  //CRUD de tarefas
  //Adicionar Tarefas
  Future<void> _addTarefa() async{
    if(_tarefaController.text.isNotEmpty && _user != null){
      await _db.collection("users")
        .doc(_user.uid)
          .collection("tarefas")
            .add({
              "titulo": _tarefaController.text,
              "concluida": false,
              "criadaEm": Timestamp.now()
            });
      _tarefaController.clear();
      Navigator.pop(context); //fecha o alertDialog
    }
  }

  //Método para Atualizar Tarefas
  Future<void> _mudarTarefa(String tarefaId, bool currenteStatus) async{
    if(_user != null){
      await _db.collection("users")
                  .doc(_user.uid)
                    .collection("tarefas")
                      .doc(tarefaId)
                        .update({"concluida":!currenteStatus});
    }
  }

  //Método para Deletar Tarefa
    Future<void> _deletarTarefa(String tarefaId) async{
    if(_user != null){
      await _db.collection("users")
                  .doc(_user.uid)
                    .collection("tarefas")
                      .doc(tarefaId)
                        .delete();
    }
  }

  //método para exibir a caixa de dialogo de criação da tarefa
  void _showAddTarefaDialog(){
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Nova Tarefa"),
          content: TextField(
            controller: _tarefaController,
            autofocus: true,
            decoration: InputDecoration(labelText: "Nome da Tarefa"),
          ),
          actions: [
            //dois botoes
            TextButton(
              onPressed: ()=>Navigator.pop(context), 
              child: Text("Cancelar")),
            ElevatedButton(
              onPressed: _addTarefa, 
              child: Text("Adicionar"))
          ],
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Tarefas"),
        actions: [
          IconButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
            }, 
            icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection("users")
                      .doc(_user?.uid)
                        .collection("tarefas")
                          .orderBy("criadaEm",descending: true)
                            .snapshots(), 
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
            return Center(child: Text("Nenhuma tarefa encontrada!"));
          }
          //qualquer outra situação
          var tarefas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, index){
              var tarefa = tarefas[index]; //json puro
              //Mapeamento das Informações
              var tarefaData = tarefa.data() as Map<String,dynamic>;
              bool concluida = tarefaData["concluida"] ?? false;
              return ListTile(
                title: Text(tarefaData["titulo"], style: TextStyle(
                  decoration: concluida ?
                  TextDecoration.lineThrough :
                  TextDecoration.none
                ),),
                leading: Checkbox(
                  value: concluida, 
                  onChanged: (bool? value){_mudarTarefa(tarefa.id, concluida);}),
                trailing: IconButton(
                  onPressed: ()=> _deletarTarefa(tarefa.id), 
                  icon: Icon(Icons.delete)),
              );
            });
        }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTarefaDialog,
        child: Icon(Icons.add),),
    );
  }
}