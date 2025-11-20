import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String nombre;
  final String descripcion;
  final num precio;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.image,
    this.quantity = 1,
  });
}

class CartService extends ChangeNotifier {
  CartService._privateConstructor();
  static final CartService instance = CartService._privateConstructor();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void anhadir(CartItem item) {
    try {
      final idx = _items.indexWhere((e) => e.id == item.id);
      if (idx >= 0) {
        _items[idx].quantity += item.quantity;
      } else {
        _items.add(item);
      }
      notifyListeners();
    } catch (_) {
    }
  }

  void eliminar(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void aumentarCant(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _items[idx].quantity += 1;
      notifyListeners();
    }
  }

  void disminuirCant(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _items[idx].quantity -= 1;
      if (_items[idx].quantity <= 0) {
        _items.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  num get total {
    return _items.fold(0, (s, e) => s + e.precio * e.quantity);
  }
}
