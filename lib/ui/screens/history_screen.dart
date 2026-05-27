import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../providers/auth_provider.dart';
import 'perfume_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.gold),
        title: const Text(
          "SCENT HISTORY",
          style: TextStyle(color: AppColors.gold, fontSize: 12, letterSpacing: 4, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.border, height: 1.0),
        ),
      ),
      body: auth.history.isEmpty
          ? Center(
              child: Text("You haven't reviewed any perfumes yet.",
                  style: TextStyle(color: AppColors.textMuted)),
            )
          : ListView.builder(
              itemCount: auth.history.length,
              itemBuilder: (context, index) {
                final p = auth.history[index];
                return InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PerfumeDetailScreen(perfume: p))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(p.brand.toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1), maxLines: 2, overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 10),
                        Expanded(flex: 4, child: Text(p.name, style: const TextStyle(color: AppColors.text, fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 10),
                        Icon(Icons.history, color: AppColors.textMuted, size: 14),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}