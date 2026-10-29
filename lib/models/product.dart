import '../utils/json_utils.dart';

/// Article (table `articles`).
///
/// Champs venant de l'API : id, name, categoryId, description, imagePath,
/// price, stock. Les champs [brand], [rating], [reviewCount], [specs] et
/// [badge] n'existent pas en base : ils restent vides pour les articles de
/// l'API (et ne sont utilisés que par les données de démo).
class Product {
  static const defaultImageUrl =
      'https://storage.googleapis.com/images_gave/istockphoto-1980276924-612x612.jpg';

  final String id;
  final String name;
  final String category; // id de la catégorie, en texte ('3')
  final String brand;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> specs;
  final String? badge;
  final String imageUrl;
  final String? imagePath; // chemin dans le bucket (ex: articles/xxx.jpg)
  final bool inStock;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    this.brand = '',
    required this.price,
    this.rating = 0,
    this.reviewCount = 0,
    this.description = '',
    this.specs = const [],
    this.badge,
    required this.imageUrl,
    this.imagePath,
    this.inStock = true,
    this.stock = 10,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final stock = toInt(json['stock']);
    return Product(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      category: json['categoryId']?.toString() ?? '',
      price: toDouble(json['price']),
      description: json['description'] as String? ?? '',
      imagePath: json['imagePath'] as String?,
      imageUrl: defaultImageUrl,
      stock: stock,
      inStock: stock > 0,
    );
  }

  /// Id numérique attendu par l'API (article_id).
  int get apiId => int.parse(id);

  Product copyWith({String? imageUrl}) => Product(
        id: id,
        name: name,
        category: category,
        brand: brand,
        price: price,
        rating: rating,
        reviewCount: reviewCount,
        description: description,
        specs: specs,
        badge: badge,
        imageUrl: imageUrl ?? this.imageUrl,
        imagePath: imagePath,
        inStock: inStock,
        stock: stock,
      );
}
