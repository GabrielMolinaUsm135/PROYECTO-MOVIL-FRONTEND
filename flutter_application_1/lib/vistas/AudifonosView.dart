import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/audifonosProd.dart';

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
    return Padding(
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
                        subtitle: Text(m.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: Text('\$${_formatCLP(m.precio)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
