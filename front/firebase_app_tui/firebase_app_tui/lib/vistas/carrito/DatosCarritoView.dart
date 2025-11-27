import 'package:firebase_app_tui/constants/app_colors.dart';
import 'package:firebase_app_tui/vistas/carrito/boleta_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatosCarritoView extends StatefulWidget {
  const DatosCarritoView({super.key});
  @override
  State<DatosCarritoView> createState() => _DatosCarritoViewState();
}

class _DatosCarritoViewState extends State<DatosCarritoView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _rutController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  String _metodoPago = 'Débito';
  bool _isLoading = true;
  bool _isPaying = false;

  @override
  void initState() {
    super.initState();
    _cargarEmail();
  }

  Future<void> _cargarEmail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = sp.getString('user_email') ?? '';
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _rutController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _formatRut(String value) {
    String cleaned = value.replaceAll(RegExp(r'[^0-9kK]'), '');
    if (cleaned.isEmpty || cleaned.length < 2) return cleaned;
    String dv = cleaned.substring(cleaned.length - 1);
    String cuerpo = cleaned.substring(0, cleaned.length - 1);
    String formatted = '';
    int count = 0;
    for (int i = cuerpo.length - 1; i >= 0; i--) {
      if (count == 3) {
        formatted = '.$formatted';
        count = 0;
      }
      formatted = cuerpo[i] + formatted;
      count++;
    }
    return '$formatted-$dv';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Row(children: [Icon(Icons.store, color: Colors.white), SizedBox(width: 8), Text('Datos Personales', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))]),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ingresa tus datos para generar el comprobante de pago y realizar el seguimiento de la compra', style: TextStyle(color: textColor, fontSize: 14)),
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nombreController,
                              decoration: const InputDecoration(labelText: 'Nombre y apellido*', border: OutlineInputBorder()),
                              validator: (v) => v == null || v.isEmpty ? 'Por favor ingresa tu nombre' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _direccionController,
                              decoration: const InputDecoration(labelText: 'Direccion*', border: OutlineInputBorder()),
                              validator: (v) => v == null || v.isEmpty ? 'Por favor ingresa tu direccion' : null,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _rutController,
                                    decoration: const InputDecoration(labelText: 'RUT*', border: OutlineInputBorder()),
                                    onChanged: (v) {
                                      if (v.length >= 2) {
                                        String f = _formatRut(v);
                                        if (f != v) _rutController.value = TextEditingValue(text: f, selection: TextSelection.collapsed(offset: f.length));
                                      }
                                    },
                                    validator: (v) => v == null || v.isEmpty ? 'RUT requerido' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _telefonoController,
                                    decoration: const InputDecoration(labelText: 'Teléfono*', prefixText: '+569 ', border: OutlineInputBorder()),
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8)],
                                    validator: (v) => v == null || v.isEmpty ? 'Teléfono requerido' : v.length < 8 ? 'Teléfono inválido' : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(controller: _emailController, enabled: false, decoration: InputDecoration(labelText: 'E-mail*', filled: true, fillColor: Colors.grey[200], border: const OutlineInputBorder())),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Método de pago', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Card(
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            value: 'Débito',
                            groupValue: _metodoPago,
                            activeColor: primaryColor,
                            title: const Row(children: [Icon(Icons.credit_card), SizedBox(width: 8), Text('Débito')]),
                            onChanged: (v) => setState(() => _metodoPago = v!),
                          ),
                          const Divider(height: 1),
                          RadioListTile<String>(
                            value: 'Crédito',
                            groupValue: _metodoPago,
                            activeColor: primaryColor,
                            title: const Row(children: [Icon(Icons.payment), SizedBox(width: 8), Text('Crédito')]),
                            onChanged: (v) => setState(() => _metodoPago = v!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))]),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isPaying ? null : () async {
              if (_formKey.currentState!.validate()) {
                setState(() => _isPaying = true);
                await Future.delayed(const Duration(seconds: 1));
                setState(() => _isPaying = false);
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoletaView(
                        nombre: _nombreController.text,
                        direccion: _direccionController.text,
                        rut: _rutController.text,
                        telefono: _telefonoController.text,
                        email: _emailController.text,
                        metodoPago: _metodoPago,
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: _isPaying
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Pagar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
