import 'package:biblioteca_api_json/view/book_list_page.dart';
import 'package:biblioteca_api_json/view/loan_list_page.dart';
import 'package:biblioteca_api_json/view/user_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //lista de páginas para navegação
  final List<Widget> _pages = const[
    BookListPage(),
    UserListPage(),
    LoanListPage()
  ];
  int _indexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_indexPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexPage,
        // permite a navegação ao clicar no icone de cada página
        onTap: (index) => setState(() => _indexPage = index,),
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Livros"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Usuários"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Empréstimos"),
        ]),
    );
  }
}