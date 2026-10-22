import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> funcionario;

  const HomePage({
    super.key,
    required this.funcionario,
  });

  Future<void> _sair(BuildContext context) async {
    await AuthService().logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final nome = funcionario['nome']?.toString() ?? 'Funcionário';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Ponto'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () => _sair(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 42,
                child: Icon(Icons.person, size: 48),
              ),
              const SizedBox(height: 20),
              Text(
                'Olá, $nome!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Seu acesso foi realizado com sucesso.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text('Registro de ponto'),
                  subtitle: Text('Será implementado na próxima etapa.'),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Histórico de registros'),
                  subtitle: Text('Será implementado na próxima etapa.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}