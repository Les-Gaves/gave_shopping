import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

/// Erreur renvoyée par l'API (ou serveur injoignable si [statusCode] vaut 0).
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

/// Point d'accès unique à l'API back.
///
/// - ajoute le jeton Firebase (Authorization: Bearer <token>) si [auth] est vrai ;
/// - encode et décode le JSON ;
/// - transforme les erreurs HTTP en [ApiException] avec un message lisible.
class ApiClient {
  ApiClient._();

  static final http.Client _http = http.Client();

  static Future<dynamic> get(String path,
          {Map<String, String>? query, bool auth = false}) =>
      _send('GET', path, query: query, auth: auth);

  static Future<dynamic> post(String path, {Object? body, bool auth = true}) =>
      _send('POST', path, body: body, auth: auth);

  static Future<dynamic> put(String path, {Object? body, bool auth = true}) =>
      _send('PUT', path, body: body, auth: auth);

  static Future<dynamic> patch(String path, {Object? body, bool auth = true}) =>
      _send('PATCH', path, body: body, auth: auth);

  static Future<dynamic> delete(String path, {bool auth = true}) =>
      _send('DELETE', path, auth: auth);

  static Future<dynamic> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
    bool auth = false,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json';

    if (auth) {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (token == null) throw ApiException(401, 'Vous devez être connecté.');
      headers['Authorization'] = 'Bearer $token';
    }

    var uri = Uri.parse('${ApiConfig.baseUrl}$path');
    if (query != null) uri = uri.replace(queryParameters: query);

    final request = http.Request(method, uri)..headers.addAll(headers);
    if (body != null) request.body = jsonEncode(body);

    final http.Response response;
    try {
      response = await http.Response.fromStream(await _http.send(request));
    } catch (_) {
      // Serveur éteint, mauvaise URL, ou appel bloqué par le CORS.
      throw ApiException(0, 'Impossible de joindre le serveur.');
    }

    final text = utf8.decode(response.bodyBytes);
    final data = text.isEmpty ? null : _tryDecode(text);

    if (response.statusCode >= 200 && response.statusCode < 300) return data;

    throw ApiException(
      response.statusCode,
      _errorMessage(data) ?? 'Erreur serveur (${response.statusCode}).',
    );
  }

  static dynamic _tryDecode(String text) {
    try {
      return jsonDecode(text);
    } catch (_) {
      return text;
    }
  }

  static String? _errorMessage(dynamic data) {
    if (data is Map) {
      final value = data['error'] ?? data['message'];
      if (value is String) return value;
      if (value is Map && value['message'] is String) return value['message'];
    }
    if (data is String && data.isNotEmpty && data.length < 200) return data;
    return null;
  }
}
