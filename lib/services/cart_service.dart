import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'api_client.dart';
import 'order_service.dart';
import 'product_service.dart';

/// Panier de l'utilisateur connecté, via l'API.
///   - GET    /api/cart              → load()
///   - POST   /api/cart/items        → add()
///   - PUT    /api/cart/items/:id    → setQuantity()
///   - DELETE /api/cart/items/:id    → remove()
///   - POST   /api/orders            → checkout()
///
/// Le panier est stocké en base : il faut être connecté. Après chaque
/// modification, on recharge le panier pour rester aligné avec le back.
/// Les méthodes lèvent une [ApiException] en cas d'erreur (stock…).
class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  List<CartItem> _items = [];
  bool _loading = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _loading;
  bool get isEmpty => _items.isEmpty;

  /// Nombre total d'articles (somme des quantités), pour le badge.
  int get count => _items.fold(0, (sum, item) => sum + item.quantity);

  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);

  int quantityOf(Product product) => _lineOf(product)?.quantity ?? 0;

  Future<void> load() async {
    if (FirebaseAuth.instance.currentUser == null) {
      reset();
      return;
    }
    _loading = true;
    notifyListeners();
    try {
      final data = await ApiClient.get('/api/cart', auth: true) as Map<String, dynamic>;
      final lines = (data['cartItems'] as List?) ?? const [];
      _items = lines
          .map((json) => CartItem.fromJson(json as Map<String, dynamic>))
          .map(_withCatalogImage)
          .toList();
    } on ApiException {
      // On garde le dernier état connu.
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Ajoute un article (le back additionne si l'article est déjà présent).
  Future<void> add(Product product, {int quantity = 1}) async {
    _requireLogin();
    await ApiClient.post(
      '/api/cart/items',
      body: {'article_id': product.apiId, 'quantity': quantity},
    );
    await load();
  }

  /// Change la quantité d'une ligne. 0 ou moins supprime la ligne.
  Future<void> setQuantity(Product product, int quantity) async {
    final line = _lineOf(product);
    if (line?.id == null) return;
    if (quantity <= 0) return remove(product);

    await ApiClient.put('/api/cart/items/${line!.id}', body: {'quantity': quantity});
    await load();
  }

  Future<void> remove(Product product) async {
    final line = _lineOf(product);
    if (line?.id == null) return;
    await ApiClient.delete('/api/cart/items/${line!.id}');
    await load();
  }

  /// Transforme le panier en commande, puis recharge le nouveau panier (vide).
  Future<Order> checkout({required String shippingAddress}) async {
    final order = await OrderService.instance.createOrder(shippingAddress: shippingAddress);
    await load();
    return order;
  }

  /// À appeler à la déconnexion.
  void reset() {
    _items = [];
    notifyListeners();
  }

  CartItem? _lineOf(Product product) {
    for (final item in _items) {
      if (item.product.id == product.id) return item;
    }
    return null;
  }

  /// Le panier renvoie l'article sans URL d'image : on reprend celle
  /// déjà calculée pour le catalogue.
  CartItem _withCatalogImage(CartItem item) {
    for (final p in ProductService.instance.products) {
      if (p.id == item.product.id) {
        return item.copyWith(product: item.product.copyWith(imageUrl: p.imageUrl));
      }
    }
    return item;
  }

  void _requireLogin() {
    if (FirebaseAuth.instance.currentUser == null) {
      throw ApiException(401, 'Connectez-vous pour utiliser le panier.');
    }
  }
}
