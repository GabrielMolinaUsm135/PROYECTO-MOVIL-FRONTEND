import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
 

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 340, maxWidth: 370),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: const [
                        Icon(Icons.person, size: 48, color: Colors.black),
                        SizedBox(height: 8),
                        Text('Iniciar Sesión', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                      ],
                    ),
                    const SizedBox(height: 18),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Correo',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              hintText: 'Contraseña',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/home'),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('Entrar'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/cambiar-pass'),
                                style: TextButton.styleFrom(foregroundColor: primaryColor),
                                child: const Text('Cambiar contraseña'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, '/crear-cuenta'),
                                style: TextButton.styleFrom(foregroundColor: primaryColor),
                                child: const Text('Crear cuenta'),
                              ),
                            ],
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            Text(_error!, style: const TextStyle(color: Colors.red)),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
