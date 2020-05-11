import 'package:covid/src/pages/aceitar.dart';
import 'package:covid/src/pages/home.dart';
import 'package:covid/src/pages/sintomas/sintomas1.dart';
import 'package:covid/src/services/router.dart';
import 'package:covid/src/services/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as key;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  final storage = new key.FlutterSecureStorage();
  String idDevice = await storage.read(key: "idDevice");

  print(idDevice);
  if(idDevice != null){
    //logado
    runApp(
      new MaterialApp(
        routes: <String, WidgetBuilder>{
          '/home': (context) => HomeScreen(),
          '/aceitar': (context) => AceitarScreen(),
          '/sintomas1': (context) => Sintomas1Screen(),
        },
        initialRoute: '/home',
      ));
  }else{
    //tela de logar
    runApp(
      new MaterialApp(
        routes: <String, WidgetBuilder>{
          '/home': (context) => HomeScreen(),
          '/aceitar': (context) => AceitarScreen(),
          '/sintomas1': (context) => Sintomas1Screen(),
        },
        initialRoute: '/aceitar',
      ),
    );
  }

}