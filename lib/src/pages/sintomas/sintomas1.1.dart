import 'dart:convert';

import 'package:covid/src/pages/sintomas/sintomas1.dart';
import 'package:covid/src/pages/sintomas/sintomas2.dart';
import 'package:covid/src/utils/constaints.dart';
import 'package:covid/src/utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart' as dioImport;

import '../home.dart';

class Sintomas11Screen extends StatefulWidget {
  final double peso;
  final int qtdSintomas;

  Sintomas11Screen({Key key, this.peso, this.qtdSintomas}) : super(key: key);

  @override
  _Sintomas11ScreenState createState() => _Sintomas11ScreenState(peso, qtdSintomas);
}
class _Sintomas11ScreenState extends State<Sintomas11Screen> {
  double _peso;
  int _qtdSintomas;
  bool _radioSintomas;
  _Sintomas11ScreenState(this._peso, this._qtdSintomas);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informar Sintomas"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(0, 80, 0, 0)),
              new Text(
                "Apresenta uma tosse seca?",
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
          new Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
          new Row(
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
              new Text("Sim"),
              new Radio(
                value: true,
                groupValue: _radioSintomas,
                onChanged: (bool value) {
                  setState(() {
                    _radioSintomas = value;
                  });
                },
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
              new Text("Nao"),
              new Radio(
                value: false,
                groupValue: _radioSintomas,
                onChanged: (bool value) {
                  setState(() {
                    _radioSintomas = value;
                  });
                },
              ),
            ],
          ),
          new Padding(padding: EdgeInsets.fromLTRB(0, 200, 0, 0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                onPressed: calcularPeso,
                child: Text(
                  "Avançar",
                  style: TextStyle(fontSize: 20),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.lightBlue)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void calcularPeso() {
    if (_radioSintomas) {
      _peso +=  1;
    }else{
      _peso -=  1;
    }


    if (_peso / _qtdSintomas >= 1.5) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Sintomas2Screen(
              peso: _peso,
              qtdSintomas: _qtdSintomas,
            ),
          ),
              (Route<dynamic> route) => false);
    }else{
      _Sintomas11ScreenState.mudarStatus(1, context).then((resposta){
        if (resposta){
          Toast.show(
              "Te monitoraremos nos proximos dias sobre a evoluçao dos sintomas!",
              context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
                  (Route<dynamic> route) => false);
        }
      });
    }
  }

  static Future<bool> mudarStatus(int status, BuildContext context) async {
    final storage = new FlutterSecureStorage();
    String token = await storage.read(key: "token");

    String url = new Constaints().URL + "/atualizarStatus";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "authorization": "Bearer $token"
    };
    Map<String, dynamic> jsonMap = {
      'status': status,
    };

    dioImport.Response response;
    dioImport.Dio dio = new dioImport.Dio();

    try {
      response = await dio.post(url,
          data: jsonMap, options: dioImport.Options(headers: headers));

      int statusCode = response.statusCode;
      var jsonData = json.decode(response.toString());

      print(jsonData);

      if (statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on dioImport.DioError catch (e) {
      print(e);
      Toast.show("Erro - $e", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return false;
    }
  }
}