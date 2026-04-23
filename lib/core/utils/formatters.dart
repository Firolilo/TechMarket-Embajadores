import 'package:intl/intl.dart';

/// Formateadores de datos para la UI.
class Formatters {
  Formatters._();

  static final _currencyFormat = NumberFormat.currency(
    locale: 'es_VE',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _compactFormat = NumberFormat.compact(locale: 'es');
  static final _dateFormat = DateFormat('dd MMM yyyy', 'es');
  static final _dateTimeFormat = DateFormat('dd MMM yyyy, HH:mm', 'es');
  static final _shortDateFormat = DateFormat('dd/MM/yy', 'es');

  /// Formatea un valor como moneda: \$1,234.56
  static String currency(double value) => _currencyFormat.format(value);

  /// Formatea un número de forma compacta: 1.2K, 3.5M
  static String compact(num value) => _compactFormat.format(value);

  /// Formatea un número con separadores de miles
  static String number(num value) =>
      NumberFormat('#,##0', 'es').format(value);

  /// Formatea una fecha: 23 Abr 2026
  static String date(DateTime date) => _dateFormat.format(date);

  /// Formatea fecha y hora: 23 Abr 2026, 14:30
  static String dateTime(DateTime date) => _dateTimeFormat.format(date);

  /// Formatea fecha corta: 23/04/26
  static String shortDate(DateTime date) => _shortDateFormat.format(date);

  /// Formatea un porcentaje: 85.5%
  static String percentage(double value) => '${value.toStringAsFixed(1)}%';

  /// Tiempo relativo: "hace 2 horas", "hace 3 días"
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Justo ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays}d';
    if (diff.inDays < 30) return 'Hace ${diff.inDays ~/ 7} sem';
    if (diff.inDays < 365) return 'Hace ${diff.inDays ~/ 30} meses';
    return 'Hace ${diff.inDays ~/ 365} años';
  }
}
