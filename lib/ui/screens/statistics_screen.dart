import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/perfume_provider.dart';
import '../../core/constants.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PerfumeProvider>(context);
    
    final totalPerfumes = provider.perfumes.length;
    final brands = provider.perfumes.map((p) => p.brand).toSet().length;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Library Analytics",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                _buildStatCard("Total Scents", totalPerfumes.toString(), Icons.opacity), 
                const SizedBox(width: 15),
                _buildStatCard("Unique Brands", brands.toString(), Icons.business),
              ],
            ),
            
            const SizedBox(height: 30),
            const Text(
              "Most Popular Brands",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            Expanded(
              child: ListView.builder(
                itemCount: brands > 5 ? 5 : brands,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.star, color: AppColors.secondary),
                      title: Text(provider.perfumes[index].brand),
                      trailing: const Text("Premium"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.secondary, size: 30),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}