//Logica de persistencia de dados

import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';

class JsonHelper {
  static Future<Map<String, dynamic>> lerDados([
    String nomeArquivo = 'bd.json',
  ]) async {
    try {
      final valor = window.localStorage[nomeArquivo];
      if (valor == null || valor.trim().isEmpty) {
        window.localStorage[nomeArquivo] = json.encode({});
        return {};
      }

      final decoded = json.decode(valor);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (e) {
      debugPrint('Erro ao ler o arquivo $nomeArquivo: $e');
    }
    return {};
  }

  static Future<dynamic> lerArquivo([
    String nomeArquivo = 'produtos.json',
  ]) async {
    try {
      final valor = window.localStorage[nomeArquivo];
      if (valor == null || valor.trim().isEmpty) {
        window.localStorage[nomeArquivo] = json.encode([]);
        return [];
      }
      return json.decode(valor);
    } catch (e) {
      debugPrint('Erro ao ler o arquivo $nomeArquivo: $e');
    }
    return [];
  }

  static Future<void> salvarDados(
    Map<String, dynamic> dados, [
    String nomeArquivo = 'bd.json',
  ]) async {
    try {
      window.localStorage[nomeArquivo] = json.encode(dados);
    } catch (e) {
      debugPrint('Erro ao salvar o arquivo $nomeArquivo: $e');
    }
  }

  static Future<void> salvarArquivo(String nomeArquivo, dynamic dados) async {
    try {
      window.localStorage[nomeArquivo] = json.encode(dados);
    } catch (e) {
      debugPrint('Erro ao salvar o arquivo $nomeArquivo: $e');
    }
  }
}
