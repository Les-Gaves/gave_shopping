/// Petits utilitaires pour lire le JSON renvoyé par l'API.

/// Les colonnes `Decimal` de Prisma (price, totalAmount…) arrivent
/// en chaîne ("1390.5"), les autres nombres en number : on accepte les deux.
double toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

int toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

DateTime? toDate(dynamic value) =>
    value is String ? DateTime.tryParse(value)?.toLocal() : null;
