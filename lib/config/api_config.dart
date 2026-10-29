/// Adresse de l'API back.
///
/// Par défaut : le back lancé en local (npm run dev).
/// Pour utiliser l'API déployée, lancer le front avec :
///   flutter run -d chrome --dart-define=API_URL=https://URL-DE-L-API
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );
}
