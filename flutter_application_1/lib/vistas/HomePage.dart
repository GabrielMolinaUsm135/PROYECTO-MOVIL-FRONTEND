import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/vistas/Carrito/carritoView.dart';
import 'package:flutter_application_1/vistas/vertical.dart';

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
                                const Expanded(child: Verticaltab()),
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
                MaterialPageRoute(builder: (context) => const CarritoView()),
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
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final name = 'Producto ${index + 1}';
                  final rawPrice = 69990 - index * 5000;
                  final formatted = rawPrice
                      .toString()
                      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
                  final price = '\$$formatted';
                  final discount = '-${20 + index * 5}%';

                  return Container(
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
                              child: const Center(
                                child: Icon(
                                  Icons.devices,
                                  size: 50,
                                  color: textSecondary,
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final products = [
                  {'name': 'Notebook Gamer', 'price': '\$1.299.990', 'icon': Icons.laptop},
                  {'name': 'Monitor 27"', 'price': '\$249.990', 'icon': Icons.desktop_windows},
                  {'name': 'Mouse Gaming', 'price': '\$39.990', 'icon': Icons.mouse},
                  {'name': 'Teclado Mecánico', 'price': '\$89.990', 'icon': Icons.keyboard},
                ];

                final name = products[index]['name'] as String;
                final price = products[index]['price'] as String;
                final icon = products[index]['icon'] as IconData;

                return Container(
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
                          child: Center(
                            child: Icon(
                              icon,
                              size: 60,
                              color: textSecondary,
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
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: const Text(
                                  'Agregar',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
