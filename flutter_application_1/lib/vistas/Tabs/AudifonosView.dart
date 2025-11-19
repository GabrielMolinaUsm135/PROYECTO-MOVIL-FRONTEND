import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/audifonosProd.dart';
import 'package:flutter_application_1/vistas/vertical.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/snackbar.dart';

class TabAudifonos extends StatefulWidget {
  const TabAudifonos({super.key});

  @override
  State<TabAudifonos> createState() => _TabAudifonosState();
}

class _TabAudifonosState extends State<TabAudifonos> {
  late final Future<List<Audifono>> _futureAudifonos;

  String _formatCLP(double value) {
    final intVal = value.round();
    final s = intVal.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }

  @override
  void initState() {
    super.initState();
    _futureAudifonos = Future.value(listaAudifonos);
  }

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
            Text('TechStore Audifonos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const SizedBox(height: 4),
            const Text('Audifonos'),
            Expanded(
              child: FutureBuilder<List<Audifono>>(
                future: _futureAudifonos,
                builder: (context, AsyncSnapshot<List<Audifono>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Cargando...'),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final items = snapshot.data!;
                    return ListView.separated(
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final m = items[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              m.imageAsset,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                color: Colors.grey[200],
                                width: 64,
                                height: 64,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          title: Text(m.nombre),
                          subtitle: Text(m.descripcion,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: SizedBox(
                            width: 160,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Text(
                                    '\$${_formatCLP(m.precio)}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  tooltip: 'Agregar al carrito',
                                  icon: const Icon(Icons.add_shopping_cart, color: accentColor),
                                  onPressed: () {
                                    mostrarSnackbar(context, 'Agregado al carrito');

                                    // Estructura para integrar con base de datos xd:
                                    /*
                                    PROBABLEMENTE falte algo, asi que fijarse al descomentar nombres de variables
                                    // import 'package:cloud_firestore/cloud_firestore.dart'; arriba en imports
                                    final uid = 'dev-user'; //id de usuario
                                    final productoId = m.id ?? 'audifono_${index}';
                                    await FirebaseFirestore.instance
                                        .collection('usuarios')
                                        .doc(uid)
                                        .collection('carrito')
                                        .doc(productoId)
                                        .set({
                                          'name': m.nombre,
                                          'price': m.precio,
                                          'qty': FieldValue.increment(1),
                                          'image': m.imageAsset,
                                          'createdAt': FieldValue.serverTimestamp(),
                                        }, SetOptions(merge: true));
                                    */
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
