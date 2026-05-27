import 'package:findscent/data/dao/ParfumeDao.dart';

import '../../domain/models/perfume.dart';

class PerfumeRepository {
  final PerfumeDao _perfumeDao;

  PerfumeRepository(this._perfumeDao);

  Future<List<Perfume>> getAllPerfumes() async {
    return await _perfumeDao.getAllPerfumes();
  }

  Future<List<Perfume>> searchPerfumes(String query) async {
    return await _perfumeDao.searchPerfumes(query);
  }

  Future<int> addPerfume(Perfume perfume) async {
    return await _perfumeDao.insertPerfume(perfume);
  }
  
  // Hocanın istediği diğer CRUD operasyonlarını (Update, Delete) buraya ekleyeceğiz.
}