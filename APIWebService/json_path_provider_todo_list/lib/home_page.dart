import 'package:flutter/material.dart';
import 'package:json_path_provider_todo_list/json_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  List<Map<String, dynamic>> _produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final dados = await JsonHelper.lerArquivo('produtos.json');

    if (dados is List) {
      setState(() {
        _produtos = dados.map<Map<String, dynamic>>((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return {'nome': '', 'valor': 0.0};
        }).toList();
      });
      return;
    }

    setState(() {
      _produtos = [];
    });
  }

  Future<void> _salvarProduto() async {
    final nome = _nomeController.text.trim();
    final valorText = _valorController.text.trim();

    if (nome.isEmpty || valorText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome e valor antes de salvar.')),
      );
      return;
    }

    final valor = double.tryParse(valorText.replaceAll(',', '.'));
    if (valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um valor numérico válido.')),
      );
      return;
    }

    final dados = await JsonHelper.lerArquivo('produtos.json');
    List<dynamic> lista = [];
    if (dados is List) {
      lista = dados;
    }

    lista.add({'nome': nome, 'valor': valor});
    await JsonHelper.salvarArquivo('produtos.json', lista);

    _nomeController.clear();
    _valorController.clear();
    await _carregarProdutos();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos salvos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do produto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valorController,
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
              child: ElevatedButton.icon(
                onPressed: _salvarProduto,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _produtos.isEmpty
                  ? const Center(child: Text('Nenhum produto salvo.'))
                  : ListView.builder(
                      itemCount: _produtos.length,
                      itemBuilder: (context, index) {
                        final produto = _produtos[index];
                        final nome = produto['nome'] ?? '';
                        final valor = produto['valor'] ?? 0.0;

                        return Card(
                          child: ListTile(
                            title: Text(nome),
                            subtitle: Text(
                              'Valor: R\$ ${valor.toStringAsFixed(2)}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
