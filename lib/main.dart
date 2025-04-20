import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'core/services/storage_service.dart';
import 'core/utils/logger.dart';

final logger = AppLogger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inicializar Firebase
    await Firebase.initializeApp();
    logger.i('Firebase initialized successfully');

    // Inicializar servicio de almacenamiento local
    final storageService = StorageService();
    await storageService.init();
    logger.i('Storage service initialized successfully');

    // Ejecutar la aplicación
    runApp(const ProviderScope(child: App()));
  } catch (e, stackTrace) {
    logger.e('Error initializing app', e, stackTrace);
    // Muestra un error en la UI si hay problemas de inicialización
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text('Error initializing app: $e')))));
  }
}
