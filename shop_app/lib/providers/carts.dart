import 'package:flutter/material.dart';

class Cart {
  final String id;
  final String title;
  final int quantity;
  final double price;
  Cart({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Carts with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  int get totalAmount {
    return _items.entries.fold(0, (previous, item) {
      return previous + item.value.quantity;
    });
  }

  double get totalPrice {
    return _items.entries.fold(0.0, (previous, item) {
      return previous + (item.value.price * item.value.quantity);
    });
  }

  void removeProduct(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (current) => Cart(
          id: current.id,
          title: current.title,
          price: current.price,
          quantity: current.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => Cart(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int direction) {
    final quantity = (_items[productId]?.quantity ?? 0) + direction;
    if (quantity <= 0) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (current) => Cart(
          id: current.id,
          title: current.title,
          price: current.price,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
