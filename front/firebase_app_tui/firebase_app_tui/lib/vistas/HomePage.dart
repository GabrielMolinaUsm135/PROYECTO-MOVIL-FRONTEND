import 'package:firebase_app_tui/constants/app_colors.dart';
import 'package:firebase_app_tui/vistas/VerticalTab.dart';
import 'package:firebase_app_tui/vistas/carrito/carritoView.dart';
import 'package:firebase_app_tui/vistas/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app_tui/vistas/DetalleView.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, '/', (route) => false);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                const Expanded(child: Verticaltab()), //Verticaltab()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                transitionBuilder: (context, a1, a2, child) {
                  // Animación: entra desde la izquierda
                  return SlideTransition(
                    position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
                        .animate(a1),
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
            Text(
              'TechStore',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CarritoView()), //CarritoView
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Ofertas del día',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: () async {
                  // Fetch first snapshot from each collection and merge
                  final futures = [
                    FirestoreService().teclados().first,
                    FirestoreService().mouse().first,
                    FirestoreService().monitores().first,
                    FirestoreService().audifonos().first,
                  ];

                  final results = await Future.wait(futures);
                  final items = <Map<String, dynamic>>[];
                  for (var qs in results) {
                    for (var d in qs.docs) {
                      final data = d.data() as Map<String, dynamic>;
                      items.add({
                        'id': d.id,
                        'nombre': data['nombre'] ?? '',
                        'descripcion': data['descripcion'] ?? '',
                        'precio': data['precio'] ?? 0,
                        'image': data['imageAsset'] ?? '',
                      });
                    }
                  }
                  items.shuffle();
                  return items;
                }(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final list = snap.data!;
                  final count = list.length >= 4 ? 4 : list.length;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: count,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final name = item['nombre'] ?? 'Producto';
                      final precioNum = (item['precio'] ?? 0) as num;
                      final formatted = precioNum.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
                      final price = '\$$formatted';
                      final discount = '-${10 + (index * 5)}%';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleView(
                                id: item['id'] ?? '',
                                nombre: item['nombre'] ?? 'Producto',
                                descripcion: item['descripcion'] ?? '',
                                precio: (item['precio'] ?? 0) as num,
                                image: item['image'] ?? '',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                        child: Image.network(
                                          item['image'] ?? '',
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                          height: 84,
                                          errorBuilder: (context, error, stackTrace) => const Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 50,
                                              color: textSecondary,
                                            ),
                                          ),
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        discount,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: textColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      price,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
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
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Te recomendamos',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: () async {
                // Reuse the same merged list as above (refetch for simplicity)
                final futures = [
                  FirestoreService().teclados().first,
                  FirestoreService().mouse().first,
                  FirestoreService().monitores().first,
                  FirestoreService().audifonos().first,
                ];

                final results = await Future.wait(futures);
                final items = <Map<String, dynamic>>[];
                for (var qs in results) {
                  for (var d in qs.docs) {
                    final data = d.data() as Map<String, dynamic>;
                    items.add({
                      'id': d.id,
                      'nombre': data['nombre'] ?? '',
                      'descripcion': data['descripcion'] ?? '',
                      'precio': data['precio'] ?? 0,
                      'image': data['imageAsset'] ?? '',
                    });
                  }
                }
                items.shuffle();
                return items;
              }(),
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));

                final list = snap.data!;
                final count = list.length >= 4 ? 4 : list.length;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: count,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final name = item['nombre'] as String? ?? 'Producto';
                    final precioNum = (item['precio'] ?? 0) as num;
                    final formatted = precioNum.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
                    final price = '\$$formatted';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleView(
                              id: item['id'] ?? '',
                              nombre: item['nombre'] ?? 'Producto',
                              descripcion: item['descripcion'] ?? '',
                              precio: (item['precio'] ?? 0) as num,
                              image: item['image'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                    child: Image.network(
                                      item['image'] ?? '',
                                      fit: BoxFit.contain,
                                      height: 120,
                                      errorBuilder: (context, error, stackTrace) => const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 60,
                                          color: textSecondary,
                                        ),
                                      ),
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  price,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
