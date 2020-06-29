import 'dart:convert';

import 'package:covid/src/pages/home.dart';
import 'package:covid/src/pages/sintomas/sintomas1.1.dart';
import 'package:covid/src/pages/sintomas/sintomas2.dart';
import 'package:covid/src/utils/constaints.dart';
import 'package:covid/src/utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart' as dioImport;

class Sintomas1Screen extends StatefulWidget {
  @override
  _Sintomas1ScreenState createState() => _Sintomas1ScreenState();
}

class _Sintomas1ScreenState extends State<Sintomas1Screen> {
  bool febre = false;
  bool tosse = false;
  bool fadiga = false;
  bool dorCabeca = false;
  bool dorGarganta = false;

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
                "Apresenta algum dos sintomas abaixo?",
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
          new Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
          new Row(
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
              Text("Febre"),
              Checkbox(
                value: febre,
                onChanged: (bool value) {
                  setState(() {
                    febre = value;
                  });
                },
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
              Text("Tosse"),
              Checkbox(
                value: tosse,
                onChanged: (bool value) {
                  setState(() {
                    tosse = value;
                  });
                },
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
              Text("Fadiga"),
              Checkbox(
                value: fadiga,
                onChanged: (bool value) {
                  setState(() {
                    fadiga = value;
                  });
                },
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
              Text("Dor de cabeça"),
              Checkbox(
                value: dorCabeca,
                onChanged: (bool value) {
                  setState(() {
                    dorCabeca = value;
                  });
                },
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
              Text("Dor de garganta"),
              Checkbox(
                value: dorGarganta,
                onChanged: (bool value) {
                  setState(() {
                    dorGarganta = value;
                  });
                },
              ),
            ],
          ),
          new Padding(padding: EdgeInsets.fromLTRB(0, 150, 0, 0)),
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
    double soma = 0;
    double peso;
    int qtd = 0;

    if (febre) {
      soma = soma + 2;
      qtd++;
    }

    if (tosse) {
      soma += 2;
      qtd++;
    }

    if (fadiga) {
      soma += 0.5;
      qtd++;
    }

    if (dorCabeca) {
      soma += 0.5;
      qtd++;
    }

    if (dorGarganta) {
      soma += 0.5;
      qtd++;
    }

    peso = soma / qtd;

    if (tosse) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                Sintomas11Screen(peso: peso, qtdSintomas: qtd),
          ),
          (Route<dynamic> route) => false);
    } else if (peso >= 1.5) {
      //verifica peso e manda para a proxima tela
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Sintomas2Screen(peso: peso, qtdSintomas: qtd),
          ),
          (Route<dynamic> route) => false);
    } else {
      Status.mudarStatus(1, context).then((resposta){
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
