import 'package:flutter/material.dart';
import 'package:flutter_application_1/vistas/Login/LoginView.dart';
import 'package:flutter_application_1/vistas/Login/CambiarPass.dart';
import 'package:flutter_application_1/vistas/Login/CrearCuenta.dart';
import 'package:flutter_application_1/vistas/HomePage.dart';
import 'package:flutter_application_1/constants/app_colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/' ||
            settings.name == '/cambiar-pass' ||
            settings.name == '/crear-cuenta' ||
            settings.name == '/home') {
          return MaterialPageRoute(
            builder: (context) {
              switch (settings.name) {
                case '/cambiar-pass':
                  return CambiarPass();
                case '/crear-cuenta':
                  return CrearCuenta();
                case '/home':
                  return HomePage();
                default:
                  return LoginView();
              }
            },
          );
        }
        return MaterialPageRoute(builder: (context) => LoginView());
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
      ),
    );
  }
}
