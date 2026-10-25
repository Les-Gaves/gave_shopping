import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../pages/login_page.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';

class CartDialog extends StatelessWidget {
  const CartDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: const CartDialog(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final cart = CartService.instance;

    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        return Container(
          constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.80),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(context, cart),
              if (cart.isEmpty)
                _emptyState(context)
              else ...[
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    children: cart.items.map((item) => _cartItem(cart, item)).toList(),
                  ),
                ),
                _summary(context, cart),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, CartService cart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag_outlined, color: AppTheme.riverDark),
          const SizedBox(width: 10),
          Text(
            'Mon panier (${cart.count} article${cart.count > 1 ? 's' : ''})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.riverDark,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Fermer',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.remove_shopping_cart_outlined,
              size: 48, color: AppTheme.textMuted),
          const SizedBox(height: 12),
          const Text(
            'Votre panier est vide.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ajoutez du matériel depuis la fiche d’un produit.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continuer mes achats'),
          ),
        ],
      ),
    );
  }

  Widget _cartItem(CartService cart, CartItem item) {
    final product = item.product;

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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppTheme.riverFoam,
                  child: const Icon(Icons.kayaking_rounded,
                      color: AppTheme.riverPrimary, size: 24),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatPrice(product.price)} / unité',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _qtyButton(
                      Icons.remove,
                      () => cart.setQuantity(product, item.quantity - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    _qtyButton(
                      Icons.add,
                      item.quantity < product.stock
                          ? () => cart.setQuantity(product, item.quantity + 1)
                          : null,
                    ),
                    const Spacer(),
                    Text(
                      _formatPrice(item.subtotal),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.riverPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: AppTheme.textMuted),
            tooltip: 'Retirer du panier',
            onPressed: () => cart.remove(product),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback? onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 14,
          color: onPressed == null ? Colors.grey.shade300 : AppTheme.riverDark,
        ),
      ),
    );
  }

  Widget _summary(BuildContext context, CartService cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow('Sous-total', _formatPrice(cart.total)),
          const SizedBox(height: 6),
          _summaryRow('Livraison transporteur rivière', 'Offerte'),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total TTC',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.riverDark,
                ),
              ),
              Text(
                _formatPrice(cart.total),
                style: const TextStyle(
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
              onPressed: () => _checkout(context, cart),
              child: const Text(
                'Commander',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkout(BuildContext context, CartService cart) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // Il faut être connecté pour commander (la commande est liée à un user_id).
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Connectez-vous pour passer commande.')),
      );
      navigator.push(MaterialPageRoute(builder: (_) => const LoginPage()));
      return;
    }

    final order = await cart.checkout(userId: user.uid, userEmail: user.email);

    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Commande #${order.id} de ${_formatPrice(order.totalAmount)} enregistrée ! '
          'Retrouvez-la dans « Mes commandes ».',
        ),
        backgroundColor: AppTheme.riverPrimary,
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

  static String _formatPrice(double value) => '${value.toStringAsFixed(2)} €';
}