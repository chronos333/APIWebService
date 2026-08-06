import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key, required this.products});

  final List<Map<String, dynamic>> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos salvos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: products.isEmpty
            ? const Center(child: Text('Nenhum produto salvo ainda.'))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final name = product['nome'] as String;
                  final value = product['valor'];

                  return Card(
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text(
                        'Valor: R\$ ${value is double ? value.toStringAsFixed(2) : value}',
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
