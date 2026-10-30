import 'package:flutter/material.dart';

/// Catégorie d'articles (table `categories` : id, name).
///
/// L'API ne fournit que l'id et le nom : l'icône est choisie côté front
/// d'après le nom. [id] est gardé en String pour pouvoir utiliser la
/// pseudo-catégorie 'tous', qui n'existe que dans le front.
class ProductCategory {
  final String id;
  final String name;
  final IconData icon;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  /// Filtre « tout afficher » (n'existe pas en base).
  static const all = ProductCategory(
    id: 'tous',
    name: 'Tout le matériel',
    icon: Icons.grid_view_rounded,
  );

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? 'Sans nom';
    return ProductCategory(
      id: json['id'].toString(),
      name: name,
      icon: iconFor(name),
    );
  }

  static IconData iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('kayak')) return Icons.kayaking_rounded;
    if (n.contains('raft')) return Icons.waves_rounded;
    if (n.contains('cano')) return Icons.sailing_rounded;
    if (n.contains('sécu') || n.contains('secu') || n.contains('gilet')) {
      return Icons.shield_rounded;
    }
    return Icons.category_rounded;
  }
}
