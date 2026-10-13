import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import 'product_detail_dialog.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered
                ? AppTheme.riverTeal.withValues(alpha: 0.5)
                : const Color(0xFFE2E8F0),
            width: isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? AppTheme.riverDark.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: isHovered ? 16 : 8,
              offset: Offset(0, isHovered ? 8 : 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => ProductDetailDialog.show(context, product),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section with badges
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.35,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.riverFoam,
                          child: const Center(
                            child: Icon(
                              Icons.kayaking_rounded,
                              size: 48,
                              color: AppTheme.riverTeal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Badge on top-left
                  if (product.badge != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.safetyOrange,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          product.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Favorite Heart Button on top-right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          setState(() => isFavorite = !isFavorite);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFavorite ? Colors.red : AppTheme.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Product Info Body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand
                      Text(
                        product.brand.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppTheme.riverTeal,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Name
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.riverDark,
                          height: 1.25,
                        ),
                      ),

                      const Spacer(),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          const SizedBox(width: 3),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewCount})',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Price & Action Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${product.price.toStringAsFixed(0)} €',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.riverDark,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isHovered ? AppTheme.riverPrimary : AppTheme.riverFoam,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Détails',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isHovered ? Colors.white : AppTheme.riverPrimary,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.chevron_right,
                                  size: 14,
                                  color: isHovered ? Colors.white : AppTheme.riverPrimary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
