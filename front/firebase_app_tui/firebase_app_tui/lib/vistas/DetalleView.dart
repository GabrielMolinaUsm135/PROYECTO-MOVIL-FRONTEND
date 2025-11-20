import 'package:flutter/material.dart';
import 'package:firebase_app_tui/constants/app_colors.dart';
import 'package:firebase_app_tui/vistas/carrito/carritoView.dart';
import 'package:firebase_app_tui/vistas/service/carrito_service.dart';
import 'package:intl/intl.dart';

class DetalleView extends StatelessWidget {
  final String id;
  final String nombre;
  final String descripcion;
  final num precio;
  final String image;

  const DetalleView({super.key, required this.id, required this.nombre, required this.descripcion, required this.precio, required this.image});

  static final NumberFormat _fPrecio = NumberFormat.currency(decimalDigits: 0, locale: 'es_CL', symbol: '');

  static bool _isNetworkUrl(String s) => s.startsWith('http://') || s.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final formattedPrice = '\$${_fPrecio.format(precio)}';

    Widget imageWidget;
    if (image.isNotEmpty && _isNetworkUrl(image)) {
      imageWidget = Image.network(image, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 80));
    } else if (image.isNotEmpty) {
      imageWidget = Image.asset(image, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 80));
    } else {
      imageWidget = const Icon(Icons.image_not_supported, size: 80);
    }

    return Scaffold(
      appBar: AppBar(title: Text(nombre)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 240,
                  child: ClipRRect(borderRadius: BorderRadius.circular(8), child: imageWidget),
                ),
              ),
              const SizedBox(height: 16),
              Text(nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(formattedPrice, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green)),
              const SizedBox(height: 12),
              Text(descripcion, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final item = CartItem(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                precio: precio,
                image: image,
              );
              CartService.instance.anhadir(item);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Producto agregado al carrito'),
                  action: SnackBarAction(
                    label: 'Ver',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CarritoView()),
                      );
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Agregar al carrito',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}