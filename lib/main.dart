import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar datos de locale español para formateo de fechas
  await initializeDateFormatting('es');


  // Desactiva la descarga de fuentes en runtime para evitar errores de red.
  // Las fuentes caerán al fallback del sistema (Roboto en Android, SF en iOS).
  GoogleFonts.config.allowRuntimeFetching = false;

  // Status bar transparente para el estilo dark
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A1929),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const TechMarketApp());
}
