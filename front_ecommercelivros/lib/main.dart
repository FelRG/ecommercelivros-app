import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/database.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await AppDatabase().database;

  if (!kIsWeb) {
    await AppDatabase().database;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LivroLumina',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
