import 'package:flutter/foundation.dart';
import '../data/mock_data.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

/// Commandes.
///
/// Pour l'instant, les commandes sont gardées en mémoire, avec deux commandes
/// fictives passées par d'autres clients (pour voir la différence entre la vue
/// admin et la vue utilisateur). Quand le back sera prêt :
///   - GET   /orders              → l'utilisateur reçoit SES commandes,
///                                  l'admin reçoit TOUTES les commandes
///                                  (c'est le back qui filtre selon le rôle)
///   - POST  /orders              → createOrder()
///   - PATCH /orders/{id}/status  → updateStatus() (admin uniquement)
class OrderService extends ChangeNotifier {
  OrderService._();
  static final OrderService instance = OrderService._();

  final List<Order> _orders = _demoOrders();
  int _nextId = 1003;

  /// Commandes d'un utilisateur, de la plus récente à la plus ancienne.
  /// TODO(back) : GET /orders avec le token d'un utilisateur.
  List<Order> ordersOf(String userId) =>
      _sorted(_orders.where((o) => o.userId == userId));

  /// Toutes les commandes (vue admin).
  /// TODO(back) : GET /orders avec le token d'un admin.
  List<Order> get allOrders => _sorted(_orders);

  /// Crée une commande à partir du contenu du panier.
  /// TODO(back) : POST /orders. Le back crée la commande à partir du panier
  /// de l'utilisateur, calcule le total et renvoie la commande créée.
  Future<Order> createOrder({
    required String userId,
    String? userEmail,
    required List<CartItem> items,
    required double totalAmount,
  }) async {
    final order = Order(
      id: _nextId++,
      userId: userId,
      userEmail: userEmail,
      items: List.of(items),
      totalAmount: totalAmount,
      orderedAt: DateTime.now(),
    );
    _orders.add(order);
    notifyListeners();
    return order;
  }

  /// Change le statut d'une commande (admin).
  /// La première sortie de 'pending' renseigne `validated_at`.
  /// TODO(back) : PATCH /orders/{id}/status { status }
  Future<void> updateStatus(int orderId, OrderStatus status) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index == -1) return;

    final order = _orders[index];
    _orders[index] = order.copyWith(
      status: status,
      validatedAt: order.validatedAt ??
          (status != OrderStatus.pending ? DateTime.now() : null),
    );
    notifyListeners();
  }

  List<Order> _sorted(Iterable<Order> orders) =>
      orders.toList()..sort((a, b) => b.orderedAt.compareTo(a.orderedAt));

  static List<Order> _demoOrders() {
    final products = MockData.products;
    final now = DateTime.now();
    return [
      Order(
        id: 1001,
        userId: 'demo-client-1',
        userEmail: 'camille.durand@example.com',
        items: [
          CartItem(product: products[0]),
          CartItem(product: products[6], quantity: 2),
        ],
        status: OrderStatus.delivered,
        totalAmount: products[0].price + products[6].price * 2,
        shippingAddress: '3 rue du Gave, 64400 Oloron-Sainte-Marie',
        orderedAt: now.subtract(const Duration(days: 12)),
        validatedAt: now.subtract(const Duration(days: 11)),
      ),
      Order(
        id: 1002,
        userId: 'demo-client-2',
        userEmail: 'hugo.martin@example.com',
        items: [CartItem(product: products[4])],
        status: OrderStatus.processing,
        totalAmount: products[4].price,
        shippingAddress: '18 avenue des Pyrénées, 64000 Pau',
        orderedAt: now.subtract(const Duration(days: 2)),
        validatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
