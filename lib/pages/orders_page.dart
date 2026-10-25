import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/auth_service.dart';
import '../services/order_service.dart';
import '../theme/app_theme.dart';

/// Historique des commandes.
/// - Utilisateur : uniquement ses propres commandes.
/// - Admin : toutes les commandes, avec le client et la possibilité
///   de changer le statut.
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<bool>(
      future: AuthService.isAdmin(),
      builder: (context, adminSnapshot) {
        final isAdmin = adminSnapshot.data ?? false;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isAdmin ? 'Toutes les commandes' : 'Mes commandes',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppTheme.riverDark,
              ),
            ),
          ),
          body: user == null
              ? const _Message(
                  icon: Icons.lock_outline,
                  title: 'Vous n’êtes pas connecté.',
                  subtitle: 'Connectez-vous pour voir vos commandes.',
                )
              : !adminSnapshot.hasData
                  ? const Center(child: CircularProgressIndicator())
                  : ListenableBuilder(
                      listenable: OrderService.instance,
                      builder: (context, _) {
                        final orders = isAdmin
                            ? OrderService.instance.allOrders
                            : OrderService.instance.ordersOf(user.uid);

                        if (orders.isEmpty) {
                          return const _Message(
                            icon: Icons.receipt_long_outlined,
                            title: 'Aucune commande pour le moment.',
                            subtitle:
                                'Vos commandes apparaîtront ici après validation du panier.',
                          );
                        }

                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 760),
                            child: ListView.separated(
                              padding: const EdgeInsets.all(20),
                              itemCount: orders.length + 1,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Text(
                                    '${orders.length} commande${orders.length > 1 ? 's' : ''}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textMuted,
                                    ),
                                  );
                                }
                                return _OrderCard(
                                  order: orders[index - 1],
                                  isAdmin: isAdmin,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final bool isAdmin;

  const _OrderCard({required this.order, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // Retire les traits de séparation par défaut de l'ExpansionTile.
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Row(
            children: [
              Text(
                'Commande #${order.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.riverDark,
                ),
              ),
              const SizedBox(width: 10),
              _StatusChip(status: order.status),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              [
                _formatDate(order.orderedAt),
                '${order.itemCount} article${order.itemCount > 1 ? 's' : ''}',
                if (isAdmin) order.userEmail ?? order.userId,
              ].join(' • '),
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
          ),
          trailing: Text(
            _formatPrice(order.totalAmount),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppTheme.riverDark,
            ),
          ),
          children: [
            const Divider(),
            const SizedBox(height: 4),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${item.quantity} ×',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.riverPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item.product.name, style: const TextStyle(fontSize: 13)),
                    ),
                    Text(
                      _formatPrice(item.subtotal),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (order.shippingAddress != null)
              _infoLine(Icons.location_on_outlined, order.shippingAddress!),
            _infoLine(
              Icons.event_available_outlined,
              order.validatedAt != null
                  ? 'Validée le ${_formatDate(order.validatedAt!)}'
                  : 'Pas encore validée',
            ),
            if (isAdmin) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Changer le statut :',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<OrderStatus>(
                    value: order.status,
                    items: OrderStatus.values
                        .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                        .toList(),
                    onChanged: (status) {
                      if (status != null) {
                        OrderService.instance.updateStatus(order.id, status);
                      }
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppTheme.textMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;

  const _StatusChip({required this.status});

  Color get _color {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFB7791F);
      case OrderStatus.paid:
      case OrderStatus.processing:
        return AppTheme.riverPrimary;
      case OrderStatus.shipped:
        return AppTheme.riverTeal;
      case OrderStatus.delivered:
        return const Color(0xFF2E7D32);
      case OrderStatus.cancelled:
      case OrderStatus.refunded:
        return const Color(0xFFBA1A1A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _color),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _Message({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: AppTheme.textMuted),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatPrice(double value) => '${value.toStringAsFixed(2)} €';

String _formatDate(DateTime d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.day)}/${two(d.month)}/${d.year} à ${two(d.hour)}h${two(d.minute)}';
}
