import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/category.dart';
import 'models/product.dart';
import 'config/api_config.dart';
import 'theme/app_theme.dart';
import 'widgets/cart_dialog.dart';
import 'widgets/category_bar.dart';
import 'widgets/features_section.dart';
import 'widgets/footer.dart';
import 'widgets/hero_banner.dart';
import 'widgets/navbar.dart';
import 'widgets/product_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/product_service.dart';
import 'services/cart_service.dart';
import 'services/auth_service.dart';
import 'services/order_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ApiConfig.load();
  runApp(const GaveApp());
}

class GaveApp extends StatelessWidget {
  const GaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GAVE • Boutique Eaux Vives (Kayak, Rafting, Canoë)',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'tous';
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _catalogKey = GlobalKey();
  StreamSubscription<User?>? _authSub;

  List<Product> get _filteredProducts {
    return ProductService.instance.products.where((product) {
      final matchesCategory =
          _selectedCategory == 'tous' || product.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _scrollToCatalog() {
    final context = _catalogKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  void _selectCategory(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      _searchQuery = '';
    });
    _scrollToCatalog();
  }

  @override
  void initState() {
    super.initState();
    ProductService.instance.addListener(_onProductsChanged);
    ProductService.instance.loadProducts();

    // À chaque connexion : synchronise l'utilisateur avec le back
    // (POST /api/users/sync), puis charge son panier.
    // À la déconnexion : vide le panier et les commandes affichés.
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        AuthService.clear();
        CartService.instance.reset();
        OrderService.instance.reset();
      } else {
        await AuthService.profile();
        await CartService.instance.load();
      }
    });
  }

  /// Ouvre la catégorie « sécurité » si elle existe en base, sinon le catalogue.
  void _openSafetyCategory() {
    final safety = ProductService.instance.categories.where((c) {
      final n = c.name.toLowerCase();
      return n.contains('sécu') || n.contains('secu') || n.contains('gilet');
    });
    if (safety.isNotEmpty) {
      _selectCategory(safety.first.id);
    } else {
      _scrollToCatalog();
    }
  }

  void _onProductsChanged() => setState(() {});

  @override
  void dispose() {
    _authSub?.cancel();
    ProductService.instance.removeListener(_onProductsChanged);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
    } else if (screenWidth >= 880) {
      crossAxisCount = 3;
    } else if (screenWidth >= 560) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    final filtered = _filteredProducts;

    return Scaffold(
      appBar: StoreNavBar(
        categories: ProductService.instance.categories,
        activeCategory: _selectedCategory,
        onSelectCategory: _selectCategory,
        onOpenCart: () => CartDialog.show(context),
        onSearch: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Hero Banner
            HeroBanner(
              onExploreCatalog: _scrollToCatalog,
              onExploreSafety: _openSafetyCategory,
            ),

            // Main Catalog Area
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth < 700 ? 16 : 40,
                vertical: 32,
              ),
              child: Column(
                key: _catalogKey,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.water_rounded, color: AppTheme.riverTeal, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'VITRINE DU MATÉRIEL',
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.4,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.riverTeal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Équipements pour rivière & rapides',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.riverDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (screenWidth >= 650) ...[
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.riverFoam,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${filtered.length} article(s) disponible(s)',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.riverPrimary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Category Filter Chips
                  CategoryBar(
                    categories: [ProductCategory.all, ...ProductService.instance.categories],
                    selectedCategory: _selectedCategory,
                    onSelectCategory: (catId) {
                      setState(() {
                        _selectedCategory = catId;
                      });
                    },
                  ),

                  const SizedBox(height: 28),

                  // Active search or filter notice
                  if (_searchQuery.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Text(
                            'Résultats pour "$_searchQuery" :',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () => setState(() => _searchQuery = ''),
                            child: const Text('Effacer le filtre'),
                          ),
                        ],
                      ),
                    ),

                  // Products Grid
                  if (ProductService.instance.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (ProductService.instance.error != null)
                    Container(
                      padding: const EdgeInsets.all(48),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cloud_off_rounded, size: 54, color: AppTheme.textMuted),
                          const SizedBox(height: 14),
                          const Text(
                            'Impossible de charger le catalogue.',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ProductService.instance.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: ProductService.instance.loadProducts,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    )
                  else if (filtered.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(48),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off_rounded, size: 54, color: AppTheme.textMuted),
                          const SizedBox(height: 14),
                          const Text(
                            'Aucun équipement trouvé.',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Essayez de sélectionner une autre catégorie ou de modifier vos mots-clés.',
                            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = 'tous';
                                _searchQuery = '';
                              });
                            },
                            child: const Text('Voir tout le matériel'),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 22,
                        childAspectRatio: crossAxisCount == 1 ? 1.25 : 0.72,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(product: filtered[index]);
                      },
                    ),

                  const SizedBox(height: 48),

                  // Brand Features Banner
                  const FeaturesSection(),
                ],
              ),
            ),

            // Footer
            StoreFooter(
              onSelectCategory: _selectCategory,
              categories: ProductService.instance.categories,
            ),
          ],
        ),
      ),
      floatingActionButton: ListenableBuilder(
        listenable: CartService.instance,
        builder: (context, _) => FloatingActionButton.extended(
          backgroundColor: AppTheme.riverDark,
          foregroundColor: Colors.white,
          onPressed: () => CartDialog.show(context),
          icon: const Icon(Icons.shopping_bag_outlined),
          label: Text(
            'Panier (${CartService.instance.count})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
