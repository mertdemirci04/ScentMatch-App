import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart'; 
import '../../domain/models/perfume.dart'; 
import '../providers/perfume_provider.dart'; 

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Perfume? _perfume1;
  Perfume? _perfume2;
  int? _similarityPercentage;

  void _calculateSimilarity() {
    if (_perfume1 == null || _perfume2 == null) return;

    Set<String> getNotesSet(Perfume p) {
      String rawNotes = "${p.topNotes} ${p.middleNotes} ${p.baseNotes}".toLowerCase();
      return rawNotes.replaceAll(',', ' ').split(' ').where((e) => e.trim().length > 2).toSet();
    }

    Set<String> p1Notes = getNotesSet(_perfume1!);
    Set<String> p2Notes = getNotesSet(_perfume2!);

    int intersection = p1Notes.intersection(p2Notes).length;
    int union = p1Notes.union(p2Notes).length;

    double rawScore = union > 0 ? (intersection / union) : 0.0;
    int percentage = (rawScore * 100).toInt();

    if (percentage > 95) percentage = 95;

    setState(() {
      _similarityPercentage = percentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allPerfumes = context.read<PerfumeProvider>().perfumes;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "COMPARE",
              style: TextStyle(color: AppColors.gold, fontSize: 18, letterSpacing: 3, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            _buildPerfumeSearchField(
              label: "Select the First Perfume",
              allPerfumes: allPerfumes,
              onSelected: (selected) {
                setState(() {
                  _perfume1 = selected;
                  _similarityPercentage = null; // Reset result when a new selection is made
                });
              },
            ),
            const SizedBox(height: 20),
            
            _buildPerfumeSearchField(
              label: "Select the Second Perfume",
              allPerfumes: allPerfumes,
              onSelected: (selected) {
                setState(() {
                  _perfume2 = selected;
                  _similarityPercentage = null;
                });
              },
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.bg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: (_perfume1 != null && _perfume2 != null) ? _calculateSimilarity : null,
                child: const Text("COMPARE", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),

            // Result Section
            if (_similarityPercentage != null) ...[
              Text(
                "SIMILARITY: $_similarityPercentage%",
                style: const TextStyle(
                  color: AppColors.goldLight,
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 30),
              
              // Side-by-Side Note Comparison
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildPerfumeDetailsColumn(_perfume1!)),
                  Container(width: 1, height: 200, color: AppColors.border, margin: const EdgeInsets.symmetric(horizontal: 10)),
                  Expanded(child: _buildPerfumeDetailsColumn(_perfume2!)),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPerfumeSearchField({
    required String label,
    required List<Perfume> allPerfumes,
    required Function(Perfume) onSelected,
  }) {
    return Autocomplete<Perfume>(
      displayStringForOption: (Perfume option) => "${option.brand} - ${option.name}",
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Perfume>.empty();
        }
        return allPerfumes.where((Perfume p) {
          final query = textEditingValue.text.toLowerCase();
          return p.name.toLowerCase().contains(query) || p.brand.toLowerCase().contains(query);
        });
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          style: const TextStyle(color: AppColors.text),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: AppColors.textMuted),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold)),
            prefixIcon: const Icon(Icons.search, color: AppColors.gold),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: AppColors.bg,
            elevation: 4.0,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(border: Border.all(color: AppColors.border)),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final Perfume option = options.elementAt(index);
                  return ListTile(
                    title: Text(option.name, style: const TextStyle(color: AppColors.text)),
                    subtitle: Text(option.brand, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerfumeDetailsColumn(Perfume perfume) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(perfume.brand.toUpperCase(), style: TextStyle(color: AppColors.goldDark, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(perfume.name, style: const TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 15),
        _buildNoteSection("Top Notes", perfume.topNotes),
        _buildNoteSection("Middle Notes", perfume.middleNotes),
        _buildNoteSection("Base Notes", perfume.baseNotes),
      ],
    );
  }

  Widget _buildNoteSection(String title, String notes) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 2),
          Text(notes.isEmpty ? "Unknown" : notes, style: const TextStyle(color: AppColors.goldLight, fontSize: 13)),
        ],
      ),
    );
  }
}