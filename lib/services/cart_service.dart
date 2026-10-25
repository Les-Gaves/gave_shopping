import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Panier de l'utilisateur.
///
/// Pour l'instant, le panier est gardé en mémoire (perdu au rechargement).
/// Quand le back sera prêt, chaque méthode appellera l'API correspondante :
///   - GET    /cart                  → loadCart()
///   - POST   /cart/items            → add()
///   - PATCH  /cart/items/{id}       → setQuantity()
///   - DELETE /cart/items/{id}       → remove()
///   - POST   /orders                → checkout()
class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  /// Nombre total d'articles (somme des quantités), pour le badge.
  int get count => _items.fold(0, (sum, item) => sum + item.quantity);

  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);

  bool get isEmpty => _items.isEmpty;

  int quantityOf(Product product) {
    final index = _indexOf(product);
    return index == -1 ? 0 : _items[index].quantity;
  }

  /// Ajoute un article (ou augmente sa quantité s'il est déjà dans le panier).
  /// Renvoie false si le stock est insuffisant.
  /// TODO(back) : POST /cart/items { article_id, quantity }
  bool add(Product product, {int quantity = 1}) {
    final current = quantityOf(product);
    if (current + quantity > product.stock) return false;

    final index = _indexOf(product);
    if (index == -1) {
      _items.add(CartItem(product: product, quantity: quantity));
    } else {
      _items[index] = _items[index].copyWith(quantity: current + quantity);
    }
    notifyListeners();
    return true;
  }

  /// Change la quantité d'une ligne. 0 ou moins supprime la ligne.
  /// TODO(back) : PATCH /cart/items/{id} { quantity }
  void setQuantity(Product product, int quantity) {
    final index = _indexOf(product);
    if (index == -1) return;

    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] =
          _items[index].copyWith(quantity: quantity.clamp(1, product.stock));
    }
    notifyListeners();
  }

  /// TODO(back) : DELETE /cart/items/{id}
  void remove(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Valide le panier.
  /// TODO(back) : POST /orders → le back crée la commande à partir du panier
  /// (statut 'pending'), calcule le total et renvoie la commande créée.
  Future<void> checkout() async {
    clear();
  }

  int _indexOf(Product product) =>
      _items.indexWhere((item) => item.product.id == product.id);
}
