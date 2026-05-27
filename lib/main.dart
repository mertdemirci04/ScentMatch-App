import 'package:findscent/data/dao/ParfumeDao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants.dart';
import 'data/repositories/perfume_repository.dart';
import 'domain/services/csv_service.dart';
import 'ui/providers/perfume_provider.dart';
import 'ui/screens/home_screen.dart';
import 'package:findscent/ui/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final perfumeDao = PerfumeDao();
  final repository = PerfumeRepository(perfumeDao);
  final csvService = CsvService(repository);

runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => PerfumeProvider(repository, csvService)..initApp(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
    ],
    child: const FindScentApp(),
  ),
);
}

class FindScentApp extends StatelessWidget {
  const FindScentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}