import 'dart:convert';

import 'package:dio/dio.dart' as dioImport;
import 'package:covid/src/pages/home.dart';
import 'package:covid/src/utils/constaints.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocation/geolocation.dart';
import 'package:toast/toast.dart';

//import "package:motoclubs/src/utils/constaints.dart";
//import 'package:toast/toast.dart';

//import 'home.dart';

class AceitarScreen extends StatefulWidget {
  @override
  _AceitarScreenState createState() => _AceitarScreenState();
}

class _AceitarScreenState extends State<AceitarScreen> {
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
            Text(
                "Coletaremos os dados de sua localização constantemente, nenhum dado será utilizado para fins comerciais, muito menos saberemos que é você. Apenas um ID do seu smartphone será coletado para identificação..."),
            Divider(
              color: Colors.black26,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
            ),
            ButtonTheme(
              height: 50,
              child: RaisedButton(
                onPressed: _aceitar,
                child: Text(
                  "Entrar",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.white12,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  _aceitar() async {
    String idDevice;
    String plataforma;
    double latitude;
    double longitude;

    final GeolocationResult result = await Geolocation.requestLocationPermission(
      permission: const LocationPermission(
        android: LocationPermissionAndroid.fine,
        ios: LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );

    if (result.isSuccessful) {
      // location permission is granted (or was already granted before making the request)
      Geolocation.currentLocation(accuracy: LocationAccuracy.best)
          .listen((result) {
        if (result.isSuccessful) {
          latitude = result.location.latitude;
          longitude = result.location.longitude;
        }
      });
    } else {
      // location permission is not granted
      // user might have denied, but it's also possible that location service is not enabled, restricted, and user never saw the permission request dialog. Check the result.error.type for details.
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      idDevice = iosDeviceInfo.identifierForVendor; // unique ID on iOS
      plataforma = "IOS";
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      idDevice = androidDeviceInfo.androidId; // unique ID on Android
      plataforma = "Android";
    }

    String url = new Constaints().URL + "/aceitar";
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsonMap = {
      'idDevice': idDevice,
      'plataforma': plataforma,
      'latitude': latitude,
      'longitude': longitude,
      'horario': new DateTime.now()
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
        final storage = new FlutterSecureStorage();
        await storage.write(key: "token", value: jsonData['token']);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (Route<dynamic> route) => false);
      }
    } on dioImport.DioError catch (e) {
      Toast.show("Erro - $e", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }

    final storage = new FlutterSecureStorage();
    await storage.write(key: "idDevice", value: idDevice);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

}
