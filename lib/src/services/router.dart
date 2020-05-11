import 'package:covid/src/pages/aceitar.dart';
import 'package:covid/src/pages/home.dart';
import 'package:covid/src/pages/sintomas/sintomas1.dart';
import 'package:flutter/material.dart';

class Router {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/sintomas1':
        return MaterialPageRoute(builder: (_) => Sintomas1Screen());

      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case '/aceitar':
        return MaterialPageRoute(builder: (_) => AceitarScreen());
    }
  }
}
