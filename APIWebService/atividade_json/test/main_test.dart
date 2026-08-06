import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atividade_json/main.dart';

void main() {
  testWidgets('shows the home screen options', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pump();

    expect(find.text('Cadastro de Produtos'), findsOneWidget);
    expect(find.text('Cadastrar produto'), findsOneWidget);
    expect(find.text('Listar produtos'), findsOneWidget);
  });
}
