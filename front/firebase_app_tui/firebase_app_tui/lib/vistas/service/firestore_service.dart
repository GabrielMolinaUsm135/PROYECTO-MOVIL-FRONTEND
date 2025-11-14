import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Stream<QuerySnapshot> monitores() {
    return FirebaseFirestore.instance.collection('monitores').snapshots();
  }

  // Future productosAgregar(String marca, String modelo, int precio, int stock) {
  //   return FirebaseFirestore.instance.collection('teclados').doc().set({
  //     'marca': marca,
  //     'modelo': modelo,
  //     'precio': precio,
  //     'stock': stock,
  //   });
  // }
}
