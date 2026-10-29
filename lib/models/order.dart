import '../utils/json_utils.dart';
import 'cart_item.dart';

/// Statuts possibles d'une commande (enum `order_status` de la base).
enum OrderStatus {
  pending,
  paid,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded;

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.paid:
        return 'Payée';
      case OrderStatus.processing:
        return 'En préparation';
      case OrderStatus.shipped:
        return 'Expédiée';
      case OrderStatus.delivered:
        return 'Livrée';
      case OrderStatus.cancelled:
        return 'Annulée';
      case OrderStatus.refunded:
        return 'Remboursée';
    }
  }

  static OrderStatus fromName(String? name) => OrderStatus.values.firstWhere(
        (s) => s.name == name,
        orElse: () => OrderStatus.pending,
      );
}

/// Une commande (table `orders`).
///
/// Les articles viennent du panier lié à la commande (cart.cartItems).
/// [userEmail] n'est rempli que si le back inclut l'utilisateur
/// dans la réponse (include: { user: { select: { email: true } } }).
class Order {
  final int id;
  final String userId;
  final String? userEmail;
  final List<CartItem> items;
  final OrderStatus status;
  final double totalAmount;
  final String? shippingAddress;
  final DateTime orderedAt;
  final DateTime? validatedAt;

  const Order({
    required this.id,
    required this.userId,
    this.userEmail,
    required this.items,
    this.status = OrderStatus.pending,
    required this.totalAmount,
    this.shippingAddress,
    required this.orderedAt,
    this.validatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    final cart = json['cart'] as Map<String, dynamic>?;
    final cartItems = (cart?['cartItems'] as List?) ?? const [];
    final user = json['user'] as Map<String, dynamic>?;

    return Order(
      id: toInt(json['id']),
      userId: json['userId'] as String? ?? '',
      userEmail: user?['email'] as String?,
      items: cartItems
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.fromName(json['status'] as String?),
      totalAmount: toDouble(json['totalAmount']),
      shippingAddress: json['shippingAddress'] as String?,
      orderedAt: toDate(json['orderedAt']) ?? DateTime.now(),
      validatedAt: toDate(json['validatedAt']),
    );
  }
}
