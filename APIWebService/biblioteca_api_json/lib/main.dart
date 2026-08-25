import 'package:biblioteca_api_json/view/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    title: "Biblioteca App Api",
    theme: ThemeData(primarySwatch: Colors.blueGrey),
    home: HomePage(),
  ));
}