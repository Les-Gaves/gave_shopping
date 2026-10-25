import 'package:firebase_auth/firebase_auth.dart';

/// Infos liées à l'utilisateur connecté.
///
/// Le rôle (user / admin) sera fourni par le back via GET /me.
/// En attendant, tout utilisateur connecté est considéré comme admin
/// pour pouvoir développer et tester la page d'ajout d'article.
class AuthService {
  AuthService._();

  static User? get currentUser => FirebaseAuth.instance.currentUser;

  /// Jeton à envoyer au back dans l'en-tête :
  /// Authorization: Bearer <token>
  static Future<String?> getIdToken() async {
    return currentUser?.getIdToken();
  }

  /// TODO(back) : appeler GET /me et renvoyer `role == 'admin'`.
  static Future<bool> isAdmin() async {
    return currentUser != null;
  }
}
