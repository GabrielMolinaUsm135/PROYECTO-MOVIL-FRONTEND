import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/teclados_provider.dart';

class TabTeclado extends StatefulWidget {
  const TabTeclado({super.key});

  @override
  State<TabTeclado> createState() => _TabTecladoState();
}

class _TabTecladoState extends State<TabTeclado> {
  TecladosProvider teclados = TecladosProvider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Container(child: Text('Teclado View')),
          Expanded(child: FutureBuilder(
            future: teclados.getTeclados(), 
            builder: (context, AsyncSnapshot snapshot){
              if(!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando...'),
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: snapshot.data.length,
                  itemBuilder:(context, index) {
                    return ListTile(
                      leading: Icon(Icons.keyboard),
                      title: Text(snapshot.data[index]['nombre']),
                      subtitle: Text(snapshot.data[index]['descripcion']),
                      trailing: Text('\$${snapshot.data[index]['precio']}'),
                    );
                  },
                );

              }
            },
          ))
        ],
      ),
    );
  }
}
