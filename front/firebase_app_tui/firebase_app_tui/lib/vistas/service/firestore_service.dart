import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Stream<QuerySnapshot> teclados() {
    return FirebaseFirestore.instance.collection('teclados').snapshots();
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
