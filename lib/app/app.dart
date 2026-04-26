import 'package:flutter/material.dart';

import '../features/home/presentation/home_page.dart';
import '../features/home/presentation/home_view_model.dart';
import 'theme/app_theme.dart';

class NyayaApp extends StatelessWidget {
  const NyayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyaya',
      debugShowCheckedModeBanner: false,
      theme: buildNyayaTheme(),
      home: const HomePage(viewModel: HomeViewModel()),
    );
  }
}
