import 'package:flutter/material.dart';
import '../../domain/models/perfume.dart';
import '../../core/constants.dart';

class PerfumeCard extends StatelessWidget {
  final Perfume perfume;
  final VoidCallback onTap;

  const PerfumeCard({Key? key, required this.perfume, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary,
          child: Text(
            perfume.brand.substring(0, 1),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          perfume.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        subtitle: Text('${perfume.brand} • ${perfume.gender}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textLight),
        onTap: onTap,
      ),
    );
  }
}