import 'package:flutter/material.dart';

import 'product_form_page.dart';
import 'product_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.products, required this.onRefresh});

  final List<Map<String, dynamic>> products;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Produtos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductFormPage()),
                );
                await onRefresh();
              },
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar produto'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductListPage(products: products),
                  ),
                );
                await onRefresh();
              },
              icon: const Icon(Icons.list),
              label: const Text('Listar produtos'),
            ),
          ],
        ),
      ),
    );
  }
}
