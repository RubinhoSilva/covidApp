import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:covid/src/utils/constaints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocation/geolocation.dart';
import 'package:haversine/haversine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dioImport;
import 'package:toast/toast.dart';

void backgroundFetchHeadlessTask(String taskId) async {
  print("[BackgroundCovidZero] Headless event received: $taskId");

  SharedPreferences prefs = await SharedPreferences.getInstance();
  double latitudeAntiga = prefs.getDouble(Constaints().LATITUDE);
  double longitudeAntiga = prefs.getDouble(Constaints().LONGITUDE);

  print(latitudeAntiga);
  print(longitudeAntiga);

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
        .listen((result) async {
      if (result.isSuccessful) {
        double latitude = result.location.latitude;
        double longitude = result.location.longitude;
        print(latitude);

        final harvesine = new Haversine.fromDegrees(
            latitude1: latitudeAntiga,
            longitude1: longitudeAntiga,
            latitude2: latitude,
            longitude2: longitude);

        print(harvesine.distance());

        if (harvesine.distance() > 10) {
          prefs.setDouble(Constaints().LATITUDE, latitude);
          prefs.setDouble(Constaints().LONGITUDE, longitude);

          final storage = new FlutterSecureStorage();
          String token = await storage.read(key: "token");

          String url = new Constaints().URL + "/atualizarLocalizacao";
          Map<String, String> headers = {
            "Content-type": "application/json",
            "authorization": "Bearer $token"
          };
          Map<String, dynamic> jsonMap = {
            'latitude': latitude,
            'longitude': longitude,
            'horario': new DateTime.now().toString()
          };

          print(latitude);

          dioImport.Response response;
          dioImport.Dio dio = new dioImport.Dio();

          try {
            response = await dio.post(url,
                data: jsonMap, options: dioImport.Options(headers: headers));

            int statusCode = response.statusCode;
            var jsonData = json.decode(response.toString());

            print(jsonData);
          } on dioImport.DioError catch (e) {
            print(e);
          }
        }
      }
    });
  } else {
    // location permission is not granted
    // user might have denied, but it's also possible that location service is not enabled, restricted, and user never saw the permission request dialog. Check the result.error.type for details.
  }

  BackgroundFetch.finish(taskId);

  if (taskId == 'background_CovidZero') {
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "com.transistorsoft.customtask",
        delay: 5000,
        periodic: false,
        forceAlarmManager: true,
        stopOnTerminate: false,
        enableHeadless: true));
  }
}

void main() {
  runApp(new HomeScreen());

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

    // Configure BackgroundFetch.
    BackgroundFetch.configure(
            BackgroundFetchConfig(
              minimumFetchInterval: 5,
              forceAlarmManager: true,
              stopOnTerminate: false,
              startOnBoot: true,
              enableHeadless: true,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.ANY,
            ),
            _onBackgroundFetch)
        .then((int status) {
      print('[BackgroundCovidZero] configure success: $status');
    }).catchError((e) {
      print('[BackgroundCovidZero] configure ERROR: $e');
    });

    // Schedule a "one-shot" custom-task in 10000ms.
    // These are fairly reliable on Android (particularly with forceAlarmManager) but not iOS,
    // where device must be powered (and delay will be throttled by the OS).
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "com.transistorsoft.customtask",
        delay: 10000,
        periodic: false,
        forceAlarmManager: true,
        stopOnTerminate: false,
        enableHeadless: true));
  }

  void _onBackgroundFetch(String taskId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime timestamp = new DateTime.now();
    // This is the fetch-event callback.
    print("[BackgroundCovidZero] Event received: $taskId");

    if (taskId == "background_CovidZero") {
      // Schedule a one-shot task when fetch event received (for testing).
      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "com.transistorsoft.customtask",
          delay: 5000,
          periodic: false,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true));
    }

    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }

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
                "Estamos coletando seus dados de geolocalização. Muito obrigado por colaborar!"),
          ],
        ),
      ),
    ));
  }
}
