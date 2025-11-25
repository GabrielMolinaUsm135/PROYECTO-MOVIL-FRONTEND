import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CambiarPass extends StatefulWidget {
  const CambiarPass({super.key});

  @override
  State<CambiarPass> createState() => _CambiarPassState();
}

class _CambiarPassState extends State<CambiarPass> {
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      _emailController.text = user.email!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final email = _emailController.text.trim();
    final current = _currentPasswordController.text;
    final neu = _newPasswordController.text;
    final conf = _confirmPasswordController.text;

    if (email.isEmpty || current.isEmpty || neu.isEmpty || conf.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complete todos los campos')));
      return;
    }
    if (neu.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La nueva contraseña debe tener al menos 6 caracteres')));
      return;
    }
    if (neu != conf) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La confirmación no coincide')));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay usuario autenticado')));
      return;
    }

    if (user.email!.toLowerCase() != email.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El correo ingresado no coincide con el usuario autenticado')));
      return;
    }

    setState(() => _loading = true);
    try {
      final cred = EmailAuthProvider.credential(email: user.email!, password: current);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(neu);
      setState(() => _loading = false);
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Contraseña actualizada'),
          content: const Text('La contraseña ha sido cambiada con éxito.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Aceptar')),
          ],
        ),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      setState(() => _loading = false);
      String msg = 'Error al actualizar la contraseña';
      if (e.code == 'wrong-password') msg = 'Contraseña actual incorrecta';
      if (e.code == 'weak-password') msg = 'La contraseña es demasiado débil';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ocurrió un error. Intente nuevamente.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Correo (autenticado)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña actual', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Nueva contraseña', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirmar nueva contraseña', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _changePassword,
                    child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Cambiar contraseña'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}