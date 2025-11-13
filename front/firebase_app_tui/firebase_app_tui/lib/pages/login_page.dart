import 'package:firebase_app_tui/pages/productos_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  String errorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(MdiIcons.firebase, color: Colors.yellow),
        title: Text('Inicio de sesión', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          child: Column(
            children: [
              campoEmail(),
              campoPassword(),
              botonLogin(),
              mensajeError(),
            ],
          ),
        ),
      ),
    );
  }

  Container mensajeError() {
    return Container(
      child: Text(errorText, style: TextStyle(color: Colors.red)),
    );
  }

  Container botonLogin() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          UserCredential userCredential;
          try {
            userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                  email: emailCtrl.text.trim(),
                  password: passwordCtrl.text.trim(),
                );

            SharedPreferences sp = await SharedPreferences.getInstance();
            sp.setString('user_email', emailCtrl.text.trim());

            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => ProductosPage(),
            );
            Navigator.pushReplacement(context, route);
          } on FirebaseAuthException catch (ex) {
            switch (ex.code) {
              case 'invalid-credential':
                errorText = 'Usuario o contraseña incorrectos';
                break;
              case 'too-many-requests':
                errorText = 'Demasiados intentos, inténtalo más tarde';
                break;
              case 'invalid-email':
                errorText = 'Formato de correo inválido';
                break;
              case 'network-request-failed':
                errorText = 'Problema de red, verifica tu conexión';
                break;
              case 'user-disabled':
                errorText = 'cuenta desactivada';
                break;
              default:
                errorText = 'Error desconocido';
            }

            setState(() {});
          }
        },
        child: Text('Iniciar sesión'),
      ),
    );
  }

  TextFormField campoPassword() {
    return TextFormField(
      controller: passwordCtrl,
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
    );
  }

  TextFormField campoEmail() {
    return TextFormField(
      controller: emailCtrl,
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
