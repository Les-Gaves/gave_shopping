import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Adresse de l'API back.
///
/// En production : lue au démarrage dans /config.json, que Nginx remplit
/// avec la variable d'environnement API_URL du service Cloud Run.
///
/// En local : le back lancé en local (npm run dev), ou l'API déployée avec :
///   flutter run -d chrome --dart-define=API_URL=https://URL-DE-L-API
class ApiConfig {
  ApiConfig._();

  static String baseUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// À appeler avant runApp. Sans /config.json (flutter run), garde la valeur par défaut.
  static Future<void> load() async {
    if (!kIsWeb) return;
    try {
      final response = await http
          .get(Uri.base.resolve('/config.json'))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode != 200) return;
      final apiUrl = (jsonDecode(response.body) as Map)['apiUrl'];
      if (apiUrl is String && apiUrl.isNotEmpty) baseUrl = apiUrl;
    } catch (_) {
      // Pas de config (serveur de dev) : on garde la valeur par défaut.
    }
  }
}
