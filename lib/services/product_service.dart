import 'package:flutter/foundation.dart';
import '../data/mock_data.dart';
import '../models/product.dart';

/// Point d'accès unique aux articles.
///
/// Pour l'instant, les articles sont gardés en mémoire (initialisés depuis
/// MockData). Quand le back sera prêt, il suffira de remplacer le contenu de
/// [loadProducts] et [addProduct] par des appels HTTP (GET /articles,
/// POST /articles) : les écrans n'auront pas à changer.
class ProductService extends ChangeNotifier {
  ProductService._();
  static final ProductService instance = ProductService._();

  final List<Product> _products = List.of(MockData.products);

  List<Product> get products => List.unmodifiable(_products);

  /// TODO(back) : remplacer par GET /articles.
  Future<void> loadProducts() async {
    notifyListeners();
  }

  /// TODO(back) : remplacer par POST /articles avec le token Firebase
  /// dans l'en-tête Authorization. Le back renverra l'article créé (avec son id).
  Future<Product> addProduct({
    required String name,
    required String category,
    required String brand,
    required String description,
    required double price,
    required int stock,
    required String imageUrl,
  }) async {
    final product = Product(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      category: category,
      brand: brand,
      price: price,
      rating: 0,
      reviewCount: 0,
      description: description,
      specs: const [],
      badge: 'Nouveau',
      imageUrl: imageUrl,
      inStock: stock > 0,
      stock: stock,
    );

    _products.insert(0, product);
    notifyListeners();
    return product;
  }
}
