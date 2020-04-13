import 'dart:convert';
//import 'package:dio/dio.dart' as dioImport;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import "package:motoclubs/src/utils/constaints.dart";
//import 'package:toast/toast.dart';

//import 'home.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Estamos coletando seus dados de geolocalização. Muito obrigado por colaborar!" ),
              ],
            ),
          ),
        ));
  }

}