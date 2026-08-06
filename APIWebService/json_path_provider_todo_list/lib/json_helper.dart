//Logica de persistencia de dados

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
//importar o path_provider

class JsonHelper {
  //metodo static => metodos da classe e nao do OBJ ( para usar o metodo nao precisa instanciar OBJ)
  // 1. metodo Obter Arquivo json (static)
  static Future<File> _getArquivo() async {
    final diretorio =
        await getApplicationDocumentsDirectory(); //buscando os arquivos do aplicativo
    return File(
      "${diretorio.path}/bd.json",
    ); // retorno o caminho do arquivo json
    //se arquivo nao existir, ele sera criado automaticamente
  }

  // 2. Ler todos os dados do json (converter o json em map)
  static Future<Map<String, dynamic>> lerDados() async {
    try {
      final arquivo = await _getArquivo(); //busco o arquivo
      //verifica se o arquivo existe
      if (await arquivo.exists()) {
        String conteudo = await arquivo.readAsString();
        return json.decode(conteudo);
      }
    } catch (e) {
      print("Erro ao ler o arquivo: $e");
    }
    return {}; //Retorna um Map vazio se nao existir ou der erro
  }

  // 3. Salvar os dados no arquivo json
  static Future<void> salvarDados(Map<String, dynamic> dados) async {
    final arquivo = await _getArquivo(); // pegando logal do arquivo
    String jsonString = json.encode(dados); // transformando MAP em Json
    await arquivo.writeAsString(jsonString);// armazenando os dados no local
  }
}
