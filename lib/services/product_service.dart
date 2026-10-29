import 'package:flutter/foundation.dart';

import '../models/category.dart';
import '../models/product.dart';
import 'api_client.dart';

/// Articles et catégories, chargés depuis l'API.
///   - GET /api/categories
///   - GET /api/articles
///   - GET /api/files/read-url?path=  (URL signée de chaque image)
class ProductService extends ChangeNotifier {
  ProductService._();
  static final ProductService instance = ProductService._();

  List<Product> _products = [];
  List<ProductCategory> _categories = [];
  bool _loading = false;
  String? _error;

  List<Product> get products => List.unmodifiable(_products);

  /// Catégories de la base (sans le filtre 'tous').
  List<ProductCategory> get categories => List.unmodifiable(_categories);

  bool get isLoading => _loading;
  String? get error => _error;

  String categoryName(String id) => _categories
      .firstWhere((c) => c.id == id, orElse: () => ProductCategory.all)
      .name;

  Future<void> loadProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        ApiClient.get('/api/categories'),
        ApiClient.get('/api/articles'),
      ]);

      _categories = (results[0] as List)
          .map((json) => ProductCategory.fromJson(json as Map<String, dynamic>))
          .toList();

      final products = (results[1] as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      // Les images sont privées dans le bucket : on demande une URL signée
      // pour chaque article qui en a une (sinon image par défaut).
      _products = await Future.wait(products.map(_withImageUrl));
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Impossible de charger le catalogue.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Product> _withImageUrl(Product product) async {
    final path = product.imagePath;
    if (path == null || path.isEmpty) return product;
    try {
      final data = await ApiClient.get('/api/files/read-url', query: {'path': path});
      return product.copyWith(imageUrl: data['url'] as String);
    } catch (_) {
      return product;
    }
  }

  /// TODO(étape 4) : remplacer par POST /api/articles (+ upload de l'image).
  /// Pour l'instant, l'article n'est ajouté qu'à la liste locale.
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
      description: description,
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
