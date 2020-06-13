import 'dart:io';
import 'package:covid/src/pages/sintomas/sintomas1.dart';
import 'package:covid/src/services/service_locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'navigator.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final NavigationService _navigationService = locator<NavigationService>();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onLaunch: (Map<String, dynamic> message) async {
        _navegar(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _navegar(message);
      },
    );
  }

  void _navegar(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    print("entrou");
    print(message['data']);

    if (view != null) {
      // Navigate to the create post view
      if (view == 'sintomas') {
        _navigationService.navigateTo("/sintomas1");
      }
      // If there's no view it'll just open the app on the first view
    }
  }
}