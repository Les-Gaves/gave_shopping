import '../utils/json_utils.dart';

/// Article (table `articles`).
///
/// Champs venant de l'API : id, name, categoryId, description, imagePath,
/// price, stock. [imageUrl] est calculé côté front (URL signée du bucket).
class Product {
  static const defaultImageUrl =
      'https://storage.googleapis.com/images_gave/istockphoto-1980276924-612x612.jpg';

  final String id;
  final String name;
  final String category; // id de la catégorie, en texte ('3')
  final double price;
  final String description;
  final String imageUrl;
  final String? imagePath; // chemin dans le bucket (ex: articles/xxx.jpg)
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.description = '',
    required this.imageUrl,
    this.imagePath,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'].toString(),
        name: json['name'] as String? ?? '',
        category: json['categoryId']?.toString() ?? '',
        price: toDouble(json['price']),
        description: json['description'] as String? ?? '',
        imagePath: json['imagePath'] as String?,
        imageUrl: defaultImageUrl,
        stock: toInt(json['stock']),
      );

  /// Id numérique attendu par l'API (article_id).
  int get apiId => int.parse(id);

  Product copyWith({String? imageUrl}) => Product(
        id: id,
        name: name,
        category: category,
        price: price,
        description: description,
        imageUrl: imageUrl ?? this.imageUrl,
        imagePath: imagePath,
        stock: stock,
      );
}
