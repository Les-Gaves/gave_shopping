import '../utils/json_utils.dart';
import 'product.dart';

/// Une ligne du panier (table `cart_items`).
///
/// [id] est l'id de la LIGNE : c'est lui qu'on utilise pour modifier
/// la quantité (PUT /api/cart/items/:id) ou supprimer (DELETE).
class CartItem {
  final int? id;
  final Product product;
  final int quantity;

  const CartItem({this.id, required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: toInt(json['id']),
        product: Product.fromJson(json['article'] as Map<String, dynamic>),
        quantity: toInt(json['quantity']),
      );

  CartItem copyWith({Product? product, int? quantity}) => CartItem(
        id: id,
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
      );
}
