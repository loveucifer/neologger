import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neologger/providers/food_provider.dart';
import 'package:neologger/providers/meal_provider.dart';
import 'package:neologger/screens/home_screen.dart';
import 'package:neologger/widgets/dotted_grid_background.dart';
import 'package:provider/provider.dart';
import 'package:neologger/constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => MealProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neologger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFffffff), // White text
          onPrimary: Color(0xFF000000), // Black background
          secondary: Color(0xFF111111), // Card background
          onSecondary: Color(0xFFffffff), // Text on cards
          surface: Color(0xFF000000), // Main background
          onSurface: Color(0xFFffffff), // Text on surface
          outline: Color(0xFF1a1a1a), // Borders
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textPrimary),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        // Add smooth page transition animations
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: DottedGridBackground(
        child: const HomeScreen(),
      ),
    );
  }
}