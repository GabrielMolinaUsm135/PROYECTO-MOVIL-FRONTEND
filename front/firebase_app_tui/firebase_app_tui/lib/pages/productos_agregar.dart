import 'package:firebase_app_tui/pages/components/user_panel.dart';
import 'package:firebase_app_tui/pages/service/firestore_service.dart';
import 'package:firebase_app_tui/pages/util/number_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class ProductosAgregar extends StatefulWidget {
  const ProductosAgregar({super.key});

  @override
  State<ProductosAgregar> createState() => _ProductosAgregarState();
}

class _ProductosAgregarState extends State<ProductosAgregar> {
  final formKey = GlobalKey<FormState>();
  TextEditingController marcaCtrl = TextEditingController();
  TextEditingController modeloCtrl = TextEditingController();
  TextEditingController precioCtrl = TextEditingController();
  TextEditingController stockCtrl = TextEditingController();
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

        elevation: 0,
      ),
      body: ListView(
        children: [
          panelUserEmail(),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  campoMarca(),
                  campoModelo(),
                  campoPrecio(),
                  campoStock(),
                  botonAgregarProducto(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField campoMarca() {
    return TextFormField(
      controller: marcaCtrl,
      decoration: InputDecoration(labelText: 'Marca'),
      validator: (valor) {
        if (valor!.isEmpty) {
          return 'Indique la marca';
        }
        return null;
      },
    );
  }

  TextFormField campoModelo() {
    return TextFormField(
      controller: modeloCtrl,
      decoration: InputDecoration(labelText: 'Modelo'),
      validator: (valor) {
        if (valor!.isEmpty) {
          return 'Indique el modelo';
        }
        return null;
      },
    );
  }

  TextFormField campoPrecio() {
    return TextFormField(
      controller: precioCtrl,
      decoration: InputDecoration(labelText: 'Precio'),
      keyboardType: TextInputType.number,
      validator: (valor) {
        if (valor!.isEmpty) {
          return 'Indique el precio';
        }
        if (!NumberUtil.isInteger(valor)) {
          return 'El precio de ser un número entero';
        }
        int precio = int.parse(valor);
        if (precio < 0) {
          return 'El precio no puede ser negativo';
        }
        return null;
      },
    );
  }

  TextFormField campoStock() {
    return TextFormField(
      controller: stockCtrl,
      decoration: InputDecoration(labelText: 'Stock'),
      keyboardType: TextInputType.number,
      validator: (valor) {
        if (valor!.isEmpty) {
          return 'Indique stock';
        }
        if (!NumberUtil.isInteger(valor)) {
          return 'El stock de ser un número entero';
        }
        return null;
      },
    );
  }

  Container botonAgregarProducto() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            FirestoreService().productosAgregar(
              marcaCtrl.text.trim(),
              modeloCtrl.text.trim(),
              int.parse(precioCtrl.text.trim()),
              int.parse(stockCtrl.text.trim()),
            );
            Navigator.pop(context);
          }
        },
        child: Text('Agregar Producto'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
