import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';

class ProductDetailDialog extends StatelessWidget {
  final Product product;

  const ProductDetailDialog({super.key, required this.product});

  static void show(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailDialog(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 680;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 680),
        child: Column(
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppTheme.riverDark,
              child: Row(
                children: [
                  if (product.brand.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.safetyOrange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.brand.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    tooltip: 'Fermer',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image + Main Info
                    if (isCompact) ...[
                      _buildImage(),
                      const SizedBox(height: 16),
                      _buildMainDetails(context),
                    ] else ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: _buildImage()),
                          const SizedBox(width: 24),
                          Expanded(flex: 6, child: _buildMainDetails(context)),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      'Description technique',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.riverDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppTheme.textDark,
                      ),
                    ),

                    // Specs List (absentes pour les articles venant de l'API)
                    if (product.specs.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Spécifications & Homologation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.riverDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...product.specs.map(
                      (spec) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: AppTheme.riverTeal,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                spec,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom action bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Prix TTC',
                        style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                      Text(
                        '${product.price.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.riverDark,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.safetyOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onPressed: product.stock <= 0
                        ? null
                        : () {
                            final messenger = ScaffoldMessenger.of(context);
                            final added = CartService.instance.add(product);
                            Navigator.of(context).pop();
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  added
                                      ? '${product.name} ajouté au panier !'
                                      : 'Stock insuffisant pour ${product.name}.',
                                ),
                                backgroundColor: added
                                    ? AppTheme.riverPrimary
                                    : AppTheme.safetyOrange,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                    label: const Text('Ajouter au panier'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppTheme.riverFoam,
              child: const Center(
                child: Icon(
                  Icons.kayaking_rounded,
                  size: 60,
                  color: AppTheme.riverTeal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.badge != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.safetyOrangeLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              product.badge!,
              style: const TextStyle(
                color: AppTheme.safetyOrange,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.riverDark,
            height: 1.2,
          ),
        ),
        if (product.reviewCount > 0) ...[
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              '${product.rating}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(width: 6),
            Text(
              '(${product.reviewCount} avis certifiés)',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
          ],
        ),
        ],
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: product.stock > 0
                ? const Color(0xFFE8F5E9)
                : AppTheme.safetyOrangeLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                product.stock > 0 ? Icons.check_circle : Icons.cancel,
                size: 14,
                color: product.stock > 0 ? Colors.green : AppTheme.safetyOrange,
              ),
              const SizedBox(width: 6),
              Text(
                product.stock > 0
                    ? 'En stock (${product.stock} disponible${product.stock > 1 ? 's' : ''})'
                    : 'Rupture de stock',
                style: TextStyle(
                  color: product.stock > 0 ? Colors.green : AppTheme.safetyOrange,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
