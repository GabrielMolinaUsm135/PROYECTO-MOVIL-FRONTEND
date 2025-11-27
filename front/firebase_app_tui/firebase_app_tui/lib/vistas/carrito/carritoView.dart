import 'package:firebase_app_tui/constants/app_colors.dart';
import 'package:firebase_app_tui/constants/snackbar.dart';
import 'package:firebase_app_tui/vistas/HomePage.dart';
import 'package:firebase_app_tui/vistas/carrito/DatosCarritoView.dart';
import 'package:firebase_app_tui/vistas/service/carrito_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CarritoView extends StatelessWidget {
  const CarritoView({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(decimalDigits: 0, locale: 'es_CL', symbol: '');

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Row(
          children: [
            Icon(Icons.store, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Carrito',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: CartService.instance,
        builder: (context, _) {
          final items = CartService.instance.items;
          if (items.isEmpty) {
            return Center(child: Text('Tu carrito está vacío', style: TextStyle(color: textSecondary)));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                final total = CartService.instance.total;
                return Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total de la compra', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('\$${fmt.format(total)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }

              final item = items[index];
              final isNetwork = item.image.startsWith('http://') || item.image.startsWith('https://');

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isNetwork
                            ? Image.network(item.image, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image))
                            : Image.asset(item.image, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(item.descripcion, style: TextStyle(color: textColor), maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: textColor),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 18),
                                        onPressed: () => CartService.instance.disminuirCant(item.id),
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 18),
                                        onPressed: () => CartService.instance.aumentarCant(item.id),
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('\$${fmt.format(item.precio * item.quantity)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                                    Text('\$${fmt.format(item.precio)}', style: TextStyle(color: textColor, fontSize: 10)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () => CartService.instance.eliminar(item.id),
                              icon: const Icon(Icons.delete_outline, size: 18),
                              label: const Text('Eliminar'),
                              style: TextButton.styleFrom(foregroundColor: Colors.red, padding: EdgeInsets.zero),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: CartService.instance,
        builder: (context, _) {
          final items = CartService.instance.items;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: items.isEmpty
                    ? () {
                        mostrarSnackbar(context, 'Debes agregar productos al carrito para continuar');
                      }
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DatosCarritoView()),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: items.isEmpty ? Colors.grey : primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Continuar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}
