import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CartDialog extends StatelessWidget {
  const CartDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CartDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.85,
        maxWidth: 520,
      ),
      margin: EdgeInsets.only(
        left: mediaQuery.size.width > 540 ? (mediaQuery.size.width - 520) / 2 : 0,
        right: mediaQuery.size.width > 540 ? (mediaQuery.size.width - 520) / 2 : 0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_bag_outlined, color: AppTheme.riverDark),
                const SizedBox(width: 10),
                const Text(
                  'Mon Panier Vitrine (3 articles)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.riverDark,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Items list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _cartItem(
                  'Pyranha Scorch Creek M',
                  'Kayak Creek Classe IV-V',
                  '1 390.00 €',
                  Icons.kayaking_rounded,
                ),
                _cartItem(
                  'Gilet Sauveteur HF Serpent 70N',
                  'Norme ISO 12402 • Taille L/XL',
                  '195.00 €',
                  Icons.shield_rounded,
                ),
                _cartItem(
                  'Pagaie Carbone Werner Player R30',
                  'Manche ergonomique 197cm',
                  '415.00 €',
                  Icons.waves_rounded,
                ),
              ],
            ),
          ),

          // Summary & Checkout
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Column(
              children: [
                _summaryRow('Sous-total', '2 000.00 €'),
                const SizedBox(height: 6),
                _summaryRow('Livraison transporteur rivière', 'Offerte (dès 150 €)'),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Total TTC',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.riverDark,
                      ),
                    ),
                    Text(
                      '2 000.00 €',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.riverDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.safetyOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Simulation de commande vitrine réussie ! (Matériel réservé au magasin du Gave)',
                          ),
                          backgroundColor: AppTheme.riverPrimary,
                        ),
                      );
                    },
                    child: const Text(
                      'Commander (Mode Vitrine)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartItem(String name, String details, String price, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.riverFoam,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.riverPrimary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  details,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.riverPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: AppTheme.textMuted),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
