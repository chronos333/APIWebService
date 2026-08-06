import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/produtos.json');

    if (!await file.exists()) {
      if (!mounted) return;
      setState(() {});
      return;
    }

    try {
      final contents = await file.readAsString();
      if (contents.isEmpty) {
        if (!mounted) return;
        setState(() {});
        return;
      }

      final decoded = jsonDecode(contents);
      if (decoded is List) {
        if (!mounted) return;
        setState(() {
          _products.clear();
          _products.addAll(
            decoded.map<Map<String, dynamic>>((item) {
              if (item is Map<String, dynamic>) {
                return item;
              }
              return Map<String, dynamic>.from(item as Map);
            }).toList(),
          );
        });
        return;
      }
    } catch (_) {
      // Ignore malformed data and keep the UI responsive.
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(products: _products, onRefresh: _loadProducts),
    );
  }
}
