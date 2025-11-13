import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Stream<QuerySnapshot> productos() {
    return FirebaseFirestore.instance.collection('productos').snapshots();
  }

  Future productosAgregar(String marca, String modelo, int precio, int stock) {
    return FirebaseFirestore.instance.collection('productos').doc().set({
      'marca': marca,
      'modelo': modelo,
      'precio': precio,
      'stock': stock,
    });
  }
}
