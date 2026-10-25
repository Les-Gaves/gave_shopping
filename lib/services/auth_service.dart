import 'package:firebase_auth/firebase_auth.dart';

/// Infos liées à l'utilisateur connecté.
///
/// Le rôle (user / admin) sera fourni par le back via GET /me.
/// En attendant, un utilisateur est admin si son e-mail est dans
/// [_mockAdminEmails]. Les autres comptes sont de simples utilisateurs,
/// ce qui permet de tester les deux vues.
class AuthService {
  AuthService._();

  /// TODO(back) : à supprimer quand GET /me renverra le rôle.
  /// Mettez ici l'e-mail du compte avec lequel vous testez la vue admin.
  static const List<String> _mockAdminEmails = [
    'admin@gave.fr',
  ];

  static User? get currentUser => FirebaseAuth.instance.currentUser;

  /// Jeton à envoyer au back dans l'en-tête :
  /// Authorization: Bearer <token>
  static Future<String?> getIdToken() async {
    return currentUser?.getIdToken();
  }

  /// TODO(back) : appeler GET /me et renvoyer `role == 'admin'`.
  static Future<bool> isAdmin() async {
    final email = currentUser?.email?.toLowerCase();
    if (email == null) return false;
    return _mockAdminEmails.map((e) => e.toLowerCase()).contains(email);
  }
}