import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 760;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 20 : 36, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section header
          const Text(
            'L’EXPÉRIENCE GAVE EN EAUX VIVES',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppTheme.safetyOrange,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pourquoi nous confier vos aventures de rivière ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.riverDark,
            ),
          ),
          const SizedBox(height: 32),

          // Features Grid / Wrap
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _FeatureItem(
                icon: Icons.terrain_rounded,
                title: 'Guides & Pratiquants',
                description:
                    'Notre équipe navigue au quotidien sur le gave d’Oloron et de Pau. Nous testons chaque produit en conditions réelles.',
                isCompact: isCompact,
              ),
              _FeatureItem(
                icon: Icons.verified_user_rounded,
                title: 'Normes CE & ISO 12402',
                description:
                    'Sécurité sans concession. Tous nos gilets, casques et cordes répondent aux normes européennes d’eaux vives.',
                isCompact: isCompact,
              ),
              _FeatureItem(
                icon: Icons.local_shipping_rounded,
                title: 'Transport Spécialisé Bateaux',
                description:
                    'Emballage blindé et transporteurs dédiés pour la livraison de kayaks rigides, canoës et rafts gonflables.',
                isCompact: isCompact,
              ),
              _FeatureItem(
                icon: Icons.build_circle_rounded,
                title: 'Atelier Calage & SAV',
                description:
                    'Aide au calage de siège, dossiers ergonomiques, colle néoprène et pièces détachées officielles disponibles.',
                isCompact: isCompact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isCompact;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? double.infinity : 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.riverFoam,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.riverPrimary, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.riverDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}