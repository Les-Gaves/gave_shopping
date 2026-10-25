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
}

/// Une commande (table `orders`).
///
/// [items] est une copie du panier au moment de la commande : le back
/// la renverra à partir de `cart_items` (via `cart_id`).
/// [userEmail] n'est pas dans la table `orders`, mais le back pourra
/// l'ajouter à la réponse pour que l'admin sache qui a commandé.
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

  Order copyWith({OrderStatus? status, DateTime? validatedAt}) => Order(
        id: id,
        userId: userId,
        userEmail: userEmail,
        items: items,
        status: status ?? this.status,
        totalAmount: totalAmount,
        shippingAddress: shippingAddress,
        orderedAt: orderedAt,
        validatedAt: validatedAt ?? this.validatedAt,
      );
}
