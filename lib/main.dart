import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home_screen.dart';
import 'utils/app_colors.dart';
import 'bindings/home_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Healofy',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF4F858A, {
          50: AppColors.primaryGreen.withOpacity(0.1),
          100: AppColors.primaryGreen.withOpacity(0.2),
          200: AppColors.primaryGreen.withOpacity(0.3),
          300: AppColors.primaryGreen.withOpacity(0.4),
          400: AppColors.primaryGreen.withOpacity(0.5),
          500: AppColors.primaryGreen,
          600: AppColors.primaryGreen.withOpacity(0.7),
          700: AppColors.primaryGreen.withOpacity(0.8),
          800: AppColors.primaryGreen.withOpacity(0.9),
          900: AppColors.primaryGreen,
        }),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          binding: HomeBinding(),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
