import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart' as dioImport;
import 'package:toast/toast.dart';
import 'constaints.dart';

class Status {

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