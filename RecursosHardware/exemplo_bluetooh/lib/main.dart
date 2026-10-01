//Exemplo de Uso do Bluetooth => com uso do Stream no corpo da Aplicação

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //método

  //Iniciar o Scaneamento do BlueTooth
  void _startScan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dispositivos BlueTooth"),
        actions: [IconButton(onPressed: _startScan, icon: Icon(Icons.refresh))],
      ),
      // 1º Stream para Verificar a Conexão
      body: StreamBuilder<bool>(
        stream: FlutterBluePlus.isScanning,
        initialData: false,
        builder: (context, snapshot) {
          final isScanning =
              snapshot.data ??
              false; //verifico se o resultado é null e caso null transforma em false(Coalescencia nula)
          //2º Stream: Monitorar os dispositivos encontrados
          return StreamBuilder<List<ScanResult>>(
            stream: FlutterBluePlus.scanResults,
            initialData: [],
            builder: (context, snapshotResult) {
              final dispositivos = snapshotResult.data ?? [];
              //montar lista de dispositivos
              if (isScanning && dispositivos.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else if (dispositivos.isEmpty) {
                return Center(child: Text("Lista Vazia"));
              } else {
                return ListView.builder(
                  itemCount: dispositivos.length,
                  itemBuilder: (context, index) {
                    final item = dispositivos[index];
                    final name = item.device.platformName.isNotEmpty
                        ? item.device.platformName
                        : "Dispositivos generico";
                    return ListTile(
                      title: Text(name),
                      subtitle: Text(item.device.remoteId.str),
                      trailing: Text("${item.rssi} dBm"),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
