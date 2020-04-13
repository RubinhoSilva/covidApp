import 'package:covid/src/pages/aceitar.dart';
import 'package:covid/src/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as key;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = new key.FlutterSecureStorage();
  String idDevice = await storage.read(key: "idDevice");

  print(idDevice);
  if(idDevice != null){
    //logado
    runApp(
      new MaterialApp(
        home: new HomeScreen(),
      ),
    );
  }else{
    //tela de logar
    runApp(
      new MaterialApp(
        home: new AceitarScreen(),
      ),
    );
  }

}