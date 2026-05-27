import 'package:flutter/material.dart';
import '../../domain/models/perfume.dart';
import '../../data/repositories/perfume_repository.dart';
import '../../domain/services/csv_service.dart';

class PerfumeProvider extends ChangeNotifier {
  final PerfumeRepository repository; 
  final CsvService _csvService;

  List<Perfume> _perfumes = [];
  bool _isLoading = false;

  List<Perfume> get perfumes => _perfumes;
  bool get isLoading => _isLoading;

  PerfumeProvider(this.repository, this._csvService);

  Future<void> initApp() async {
  if (_isLoading) return;
  
  _isLoading = true;
  notifyListeners();

  try {
    await _csvService.importPerfumesFromCsv();
    
    await loadPerfumes(); 
    
    print("DEBUG: Provider - Veriler yüklendi ve ekran tetiklendi!");
  } catch (e) {
    print("DEBUG: initApp Hatası: $e");
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> loadPerfumes() async {
    _perfumes = await repository.getAllPerfumes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> search(String query) async {
    _isLoading = true;
    notifyListeners();
    _perfumes = await repository.searchPerfumes(query);
    _isLoading = false;
    notifyListeners();
  }
}