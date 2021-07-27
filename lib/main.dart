import 'package:corontor_indonesia/app.dart';
import 'package:corontor_indonesia/storage_initializer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    await initStorage();

    runApp(MyApp());
  } catch (e, s) {
    print('$e, $s');
  }
}
