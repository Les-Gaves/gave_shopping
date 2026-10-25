import 'product.dart';

/// Une ligne du panier : un article et sa quantité.
///
/// Correspond à la table `cart_items` (cart_id, article_id, quantity).
/// Côté front, on garde l'article complet plutôt que son seul id,
/// pour pouvoir afficher directement son nom, son image et son prix.
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
}
