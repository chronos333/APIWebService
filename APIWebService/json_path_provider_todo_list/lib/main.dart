import 'package:flutter/material.dart';
import 'package:json_path_provider_todo_list/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Cadastro de Produtos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const HomePage(),
    ),
  );
}
