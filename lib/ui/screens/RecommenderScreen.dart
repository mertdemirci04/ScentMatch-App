import 'package:findscent/ui/providers/auth_provider.dart';
import 'package:findscent/ui/screens/perfume_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../providers/perfume_provider.dart';
import '../../domain/services/recommendation_service.dart';
import '../../domain/models/perfume.dart';

class RecommenderScreen extends StatefulWidget {
  const RecommenderScreen({super.key});

  @override
  State<RecommenderScreen> createState() => _RecommenderScreenState();
}

bool _showAllNotes = false;

class _RecommenderScreenState extends State<RecommenderScreen> {
  Perfume? _selectedPerfume; 
  final List<String> _selectedNotes = [];
  String _selectedGender = "ALL"; 
  List<Map<String, dynamic>> _results = [];
  bool _isCalculating = false;

  final List<String> _availableNotes = [
    'Vanilla', 'Amber', 'Bergamot', 'Oud', 'Sandalwood', 'Rose', 'Leather', 'Musk',
    'Jasmine', 'Patchouli', 'Cedar', 'Tonka Bean', 'Mint', 'Cinnamon', 
    'Cardamom', 'Coconut', 'Coffee', 'Honey', 'Black Pepper', 'Lemon',
    'Iris', 'Vetiver', 'Grapefruit', 'Incense'
  ];

  void _toggleNote(String note) {
    setState(() {
      if (_selectedNotes.contains(note)) {
        _selectedNotes.remove(note);
      } else {
        _selectedNotes.add(note);
      }
    });
  }

  void _calculateMatch() async {
    setState(() => _isCalculating = true);
    final provider = Provider.of<PerfumeProvider>(context, listen: false);
    final service = RecommendationService(provider.repository);
    
    final matchResults = await service.findMeAScent(
      targetPerfume: _selectedPerfume,
      selectedNotes: _selectedNotes,
      gender: _selectedGender == "ALL" ? "All" : (_selectedGender == "MEN" ? "Men" : "Women"),
    );

    setState(() {
      _results = matchResults;
      _isCalculating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Personal\nScent Guide",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: AppColors.goldLight, letterSpacing: 1.5, height: 1.2),
            ),
            const SizedBox(height: 40),

            _buildStepCard(
              stepNumber: "00",
              title: "Who are you looking for?",
              content: Row(
                children: ["ALL", "MEN", "WOMEN", "UNISEX"].map((g) {
                  final isSelected = _selectedGender == g;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGender = g),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.surface2 : Colors.transparent,
                          border: Border.all(color: isSelected ? AppColors.gold : AppColors.border),
                        ),
                        child: Center(
                          child: Text(g, style: TextStyle(color: isSelected ? AppColors.gold : AppColors.textMuted, fontSize: 12, letterSpacing: 1)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            _buildStepCard(
              stepNumber: "01",
              title: "Your Reference Perfume",
              content: Autocomplete<Perfume>(
                displayStringForOption: (Perfume option) => "${option.brand} - ${option.name}",
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) return const Iterable<Perfume>.empty();
                  return Provider.of<PerfumeProvider>(context, listen: false).perfumes.where((p) => 
                    p.name.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                    p.brand.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (selection) => setState(() => _selectedPerfume = selection),
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: const TextStyle(color: AppColors.text),
                    decoration: InputDecoration(
                      hintText: 'Search a perfume... (e.g., Khamrah)',
                      hintStyle: TextStyle(color: AppColors.textMuted),
                      filled: true,
                      fillColor: AppColors.bg,
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold)),
                      suffixIcon: _selectedPerfume != null 
                          ? IconButton(icon: const Icon(Icons.close, color: AppColors.gold), onPressed: () { controller.clear(); setState(() => _selectedPerfume = null); })
                          : Icon(Icons.arrow_drop_down, color: AppColors.textMuted),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            _buildStepCard(
              stepNumber: "02",
              title: "Notes You Love",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = (constraints.maxWidth - 10) / 2;
                      
                      return Wrap(
                        spacing: 10, 
                        runSpacing: 10,
                        children: (_showAllNotes ? _availableNotes : _availableNotes.take(8)).map((note) {
                          final isSelected = _selectedNotes.contains(note);
                          return GestureDetector(
                            onTap: () => _toggleNote(note),
                            child: Container(
                              width: itemWidth, 
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.surface2 : AppColors.bg,
                                border: Border.all(color: isSelected ? AppColors.gold : AppColors.border),
                              ),
                              child: Text(
                                note, 
                                style: TextStyle(
                                  color: isSelected ? AppColors.gold : AppColors.textMuted, 
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 15),
                  
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAllNotes = !_showAllNotes;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _showAllNotes ? "SHOW LESS" : "SEE ALL NOTES",
                            style: const TextStyle(
                              color: AppColors.gold, 
                              fontSize: 10, 
                              letterSpacing: 2, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            _showAllNotes ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: AppColors.gold,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                ),
                onPressed: _calculateMatch,
                child: _isCalculating 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.bg, strokeWidth: 2))
                    : const Text("DISCOVER PERFUME", style: TextStyle(color: AppColors.bg, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ),
            ),
            
            const SizedBox(height: 30),

            if (_results.isNotEmpty) ..._results.map((r) => _buildResultCard(r['perfume'], r['match_pct'])),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({required String stepNumber, required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("STEP $stepNumber", style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
              Text(stepNumber, style: TextStyle(color: AppColors.surface2, fontSize: 30, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w300)),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildResultCard(Perfume perfume, int score) {
    return InkWell( 
      onTap: () {
        Provider.of<AuthProvider>(context, listen: false).addToHistory(perfume);
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PerfumeDetailScreen(perfume: perfume)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.goldDark), 
          color: AppColors.surface2
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(perfume.brand, style: const TextStyle(color: AppColors.gold, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 5),
                  // Name
                  Text(perfume.name, style: const TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Icon(Icons.person_outline, color: AppColors.goldDark, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        perfume.gender.toUpperCase(), 
                        style: TextStyle(
                          color: AppColors.textMuted, 
                          fontSize: 10, 
                          letterSpacing: 1, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text("$score%", style: const TextStyle(color: AppColors.goldLight, fontSize: 24, fontWeight: FontWeight.w300)),
                const SizedBox(width: 15),
                const Icon(Icons.arrow_forward_ios, color: AppColors.goldDark, size: 16), 
              ],
            ),
          ],
        ),
      ),
    );
  }
}