class Product {
  final String id;
  final String name;
  final String category; // 'kayak', 'rafting', 'canoe', 'security'
  final String brand;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> specs;
  final String? badge;
  final String imageUrl;
  final bool inStock;
  final int stock;
 
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.specs,
    this.badge,
    required this.imageUrl,
    this.inStock = true,
    this.stock = 10,
  });
}