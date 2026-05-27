import '../models/perfume.dart';
import '../../data/repositories/perfume_repository.dart';

class RecommendationService {
  final PerfumeRepository _repository;

  RecommendationService(this._repository);

  Future<List<Map<String, dynamic>>> findMeAScent({
    Perfume? targetPerfume,
    required List<String> selectedNotes,
    String gender = "All",
  }) async {
    List<Perfume> allPerfumes = await _repository.getAllPerfumes();
    List<Map<String, dynamic>> candidates = [];

    Set<String> targetNotesSet = {};
    if (targetPerfume != null) {
      String rawTarget = "${targetPerfume.topNotes} ${targetPerfume.middleNotes} ${targetPerfume.baseNotes}".toLowerCase();
      targetNotesSet = rawTarget.replaceAll(',', ' ').split(' ').where((e) => e.trim().length > 2).toSet();
    }

    for (var perfume in allPerfumes) {
      if (gender != "All" && perfume.gender.toLowerCase() != gender.toLowerCase()) continue;
      
      if (targetPerfume != null && perfume.id == targetPerfume.id) continue;

      String candidateNotesText = "${perfume.topNotes} ${perfume.middleNotes} ${perfume.baseNotes}".toLowerCase();
      Set<String> candidateNotesSet = candidateNotesText.replaceAll(',', ' ').split(' ').where((e) => e.trim().length > 2).toSet();

      double rawDnaScore = 0.0;


      if (targetPerfume != null) {
        int intersection = targetNotesSet.intersection(candidateNotesSet).length;
        int union = targetNotesSet.union(candidateNotesSet).length;
        rawDnaScore = union > 0 ? (intersection / union) : 0.0;
      } else if (selectedNotes.isNotEmpty) {
        int matchCount = selectedNotes.where((note) => candidateNotesText.contains(note.toLowerCase())).length;
        rawDnaScore = matchCount / selectedNotes.length;
      }

      if (rawDnaScore < 0.01 && selectedNotes.isEmpty) continue;

      int matchedSelectedCount = selectedNotes.where((note) => candidateNotesText.contains(note.toLowerCase())).length;
      
      double bonus = matchedSelectedCount * 0.03; 

      double finalScore = rawDnaScore + bonus;

      candidates.add({
        'perfume': perfume,
        'ranking_score': finalScore,
        'raw_score': rawDnaScore,
      });
    }

    candidates.sort((a, b) => b['ranking_score'].compareTo(a['ranking_score']));
    var top6 = candidates.take(6).toList();

    List<Map<String, dynamic>> finalResults = [];
    for (int i = 0; i < top6.length; i++) {
      int displayPct;
      
      double scoreToCalculate = selectedNotes.isNotEmpty 
          ? top6[i]['ranking_score'] 
          : top6[i]['raw_score'];   

      displayPct = (scoreToCalculate * 100).toInt();

      if (displayPct > 95) displayPct = 95; 
      
      if (displayPct < 15 && top6[i]['ranking_score'] > 0) displayPct = 15;

      if (i > 0 && finalResults.last['match_pct'] == displayPct) {
        displayPct -= (i * 2);
      }

      finalResults.add({
        'perfume': top6[i]['perfume'],
        'match_pct': displayPct,
      });
    }

    return finalResults;
  }
  Future<List<Map<String, dynamic>>> recommendFromCollection(List<Perfume> collection) async {
    if (collection.isEmpty) return [];

    Map<String, int> noteFrequencies = {};
    
    for (var perfume in collection) {
      String allNotes = "${perfume.topNotes} ${perfume.middleNotes} ${perfume.baseNotes}".toLowerCase();
      List<String> notes = allNotes.replaceAll(',', ' ').split(' ').where((e) => e.trim().length > 2).toList();
      
      for (var note in notes) {
        noteFrequencies[note] = (noteFrequencies[note] ?? 0) + 1;
      }
    }

    var sortedNotes = noteFrequencies.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Büyükten küçüğe sırala
    
    List<String> userCoreNotes = sortedNotes.take(8).map((e) => e.key).toList();

    List<Perfume> allPerfumes = await _repository.getAllPerfumes();
    List<Map<String, dynamic>> candidates = [];

    Set<String> collectionKeys = collection.map((p) => "${p.brand}-${p.name}").toSet();

    for (var perfume in allPerfumes) {
      if (collectionKeys.contains("${perfume.brand}-${perfume.name}")) continue;

      String candidateNotesText = "${perfume.topNotes} ${perfume.middleNotes} ${perfume.baseNotes}".toLowerCase();
      
      int matchCount = userCoreNotes.where((note) => candidateNotesText.contains(note)).length;
      
      if (matchCount > 0) {
        double score = matchCount / userCoreNotes.length;
        
        candidates.add({
          'perfume': perfume,
          'score': score,
        });
      }
    }

    candidates.sort((a, b) => b['score'].compareTo(a['score']));
    var top6 = candidates.take(6).toList();

    List<Map<String, dynamic>> finalResults = [];
    for (int i = 0; i < top6.length; i++) {
      int displayPct = (top6[i]['score'] * 100).toInt();
      
      if (displayPct > 95) displayPct = 95;
      if (displayPct < 15) displayPct = 15;
      
      if (i > 0 && finalResults.last['match_pct'] == displayPct) {
        displayPct -= (i * 2); 
      }

      finalResults.add({
        'perfume': top6[i]['perfume'],
        'match_pct': displayPct,
      });
    }

    return finalResults;
  }
}