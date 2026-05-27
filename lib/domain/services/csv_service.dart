import 'package:findscent/data/database/app_database.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:sqflite/sqflite.dart';
import '../models/perfume.dart';
import '../../data/repositories/perfume_repository.dart';

class CsvService {
  final PerfumeRepository _repository;

  CsvService(this._repository);

  Future<void> importPerfumesFromCsv() async {
  try {
    final db = await AppDatabase.instance.database;
    
    final countResult = await db.rawQuery('SELECT COUNT(*) as total FROM perfumes');
    int currentCount = Sqflite.firstIntValue(countResult) ?? 0;
    
    if (currentCount > 19000) {
      print("DEBUG: Veriler zaten tam görünüyor, atlanıyor.");
      return;
    }

    print("CSV Yükleme işlemi başladı...");
    final rawData = await rootBundle.loadString('assets/final_cleaned_perfumes.csv');
    
    List<List<dynamic>> listData = const CsvToListConverter(
      fieldDelimiter: ';', 
      eol: '\n',
      shouldParseNumbers: false
    ).convert(rawData);

    await db.transaction((txn) async {
      var batch = txn.batch();
      
      for (int i = 1; i < listData.length; i++) {
        var row = listData[i];
        if (row.length < 6) continue;

        try {
          String name = row[0].toString().replaceAll('-', ' ').toUpperCase();
          String brand = row[1].toString().replaceAll('-', ' ').toUpperCase();
          
          batch.insert('perfumes', {
            'name': name,
            'brand': brand,
            'gender': row[2].toString(),
            'top_notes': row[4].toString(),
            'middle_notes': row.length > 5 ? row[5].toString() : "",
            'base_notes': row.length > 6 ? row[6].toString() : "",
            'description': "A professional fragrance by $brand.",
          }, conflictAlgorithm: ConflictAlgorithm.replace); 

        } catch (e) { continue; }
      }
      
      print("DEBUG: 20.000 veri sepete eklendi, veritabanına yazılıyor...");
      
      await batch.commit(noResult: true); 
    });

    print("DEBUG: Tüm veriler şimşek hızında SQLite'a aktarıldı!");
  } catch (e) {
    print("DEBUG: KRİTİK HATA: $e");
  }
}
}