import 'package:flutter/material.dart';

void main(List<String> args) {
  //WidgetFlutterBinding => Garente que os bindings do flutter esteja inicializados
  //inicializa os pacotes nativos do flutter logo no começo da aplicação
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Gerenciador de Tarefas com JSON" ,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.pink,
      //Tema padrão
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        elevation: 2, //
      ),
    ),
    home: UsuarioPage(),
  ));
}

Widget? UsuarioPage() {
}