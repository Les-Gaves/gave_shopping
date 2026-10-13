import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';

class MockData {
  static const List<ProductCategory> categories = [
    ProductCategory(
      id: 'tous',
      name: 'Tout le matériel',
      icon: Icons.grid_view_rounded,
      description: 'Explorer toute la gamme Gave pour les rapides et rivières.',
    ),
    ProductCategory(
      id: 'kayak',
      name: 'Kayak',
      icon: Icons.kayaking_rounded,
      description: 'Creek, freestyle et descente pour affronter les rapides.',
    ),
    ProductCategory(
      id: 'rafting',
      name: 'Rafting',
      icon: Icons.waves_rounded,
      description: 'Bateaux d’équipage, pagayeurs et guides de torrent.',
    ),
    ProductCategory(
      id: 'canoe',
      name: 'Canoë',
      icon: Icons.sailing_rounded,
      description: 'Canoës ouverts traditionnels et gonflables d’expédition.',
    ),
    ProductCategory(
      id: 'security',
      name: 'Sécurité & Gilet',
      icon: Icons.shield_rounded,
      description: 'Gilets 70N, casques certifiés et cordes de rappel indispensables.',
    ),
  ];

  static const List<Product> products = [
    Product(
      id: 'prod-kayak-01',
      name: 'Pyranha Scorch Creek M',
      category: 'kayak',
      brand: 'Pyranha',
      price: 1390.0,
      rating: 4.9,
      reviewCount: 38,
      badge: 'Bestseller Creek',
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=900&q=80',
      description:
          'Le Scorch est le kayak de creek ultime conçu pour garder sa vitesse sur les chutes et traverser les rouleaux puissants sans dévier. Rocker agressif et stabilité secondaire exceptionnelle.',
      specs: [
        'Longueur : 267 cm',
        'Largeur : 65 cm',
        'Volume : 303 L',
        'Poids pagayeur conseillé : 65 - 95 kg',
        'Coque : Polyéthylène haute densité rotomoulé',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-kayak-02',
      name: 'Jackson Kayak Rockstar V',
      category: 'kayak',
      brand: 'Jackson Kayak',
      price: 1280.0,
      rating: 4.8,
      reviewCount: 24,
      badge: 'Freestyle Pro',
      imageUrl:
          'https://images.unsplash.com/photo-1517649763962-0c623266ddc0?auto=format&fit=crop&w=900&q=80',
      description:
          'Une machine à figures. Pointes taillées pour les loops aériens, cartwheels et cartouches rapides dans la vague du gave. Siège ergonomique Sweet Cheeks ultra-confort.',
      specs: [
        'Longueur : 178 cm',
        'Volume : 225 L',
        'Poids du bateau : 13.5 kg',
        'Usage : Vagues et rouleaux d’eaux vives',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-raft-01',
      name: 'Gumotex Pulsar 380 Pro',
      category: 'rafting',
      brand: 'Gumotex',
      price: 2790.0,
      rating: 5.0,
      reviewCount: 19,
      badge: 'Guide de Rivière',
      imageUrl:
          'https://images.unsplash.com/photo-1530866495561-507c9faab2ed?auto=format&fit=crop&w=900&q=80',
      description:
          'Raft autovideur conçu pour les équipages de 5 à 7 personnes. Tissu ultra-résistant Nitrilon résistant aux chocs sur rochers et aux frottements violents.',
      specs: [
        'Capacité : 6-7 personnes',
        'Longueur : 380 cm',
        'Largeur : 178 cm',
        'Poids : 44 kg',
        'Matériau : Nitrilon renforcé 1100 dTex',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-raft-02',
      name: 'Pack Pagaies Raft TNP Pro (Lot de 6)',
      category: 'rafting',
      brand: 'TNP Sports',
      price: 289.0,
      rating: 4.7,
      reviewCount: 42,
      badge: 'Équipement Club',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=900&q=80',
      description:
          'Lot de 6 pagaies simples de rafting ultra-robustes. Manche en duralumin anodisé avec grip thermoformé et pale en polyéthylène injecté résistant à l’impact.',
      specs: [
        'Manche : Aluminium haute résistance 30mm',
        'Longueur : 150 cm',
        'Poignée ergonomique en T',
        'Couleur haute visibilité jaune/noir',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-canoe-01',
      name: 'Old Town Discovery 158',
      category: 'canoe',
      brand: 'Old Town',
      price: 1190.0,
      rating: 4.9,
      reviewCount: 31,
      badge: 'Légende Rivière',
      imageUrl:
          'https://images.unsplash.com/photo-1508873696983-2df5293cb32f?auto=format&fit=crop&w=900&q=80',
      description:
          'Le canoë canadien de référence pour les balades et bivouacs en rivière. Fabriqué en matériau Three-Layer Polyethylene indestructible avec assises en nylon tressé confortables.',
      specs: [
        'Longueur : 480 cm',
        'Largeur : 90 cm',
        'Capacité de charge : 476 kg (2-3 personnes + sacs)',
        'Poids : 39 kg',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-canoe-02',
      name: 'Sevylor Ottawa Gonflable 2+1',
      category: 'canoe',
      brand: 'Sevylor',
      price: 649.0,
      rating: 4.6,
      reviewCount: 56,
      badge: 'Polyvalent Famille',
      imageUrl:
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80',
      description:
          'Canoë gonflable spacieux pour deux adultes et un enfant. Coque profilée avec dérive amovible pour une excellente tenue de cap sur rivière calme et lac.',
      specs: [
        'Dimensions : 383 x 92 cm',
        'Poids : 20.1 kg',
        'Charge max : 225 kg',
        'Sièges surélevés avec soutien lombaire',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-sec-01',
      name: 'Gilet Sauveteur HF Serpent 70N',
      category: 'security',
      brand: 'HF Safety',
      price: 195.0,
      rating: 5.0,
      reviewCount: 67,
      badge: 'Norme ISO 12402',
      imageUrl:
          'https://images.unsplash.com/photo-1516762689617-e1cffcef479d?auto=format&fit=crop&w=900&q=80',
      description:
          'Gilet d’aide à la flottabilité pour kayakistes de rivière et guides de rafting. Équipé d’un largueur de sécurité rapide, sangle de poitrine et poches VHF/mousqueton.',
      specs: [
        'Flottabilité : 70 Newtons',
        'Certification : CE ISO 12402-5 / 12402-6',
        'Harnais largable avec anneau inox',
        'Mousse Airex multicouche préformée',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-sec-02',
      name: 'Casque Eaux Vives WRSI Current Pro',
      category: 'security',
      brand: 'WRSI Safety',
      price: 145.0,
      rating: 4.8,
      reviewCount: 29,
      badge: 'Protection Choc',
      imageUrl:
          'https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=900&q=80',
      description:
          'Conçu par des ingénieurs et médecins de traumatologie sportive. Coque multicouche avec sous-calotte EVA et protège-oreilles amovibles pour parer les blocs rocheux.',
      specs: [
        'Homologation : CE EN 1385 (Sports d’eaux vives)',
        'Coque extérieure : ABS composite',
        'Visière souple intégrée',
        'Système d’ajustement O-Range occipital',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-sec-03',
      name: 'Corde de Sécurité Palm Pro Throwline 20m',
      category: 'security',
      brand: 'Palm Equipment',
      price: 85.0,
      rating: 4.9,
      reviewCount: 52,
      badge: 'Indispensable',
      imageUrl:
          'https://images.unsplash.com/photo-1502680390469-be75c86b636f?auto=format&fit=crop&w=900&q=80',
      description:
          'Sac de sauvetage à lancer avec corde flottante haute visibilité de 11 mm. Résistance à la rupture de 10 kN, col conique pour un rembobinage rapide au bord des courants.',
      specs: [
        'Longueur : 20 mètres',
        'Diamètre : 11 mm corde polypropylène flottante',
        'Charge de rupture : 1000 kg (10 kN)',
        'Boucles réfléchissantes et point d’attache ceinture',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-kayak-03',
      name: 'Pagaie Carbone Werner Player R30',
      category: 'kayak',
      brand: 'Werner Paddles',
      price: 415.0,
      rating: 5.0,
      reviewCount: 88,
      badge: 'Performance Légère',
      imageUrl:
          'https://images.unsplash.com/photo-1472396961693-142e6e269027?auto=format&fit=crop&w=900&q=80',
      description:
          'La référence mondiale pour pagayer fort et précis. Pales asymétriques en carbone compressé offrant une relance nerveuse sans fatigue articulaire dans les vagues.',
      specs: [
        'Manche : Carbone ergonomique courbé 197 cm',
        'Angle de croisement : 30° / 45° réglable',
        'Poids total : 785 grammes',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-sec-04',
      name: 'Combinaison Étanche Kokatat Hydrus 3L',
      category: 'security',
      brand: 'Kokatat',
      price: 899.0,
      rating: 4.9,
      reviewCount: 15,
      badge: 'Navigation Hiver',
      imageUrl:
          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&w=900&q=80',
      description:
          'Combinaison sèche intégrale 3 couches respirante avec manchons latex et chaussettes intégrées. Conçue pour pagayer au chaud même dans les eaux de fonte pyrénéennes.',
      specs: [
        'Membrane : Hydrus 3.0 imper-respirante',
        'Renforts genoux et fesses en Cordura',
        'Fermeture éclair d’aisance étanche',
      ],
      inStock: true,
    ),
    Product(
      id: 'prod-sec-05',
      name: 'Sac Étanche Ortlieb Duffle RS 85L',
      category: 'security',
      brand: 'Ortlieb',
      price: 219.0,
      rating: 4.8,
      reviewCount: 34,
      badge: '100% Imperméable',
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=900&q=80',
      description:
          'Grand sac d’expédition étanche IP67 avec bretelles de portage sac à dos amovibles et roulettes tout-terrain pour le transport de tout votre équipement au camp de base.',
      specs: [
        'Volume : 85 Litres',
        'Norme étanchéité : IP67 (submersible temporairement)',
        'Tissu : PD620 ultra-résistant sans PVC',
      ],
      inStock: true,
    ),
  ];
}
