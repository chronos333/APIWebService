import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();

  Future<void> _saveProduct() async {
    final name = _nameController.text.trim();
    final valueText = _valueController.text.trim().replaceAll(',', '.');

    if (name.isEmpty || valueText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome e valor antes de salvar.')),
      );
      return;
    }

    final parsedValue = double.tryParse(valueText);
    if (parsedValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um valor numérico válido.')),
      );
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/produtos.json');

    List<Map<String, dynamic>> products = [];
    if (await file.exists()) {
      final contents = await file.readAsString();
      if (contents.isNotEmpty) {
        final decoded = jsonDecode(contents);
        if (decoded is List) {
          products = decoded.map<Map<String, dynamic>>((item) {
            if (item is Map<String, dynamic>) {
              return item;
            }
            return Map<String, dynamic>.from(item as Map);
          }).toList();
        }
      }
    }

    products.add({'nome': name, 'valor': parsedValue});
    await file.writeAsString(jsonEncode(products));

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar produto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do produto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProduct,
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
