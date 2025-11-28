import 'package:firebase_app_tui/constants/app_colors.dart';
import 'package:firebase_app_tui/constants/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrearCuenta extends StatefulWidget {
  const CrearCuenta({super.key});

  @override
  State<CrearCuenta> createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuenta> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _crearCuenta() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      mostrarSnackbar(context, 'Por favor completa todos los campos');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('user_email', _emailController.text.trim());

      if (mounted) {
        mostrarSnackbar(context, 'Cuenta creada con éxito');
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (ex) {
      String mensaje = 'Error al crear la cuenta';
      switch (ex.code) {
        case 'email-already-in-use':
          mensaje = 'Este correo ya está registrado';
          break;
        case 'invalid-email':
          mensaje = 'Correo electrónico inválido';
          break;
        case 'weak-password':
          mensaje = 'La contraseña debe tener al menos 6 caracteres';
          break;
      }
      if (mounted) mostrarSnackbar(context, mensaje);
    } catch (e) {
      if (mounted) mostrarSnackbar(context, 'Error al crear la cuenta');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override

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
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: const [
                        Icon(Icons.person, size: 48, color: secondaryColor),
                        SizedBox(height: 8),
                        Text('Crear Cuenta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Form(
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
                              onPressed: _isLoading ? null : _crearCuenta,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: _isLoading
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text('Crear'),
                              ),
                            ),
                          ),                        ],
                      ),
                    ),
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
