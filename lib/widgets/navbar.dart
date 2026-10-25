import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/login_page.dart';
import '../pages/add_article_page.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';

class StoreNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String activeCategory;
  final Function(String) onSelectCategory;
  final VoidCallback onOpenCart;
  final Function(String)? onSearch;

  const StoreNavBar({
    super.key,
    required this.activeCategory,
    required this.onSelectCategory,
    required this.onOpenCart,
    this.onSearch,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 860;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SafeArea(
        child: Row(
          children: [
            // Logo + Brand Name
            InkWell(
              onTap: () => onSelectCategory('tous'),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'logo-name.png',
                      height: 44,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.riverPrimary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.kayaking_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'GAVE',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: AppTheme.riverDark,
                        ),
                      ),
                      Text(
                        'EAUX VIVES & EXPÉDITION',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.safetyOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 24),

            // Navigation links for Desktop
            if (isDesktop) ...[
              const SizedBox(width: 16),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _navLink('Accueil', 'tous'),
                      _navLink('Kayaks', 'kayak'),
                      _navLink('Rafting', 'rafting'),
                      _navLink('Canoës', 'canoe'),
                      _navLink('Sécurité', 'security'),
                    ],
                  ),
                ),
              ),
            ],

            const Spacer(),

            // Search bar
            if (isDesktop)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220, minWidth: 140),
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      prefixIcon: const Icon(Icons.search, size: 18, color: AppTheme.textMuted),
                      filled: true,
                      fillColor: AppTheme.surfaceLight,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.search, color: AppTheme.riverDark),
                tooltip: 'Recherche',
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: _StoreSearchDelegate(onSelectCategory),
                  );
                },
              ),

            const SizedBox(width: 8),

            // Panier action button
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  tooltip: 'Panier vitrine',
                  icon: const Icon(Icons.shopping_bag_outlined, color: AppTheme.riverDark),
                  onPressed: onOpenCart,
                ),
                ListenableBuilder(
                  listenable: CartService.instance,
                  builder: (context, _) {
                    final count = CartService.instance.count;
                    if (count == 0) return const SizedBox.shrink();
                    return Positioned(
                      top: 6,
                      right: 6,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.safetyOrange,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            count > 99 ? '99+' : '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            _accountButton(context, isDesktop),
            const SizedBox(width: 8),

          ],
        ),
      ),
    );
  }

  Widget _navLink(String label, String categoryId) {
    final isSelected = activeCategory == categoryId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () => onSelectCategory(categoryId),
        style: TextButton.styleFrom(
          foregroundColor: isSelected ? AppTheme.riverPrimary : AppTheme.textDark,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 20,
                color: AppTheme.safetyOrange,
              ),
          ],
        ),
      ),
    );
  }

  Widget _accountButton(BuildContext context, bool isDesktop) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user == null) {
          void openLogin() => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
          return isDesktop
              ? TextButton.icon(
                  onPressed: openLogin,
                  icon: const Icon(Icons.person_outline, size: 20),
                  label: const Text('Se connecter'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.riverDark,
                  ),
                )
              : IconButton(
                  tooltip: 'Se connecter',
                  icon: const Icon(Icons.person_outline,
                      color: AppTheme.riverDark),
                  onPressed: openLogin,
                );
        }

        return FutureBuilder<bool>(
          future: AuthService.isAdmin(),
          builder: (context, adminSnapshot) {
            final isAdmin = adminSnapshot.data ?? false;

            return PopupMenuButton<String>(
              tooltip: user.email ?? 'Compte',
              icon: const Icon(Icons.account_circle, color: AppTheme.riverPrimary),
              onSelected: (value) {
                if (value == 'logout') FirebaseAuth.instance.signOut();
                if (value == 'add_article') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddArticlePage()),
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  enabled: false,
                  child: Text(user.email ?? 'Connecté'),
                ),
                const PopupMenuDivider(),
                if (isAdmin)
                  const PopupMenuItem<String>(
                    value: 'add_article',
                    child: Row(
                      children: [
                        Icon(Icons.add_box_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Ajouter un article'),
                      ],
                    ),
                  ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Se déconnecter'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _StoreSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSelectCategory;
  _StoreSearchDelegate(this.onSelectCategory);

  @override
  String get searchFieldLabel => 'Rechercher kayak, raft, gilet...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Recherche : "$query"'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = ['Kayak Creek', 'Raft 6 places', 'Gilet 70N', 'Pagaie carbone', 'Canoë canadien'];
    final filtered = suggestions.where((s) => s.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.water),
          title: Text(filtered[index]),
          onTap: () {
            close(context, filtered[index]);
          },
        );
      },
    );
  }
}