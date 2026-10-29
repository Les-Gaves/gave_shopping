import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  /// Crée un article (admin) : POST /api/articles.
  /// Si une image est fournie, elle est d'abord envoyée dans le bucket :
  ///   1. POST /api/files/upload-url → URL signée + chemin
  ///   2. PUT de l'image directement sur cette URL
  ///   3. le chemin est transmis à la création (image_path)
  /// Le catalogue est ensuite rechargé.
  Future<Product> addProduct({
    required String name,
    required int categoryId,
    required String description,
    required double price,
    required int stock,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    String? imagePath;
    if (imageBytes != null && imageName != null) {
      imagePath = await _uploadImage(imageBytes, imageName);
    }

    final data = await ApiClient.post('/api/articles', body: {
      'name': name,
      'category_id': categoryId,
      'description': description,
      'price': price,
      'stock': stock,
      if (imagePath != null) 'image_path': imagePath,
    });

    final created = Product.fromJson(data as Map<String, dynamic>);
    await loadProducts();
    return created;
  }

  Future<String> _uploadImage(Uint8List bytes, String filename) async {
    final contentType = _contentTypeOf(filename);
    final data = await ApiClient.post('/api/files/upload-url', body: {
      'filename': filename,
      'content_type': contentType,
    }) as Map<String, dynamic>;

    try {
      final response = await http.put(
        Uri.parse(data['upload_url'] as String),
        headers: {'Content-Type': contentType},
        body: bytes,
      );
      if (response.statusCode >= 300) {
        throw ApiException(response.statusCode, "Échec de l'envoi de l'image.");
      }
    } on ApiException {
      rethrow;
    } catch (_) {
      // Souvent : CORS non configuré sur le bucket.
      throw ApiException(0, "Échec de l'envoi de l'image vers le stockage.");
    }
    return data['path'] as String;
  }

  static String _contentTypeOf(String filename) {
    final name = filename.toLowerCase();
    if (name.endsWith('.png')) return 'image/png';
    if (name.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
