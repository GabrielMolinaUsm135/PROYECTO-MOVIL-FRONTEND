import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/mousesProd.dart';
import 'package:flutter_application_1/vistas/vertical.dart';
import 'package:flutter_application_1/constants/app_colors.dart';

class TabMouse extends StatefulWidget {
  const TabMouse({super.key});

  @override
  State<TabMouse> createState() => _TabMouseState();
}

class _TabMouseState extends State<TabMouse> {
  late final Future<List<Mouse>> _futureMouses;

  String _formatCLP(double value) {
    final intVal = value.round();
    final s = intVal.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }

  @override
  void initState() {
    super.initState();
    _futureMouses = Future.value(listaMouses);
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
                    position:
                        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
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
            Text('TechStore Mouses',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const SizedBox(height: 4),
            const Text('Mouses'),
            Expanded(
              child: FutureBuilder<List<Mouse>>(
                future: _futureMouses,
                builder: (context, AsyncSnapshot<List<Mouse>> snapshot) {
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
                          trailing: Text('\$${_formatCLP(m.precio)}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
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
