import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_tui/pages/components/user_panel.dart';
import 'package:firebase_app_tui/pages/login_page.dart';
import 'package:firebase_app_tui/pages/productos_agregar.dart';
import 'package:firebase_app_tui/pages/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  var fPrecio = NumberFormat.currency(
    decimalDigits: 0,
    locale: 'es_CL',
    symbol: '',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(MdiIcons.firebase, color: Colors.yellow),
        title: Text(
          'Productos Firestore',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (opcion) async {
              await FirebaseAuth.instance.signOut();
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => LoginPage(),
              );
              Navigator.pushReplacement(context, route);
            },
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Salir'), value: 'logout'),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          panelUserEmail(),
          Expanded(
            child: StreamBuilder(
              stream: FirestoreService().productos(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.separated(
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var producto = snapshot.data!.docs[index];
                    return ListTile(
                      leading: Icon(MdiIcons.cube),
                      title: Text('${producto['marca']} ${producto['modelo']}'),
                      subtitle: Text('stock: ${producto['stock']}'),
                      trailing: Text(
                        '\$ ${fPrecio.format(producto['precio'])}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ProductosAgregar(),
          );
          Navigator.push(context, route);
        },
      ),
    );
  }
}
