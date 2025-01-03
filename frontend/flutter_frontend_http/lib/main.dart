/* Pre-existing codes avaible for creating 
a straightforward flutter app to get started. */

import 'package:flutter/material.dart';
import 'package:flutter_frontend_http/final_view.dart';

Future<void> main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Banner(
        location: BannerLocation.bottomStart,
        message: 'QMT',
        child: FinalView()),
    );
  }
}