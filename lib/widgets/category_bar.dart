import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';

class CategoryBar extends StatelessWidget {
  final List<ProductCategory> categories;
  final String selectedCategory;
  final Function(String) onSelectCategory;

  const CategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: categories.map((cat) {
            final isSelected = selectedCategory == cat.id;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () => onSelectCategory(cat.id),
                borderRadius: BorderRadius.circular(30),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.riverPrimary : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected ? AppTheme.riverPrimary : const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.riverPrimary.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cat.icon,
                        size: 18,
                        color: isSelected ? Colors.white : AppTheme.riverPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cat.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textDark,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
