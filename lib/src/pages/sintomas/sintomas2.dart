import 'package:covid/src/pages/sintomas/sintomas3.dart';
import 'package:covid/src/utils/status.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../home.dart';

class Sintomas2Screen extends StatefulWidget {
  final double peso;
  final int qtdSintomas;

  Sintomas2Screen({Key key, this.peso, this.qtdSintomas}) : super(key: key);

  @override
  _Sintomas2ScreenState createState() => _Sintomas2ScreenState(peso, qtdSintomas);
}
class _Sintomas2ScreenState extends State<Sintomas2Screen> {
  double _peso;
  int _qtdSintomas;
  bool _radioSintomas;

  _Sintomas2ScreenState(this._peso, this._qtdSintomas);

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
                "Apresenta falta de ar?",
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
      _peso += 4;
      _qtdSintomas++;
    }

    if (_peso / _qtdSintomas >= 1.5) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                Sintomas3Screen(
                  peso: _peso,
                  qtdSintomas: _qtdSintomas,
                ),
          ),
              (Route<dynamic> route) => false);
    } else {
      Status.mudarStatus(1, context).then((resposta) {
        if (resposta) {
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
}