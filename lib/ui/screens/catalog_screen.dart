import 'package:findscent/ui/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/perfume_provider.dart';
import '../../core/constants.dart';
import 'perfume_detail_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PerfumeProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            width: double.infinity,
            child: Column(
              children: [
                const Text("Perfume", style: TextStyle(fontSize: 32, color: AppColors.text, fontWeight: FontWeight.w300, letterSpacing: 2)),
                const Text("Library", style: TextStyle(fontSize: 36, color: AppColors.goldLight, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)),
                const SizedBox(height: 10),
                Text("A carefully curated fragrance collection from world-famous brands", style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              style: const TextStyle(color: AppColors.text),
              decoration: InputDecoration(
                hintText: 'Search brand or perfume name...',
                hintStyle: TextStyle(color: AppColors.textMuted),
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surface,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.gold)),
              ),
              onChanged: (value) => provider.search(value),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                const Expanded(flex: 3, child: Text("BRAND", style: TextStyle(color: AppColors.gold, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold))),
                const SizedBox(width: 10),
                const Expanded(flex: 4, child: Text("PERFUME NAME", style: TextStyle(color: AppColors.gold, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold))),
                const SizedBox(width: 10),
                Container(width: 70, alignment: Alignment.centerRight, child: const Text("DETAIL", style: TextStyle(color: AppColors.gold, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          
          Divider(color: AppColors.goldDark, height: 1),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
                : ListView.builder(
                    itemCount: provider.perfumes.length,
                    itemBuilder: (context, index) {
                      final p = provider.perfumes[index];
                      return InkWell(
                        onTap: () {
                          Provider.of<AuthProvider>(context, listen: false).addToHistory(p);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PerfumeDetailScreen(perfume: p)));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.border)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 1. Brand
                              Expanded(
                                flex: 3,
                                child: Text(
                                  p.brand.toUpperCase(), 
                                  style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name, 
                                      style: const TextStyle(color: AppColors.text, fontSize: 15),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text("TOP: ${p.topNotes}", style: TextStyle(color: AppColors.textMuted, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    Text("BASE: ${p.baseNotes}", style: TextStyle(color: AppColors.textMuted, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(border: Border.all(color: AppColors.border)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("DISCOVER", style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_forward, color: AppColors.textMuted, size: 12),
                                  ],
                                ),
                              )
                            ],
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