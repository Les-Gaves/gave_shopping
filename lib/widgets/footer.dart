
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';

class StoreFooter extends StatelessWidget {
  final Function(String) onSelectCategory;
  final List<ProductCategory> categories;

  const StoreFooter({
    super.key,
    required this.onSelectCategory,
    this.categories = const [],
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 780;

    return Container(
      color: AppTheme.riverDark,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 48,
        vertical: 48,
      ),
      child: Column(
        children: [
          // Columns
          isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _brandColumn(),
                    const SizedBox(height: 32),
                    _categoriesColumn(),
                    const SizedBox(height: 32),
                    _storeInfoColumn(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: _brandColumn()),
                    const SizedBox(width: 32),
                    Expanded(flex: 3, child: _categoriesColumn()),
                    const SizedBox(width: 32),
                    Expanded(flex: 4, child: _storeInfoColumn()),
                  ],
                ),

          const SizedBox(height: 40),
          const Divider(color: Colors.white12),
          const SizedBox(height: 20),

          // Bottom Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '© 2026 GAVE Sports d’Eaux Vives — Projet ING3 ICC Cloud Infrastructure',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_done_rounded, color: Colors.greenAccent, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'GCP Ready • Cloud Run',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _brandColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.safetyOrange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.kayaking_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'GAVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'La boutique de référence pour l’équipement de rivière, le kayak de creek, les descentes de raft et les expéditions en canoë au cœur des Pyrénées.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _socialIcon(Icons.camera_alt_outlined),
            const SizedBox(width: 10),
            _socialIcon(Icons.video_collection_outlined),
            const SizedBox(width: 10),
            _socialIcon(Icons.facebook_outlined),
          ],
        ),
      ],
    );
  }

  Widget _categoriesColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CATALOGUE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        ...categories.map((c) => _footerLink(c.name, () => onSelectCategory(c.id))),
        _footerLink('Voir tout le matériel', () => onSelectCategory('tous')),
      ],
    );
  }

  Widget _storeInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MAGASIN DU GAVE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        _infoRow(
          Icons.location_on_outlined,
          '12 Allée des Rapides\n64400 Oloron-Sainte-Marie (Pyrénées)',
        ),
        const SizedBox(height: 10),
        _infoRow(Icons.phone_outlined, '+33 (0)5 59 00 00 00'),
        const SizedBox(height: 10),
        _infoRow(Icons.mail_outline, 'contact@gave-shopping.fr'),
        const SizedBox(height: 10),
        _infoRow(Icons.schedule_outlined, 'Mar - Sam : 09h00 - 19h00'),
      ],
    );
  }

  Widget _footerLink(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.safetyOrange, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}
