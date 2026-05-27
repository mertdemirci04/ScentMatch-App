import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/perfume_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _searchQuery = "";
  List<String> _allUniqueNotes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _extractAllNotes();
    });
  }

  void _extractAllNotes() {
    final provider = Provider.of<PerfumeProvider>(context, listen: false);
    Set<String> notesSet = {};

    for (var p in provider.perfumes) {
      String rawText = "${p.topNotes},${p.middleNotes},${p.baseNotes}";
      List<String> parts = rawText.split(',');
      
      for (var part in parts) {
        String cleanNote = part.trim();
        if (cleanNote.length > 2 && cleanNote.toLowerCase() != "none") {
          cleanNote = cleanNote[0].toUpperCase() + cleanNote.substring(1).toLowerCase();
          notesSet.add(cleanNote);
        }
      }
    }

    setState(() {
      _allUniqueNotes = notesSet.toList()..sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    final filteredNotes = _allUniqueNotes.where((n) => 
      n.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            width: double.infinity,
            child: const Column(
              children: [
                Text("Notes", style: TextStyle(fontSize: 32, color: AppColors.text, fontWeight: FontWeight.w300, letterSpacing: 2)),
                Text("Dictionary", style: TextStyle(fontSize: 36, color: AppColors.goldLight, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              style: const TextStyle(color: AppColors.text),
              decoration: InputDecoration(
                hintText: 'Search a note... (e.g., Vanilla)',
                hintStyle: TextStyle(color: AppColors.textMuted),
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold)),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          
          const SizedBox(height: 20),
          Divider(color: AppColors.goldDark, height: 1),

          Expanded(
            child: _allUniqueNotes.isEmpty
                ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      final isFav = auth.isNoteFavorite(note);

                      return Container(
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          title: Text(note, style: const TextStyle(color: AppColors.text, fontSize: 16)),
                          trailing: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border, 
                              color: isFav ? AppColors.gold : AppColors.textMuted
                            ),
                            onPressed: () {
                              if (!auth.isLoggedIn) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("You must be logged in to favorite notes!"), backgroundColor: Colors.redAccent)
                                );
                                return;
                              }
                              auth.toggleFavoriteNote(note);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}