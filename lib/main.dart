import 'package:flutter/material.dart';
import 'data/mock_data.dart';
import 'models/product.dart';
import 'theme/app_theme.dart';
import 'widgets/cart_dialog.dart';
import 'widgets/category_bar.dart';
import 'widgets/features_section.dart';
import 'widgets/footer.dart';
import 'widgets/hero_banner.dart';
import 'widgets/navbar.dart';
import 'widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

  List<Product> get _filteredProducts {
    return MockData.products.where((product) {
      final matchesCategory =
          _selectedCategory == 'tous' || product.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
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
  void dispose() {
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
              onExploreSafety: () => _selectCategory('security'),
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
                    categories: MockData.categories,
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
                  if (filtered.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(48),
                      alignment: CenterAlignment.center,
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
            StoreFooter(onSelectCategory: _selectCategory),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.riverDark,
        foregroundColor: Colors.white,
        onPressed: () => CartDialog.show(context),
        icon: const Icon(Icons.shopping_bag_outlined),
        label: const Text(
          'Panier (3)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CenterAlignment {
  static const Alignment center = Alignment.center;
}
