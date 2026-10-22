import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //atributos
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  //método para realizar o login
  Future<void> _signin() async{
    try {
      //tenta a conexão com email e senha
      await _auth.signInWithEmailAndPassword(
        email: _email.text, 
        password: _senha.text);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha de Autenticação: ${e.message}"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}