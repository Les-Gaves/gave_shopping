import 'package:flutter/foundation.dart';

import '../models/order.dart';
import 'api_client.dart';

/// Commandes, via l'API.
///   - GET   /api/orders              → le back renvoie les commandes de
///                                      l'utilisateur, ou TOUTES pour un admin
///   - POST  /api/orders              → transforme le panier en commande
///   - PATCH /api/orders/:id/status   → change le statut (admin)
class OrderService extends ChangeNotifier {
  OrderService._();
  static final OrderService instance = OrderService._();

  List<Order> _orders = [];
  bool _loading = false;
  String? _error;

  /// Commandes visibles par l'utilisateur connecté (filtrées par le back).
  List<Order> get orders => List.unmodifiable(_orders);
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await ApiClient.get('/api/orders', auth: true) as List;
      _orders = data
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ApiException catch (e) {
      _error = e.message;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Crée une commande à partir du panier actif de l'utilisateur.
  /// Lève une [ApiException] (panier vide, stock insuffisant…).
  Future<Order> createOrder({required String shippingAddress}) async {
    final data = await ApiClient.post(
      '/api/orders',
      body: {'shipping_address': shippingAddress},
    );
    final order = Order.fromJson(data as Map<String, dynamic>);
    _orders = [order, ..._orders];
    notifyListeners();
    return order;
  }

  /// Change le statut d'une commande (admin uniquement, vérifié par le back).
  Future<void> updateStatus(int orderId, OrderStatus status) async {
    final data = await ApiClient.patch(
      '/api/orders/$orderId/status',
      body: {'status': status.name},
    );
    final updated = Order.fromJson(data as Map<String, dynamic>);
    _orders = _orders.map((o) => o.id == orderId ? updated : o).toList();
    notifyListeners();
  }

  /// À appeler à la déconnexion.
  void reset() {
    _orders = [];
    _error = null;
    notifyListeners();
  }
}
