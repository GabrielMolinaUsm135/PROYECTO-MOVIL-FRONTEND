import 'package:firebase_app_tui/constants/app_colors.dart';
import 'package:firebase_app_tui/vistas/HomePage.dart';
import 'package:firebase_app_tui/vistas/service/carrito_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoletaView extends StatelessWidget {
  final String nombre;
  final String direccion;
  final String rut;
  final String telefono;
  final String email;
  final String metodoPago;

  const BoletaView({
    super.key,
    required this.nombre,
    required this.direccion,
    required this.rut,
    required this.telefono,
    required this.email,
    required this.metodoPago,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(decimalDigits: 0, locale: 'es_CL', symbol: '\$');
    final items = CartService.instance.items;
    final total = CartService.instance.total;
    final now = DateTime.now();
    final fechaHora = DateFormat('dd/MM/yyyy HH:mm').format(now);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: const Text('Comprobante de Pago', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: primaryColor),
                        child: const Icon(Icons.store, color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 12),
                      const Text('COMPROBANTE DE PAGO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 4),
                      Text('Tienda Online', style: TextStyle(fontSize: 14, color: textSecondary)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                            const SizedBox(width: 8),
                            Text('PAGO EXITOSO', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [SizedBox(width: 120, child: Text('Fecha y Hora:', style: TextStyle(color: textColor, fontSize: 13))), Expanded(child: Text(fechaHora, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))]),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [SizedBox(width: 120, child: Text('Método de Pago:', style: TextStyle(color: textColor, fontSize: 13))), Expanded(child: Text(metodoPago, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))]),
                ),
                
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                
                const Text('TUS DATOS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor)),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [SizedBox(width: 120, child: Text('Nombre:', style: TextStyle(color: textColor, fontSize: 13))), Expanded(child: Text(nombre, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))]),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [SizedBox(width: 120, child: Text('RUT:', style: TextStyle(color: textColor  , fontSize: 13))), Expanded(child: Text(rut, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))]),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [SizedBox(width: 120, child: Text('Dirección:', style: TextStyle(color: textColor, fontSize: 13))), Expanded(child: Text(direccion, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))]),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [SizedBox(width: 120, child: Text('Teléfono:', style: TextStyle(color: textColor , fontSize: 13))), Expanded(child: Text('+569 $telefono', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))]),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [SizedBox(width: 120, child: Text('Email:', style: TextStyle(color: textColor, fontSize: 13))), Expanded(child: Text(email, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))]),
                ),
                
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                
                // Detalle de productos
                const Text('DETALLE DE PRODUCTOS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor)),
                const SizedBox(height: 12),
                
                ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text('Cant: ${item.quantity}', style: TextStyle(fontSize: 12, color: textColor)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(fmt.format(item.precio * item.quantity), style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: 12),
                const Divider(thickness: 2),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL PAGADO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(fmt.format(total), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        ),
                    icon: const Icon(Icons.home),
                    label: const Text('Volver al inicio', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
