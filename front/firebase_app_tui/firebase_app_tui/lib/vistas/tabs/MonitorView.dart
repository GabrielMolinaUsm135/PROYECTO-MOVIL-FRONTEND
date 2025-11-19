import 'package:firebase_app_tui/constants/app_colors.dart';
import 'package:firebase_app_tui/vistas/service/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabMonitor extends StatelessWidget {
  const TabMonitor({super.key});

  static final NumberFormat _fPrecio = NumberFormat.currency(decimalDigits: 0, locale: 'es_CL', symbol: '');

  static String _formatCLPFromNum(num value) => _fPrecio.format(value);

  static bool _isNetworkUrl(String s) => s.startsWith('http://') || s.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: ButtonTheme(
          minWidth: 0,
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Menú',
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, anim1, anim2) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 320,
                        height: MediaQuery.of(context).size.height,
                        child: SafeArea(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                AppBar(
                                  backgroundColor: primaryColor,
                                  title: const Text('Menú'),
                                  automaticallyImplyLeading: false,
                                  actions: [
                                    IconButton(
                                      icon: const Icon(Icons.logout),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                transitionBuilder: (context, a1, a2, child) {
                  return SlideTransition(
                    position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(a1),
                    child: child,
                  );
                },
              );
            },
          ),
        ),
        title: Row(
          children: const [
            Icon(Icons.store, color: Colors.white),
            SizedBox(width: 8),
            Text('TechStore Monitores', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Monitores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().monitores(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) return const Center(child: Text('No hay productos'));

                  return ListView.separated(
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final nombre = data['nombre'] ?? '';
                      final descripcion = data['descripcion'] ?? '';
                      final precio = data['precio'] ?? 0;
                      final image = data['imageAsset'] ?? '';

                      Widget leading;
                      if (image is String && _isNetworkUrl(image)) {
                        leading = ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(image, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width:64, height:64, color: Colors.grey[200], child: const Icon(Icons.broken_image))),
                        );
                      } else {
                        leading = ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(image.toString(), width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width:64, height:64, color: Colors.grey[200], child: const Icon(Icons.broken_image))),
                        );
                      }

                      return Dismissible(
                        key: ValueKey(doc.id),
                        // Only allow swipe from start to end (left-to-right)
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: Colors.blueAccent,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          child: const Icon(Icons.shopping_cart, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          // Placeholder: send item to shopping cart.
                          // Implement cart logic here later. The 'direction'
                          // parameter indicates the swipe direction.
                          // Example: await CartService.add(doc.id);
                          return false; // keep the item in the list for now
                        },
                        child: Card(
                          child: ListTile(
                            leading: leading,
                            title: Text(nombre.toString()),
                            subtitle: Text(descripcion.toString(), maxLines: 2, overflow: TextOverflow.ellipsis),
                            trailing: Text('\$${_formatCLPFromNum(precio)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}