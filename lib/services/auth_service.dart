import 'package:firebase_auth/firebase_auth.dart';

import '../utils/json_utils.dart';
import 'api_client.dart';

/// Profil de l'utilisateur tel que le connaît le back (table `users`).
class AppUser {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String role; // 'user' ou 'admin'
  final int? cartId;

  const AppUser({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.role = 'user',
    this.cartId,
  });

  bool get isAdmin => role == 'admin';

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        email: json['email'] as String? ?? '',
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        role: json['role'] as String? ?? 'user',
        cartId: json['cart_id'] == null ? null : toInt(json['cart_id']),
      );
}

/// Utilisateur connecté et son rôle.
///
/// À chaque connexion, on appelle POST /api/users/sync : le back crée
/// l'utilisateur (et son panier) s'il n'existe pas encore, puis renvoie
/// son profil, avec son rôle. Le profil est gardé en cache.
class AuthService {
  AuthService._();

  static AppUser? _profile;
  static String? _profileUid;
  static Future<AppUser?>? _pending;

  static User? get currentUser => FirebaseAuth.instance.currentUser;

  /// Jeton à envoyer au back (géré automatiquement par ApiClient).
  static Future<String?> getIdToken() async => currentUser?.getIdToken();

  /// Profil du back pour l'utilisateur connecté (null si déconnecté
  /// ou si le back est injoignable).
  static Future<AppUser?> profile() async {
    final user = currentUser;
    if (user == null) {
      clear();
      return null;
    }
    if (_profile != null && _profileUid == user.uid) return _profile;

    // Évite d'appeler /sync plusieurs fois en parallèle.
    _pending ??= _sync(user.uid);
    try {
      return await _pending;
    } finally {
      _pending = null;
    }
  }

  static Future<AppUser?> _sync(String uid) async {
    try {
      final data = await ApiClient.post('/api/users/sync');
      _profile = AppUser.fromJson(data as Map<String, dynamic>);
      _profileUid = uid;
      return _profile;
    } on ApiException {
      return null;
    }
  }

  static Future<bool> isAdmin() async => (await profile())?.isAdmin ?? false;

  /// À appeler à la déconnexion.
  static void clear() {
    _profile = null;
    _profileUid = null;
  }
}
