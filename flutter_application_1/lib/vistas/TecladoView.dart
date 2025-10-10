import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/tecladosProd.dart';
import 'package:flutter_application_1/providers/teclados_provider.dart';

class TabViewTeclado extends StatefulWidget {
  const TabViewTeclado({super.key});

  @override
  State<TabViewTeclado> createState() => _TabViewTecladoState();
}

class _TabViewTecladoState extends State<TabViewTeclado> {
  final TecladosProvider tecladosProvider = TecladosProvider();

  late final Future<List<Producto>> _futureTeclados;

  @override
  void initState() {
    super.initState();
    final result = tecladosProvider.getTeclados();
    if (result is Future<List<Producto>>) {
      _futureTeclados = result;
    } else {
      // handle case where getTeclados() returns a synchronous List<Producto>
      _futureTeclados = Future.value(result as List<Producto>);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Lista de Teclados', style: TextStyle(fontSize: 20)),
          ),
          Expanded(
            child: FutureBuilder<List<Producto>>(
              future: _futureTeclados,
              builder: (context, AsyncSnapshot<List<Producto>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Cargando...'),
                        SizedBox(height: 8),
                        SizedBox(width: 200, child: LinearProgressIndicator()),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay teclados disponibles.'));
                } else {
                  final lista = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final producto = lista[index];
                      return ProductCard(producto: producto);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Producto producto;

  const ProductCard({required this.producto, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: producto.imageAsset != null && producto.imageAsset.isNotEmpty
                  ? Image.asset(
                      producto.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(producto.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${producto.precio.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agregar ${producto.nombre}')));
                      },
                      child: const Text('Agregar'),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
