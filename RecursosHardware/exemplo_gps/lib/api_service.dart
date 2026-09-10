//permitir a conexão com aPI de Clima
// biblioteca http -> flutter pub add http

import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ApiService{
  String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  String chaveApi = "dbca375f11f06d261d80c67effaae5fb";

  Future<Map<String, dynamic>> getClimaLocation(Position position) async{
    // URL +Request Params
    final response = await http.get(Uri.parse("$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$chaveApi"));

    if(response.statusCode ==200){
      return jsonDecode(response.body);
    }else{
      throw Exception("Falha de Conexão com API");
    }
  }
}