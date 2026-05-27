import 'package:sqflite/sqflite.dart';
import '../../domain/models/perfume.dart';
import '../database/app_database.dart';

class PerfumeDao {
  Future<int> insertPerfume(Perfume perfume) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('perfumes', perfume.toMap());
  }

  Future<List<Perfume>> getAllPerfumes() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('perfumes', orderBy: 'brand, name');
    return result.map((json) => Perfume.fromMap(json)).toList();
  }
  
  // Arama fonksiyonu (Django'daki Q objeli aramanın yerel hali)
  Future<List<Perfume>> searchPerfumes(String query) async {
     final db = await AppDatabase.instance.database;
     final result = await db.query(
       'perfumes',
       where: 'name LIKE ? OR brand LIKE ? OR top_notes LIKE ?',
       whereArgs: ['%$query%', '%$query%', '%$query%']
     );
     return result.map((json) => Perfume.fromMap(json)).toList();
  }
}