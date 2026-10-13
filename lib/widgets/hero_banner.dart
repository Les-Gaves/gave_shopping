import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HeroBanner extends StatelessWidget {
  final VoidCallback onExploreCatalog;
  final VoidCallback onExploreSafety;

  const HeroBanner({
    super.key,
    required this.onExploreCatalog,
    required this.onExploreSafety,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 700;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF092935),
            Color(0xFF0D4B5E),
            Color(0xFF14697F),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative water wave circles in background
          Positioned(
            right: -80,
            bottom: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            right: 100,
            top: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.safetyOrange.withValues(alpha: 0.06),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 20 : 48,
              vertical: isCompact ? 36 : 56,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pill badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.bolt, color: AppTheme.safetyOrange, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'BOUTIQUE PYRÉNÉES • EAUX VIVES & EXPÉDITION',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Main headline
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 750),
                  child: Text(
                    'Domptez les rapides avec du matériel de rivière d’élite.',
                    style: TextStyle(
                      fontSize: isCompact ? 28 : 42,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Subtitle
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Text(
                    'Spécialiste kayak de creek, rafts d’équipage, canoës d’expédition et sécurité rivière homologuée CE. Éprouvé sur les gaves et torrents les plus exigeants.',
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Buttons row
                Wrap(
                  spacing: 14,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onExploreCatalog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.safetyOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.explore_outlined, size: 20),
                      label: const Text(
                        'Découvrir le catalogue',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: onExploreSafety,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.shield_outlined, size: 20),
                      label: const Text(
                        'Pack Sécurité 70N',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // Quick guarantees bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 10,
                    children: const [
                      _QuickPill(icon: Icons.check_circle_outline, text: 'Matériel homologué ISO/CE'),
                      _QuickPill(icon: Icons.local_shipping_outlined, text: 'Livraison spécialisée volumineux'),
                      _QuickPill(icon: Icons.water_drop_outlined, text: 'Testé en rapides classe IV-V'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _QuickPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.safetyOrange),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
