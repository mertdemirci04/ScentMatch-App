import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../providers/auth_provider.dart';

class FavoriteNotesScreen extends StatelessWidget {
  const FavoriteNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.gold),
        title: const Text("MY FAVORITE NOTES", style: TextStyle(color: AppColors.gold, fontSize: 12, letterSpacing: 4, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.border, height: 1.0),
        ),
      ),
      body: auth.favoriteNotes.isEmpty
          ? Center(child: Text("You don't have any favorite notes yet.", style: TextStyle(color: AppColors.textMuted)))
          : ListView.builder(
              itemCount: auth.favoriteNotes.length,
              itemBuilder: (context, index) {
                final note = auth.favoriteNotes[index];
                return Container(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    title: Text(note, style: const TextStyle(color: AppColors.text, fontSize: 16)),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: AppColors.gold),
                      onPressed: () => auth.toggleFavoriteNote(note), // Removes from list when clicked
                    ),
                  ),
                );
              },
            ),
    );
  }
}