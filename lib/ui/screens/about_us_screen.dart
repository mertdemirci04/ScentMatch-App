import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.gold),
        title: const Text(
          "ABOUT US",
          style: TextStyle(color: AppColors.gold, fontSize: 12, letterSpacing: 4, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.border, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // LOGO & SLOGAN
            const Text(
              "SCENTMATCH AI",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: AppColors.gold, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Text(
              "The Future of Perfume Guide",
              style: TextStyle(color: AppColors.textMuted, fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 40),
            
            const Text(
              "ScentMatch AI is designed to find the most suitable scent for you by analyzing the DNA of thousands of perfumes with mathematical algorithms. It's not just an app, it's your personal fragrance library.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.text, fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 50),

            _buildFeatureCard(
              icon: Icons.library_books_outlined,
              title: "Comprehensive Library",
              desc: "A massive catalog listing more than 2000 perfumes with all their notes, from global giants to niche brands.",
            ),
            _buildFeatureCard(
              icon: Icons.psychology_outlined,
              title: "AI Match Algorithm",
              desc: "Using the Jaccard Similarity Theorem, it compares the notes of your selected perfume with candidates and offers recommendations with up to 98% accuracy.",
            ),
            _buildFeatureCard(
              icon: Icons.eco_outlined,
              title: "Notes Dictionary",
              desc: "Discover thousands of unique notes that make up perfumes, and determine your scent character by adding them to your favorites.",
            ),
            _buildFeatureCard(
              icon: Icons.bookmark_border,
              title: "Personal Collection",
              desc: "Collect the scents you like in your own custom collection and access their details whenever you want.",
            ),
            _buildFeatureCard(
              icon: Icons.history,
              title: "Scent Journey",
              desc: "Never forget any perfume you have reviewed before. Your scent discovery journey is always recorded with the History tab.",
            ),
            _buildFeatureCard(
              icon: Icons.security_outlined,
              title: "Secure Session",
              desc: "Your data is always safe on your phone with a custom account system and local storage technology (SharedPrefs).",
            ),

            const SizedBox(height: 50),
            Divider(color: AppColors.border),
            const SizedBox(height: 20),
            Text(
              "Version 1.0.4 - 2024",
              style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 1),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String title, required String desc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(color: AppColors.goldLight, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  style: const TextStyle(color: AppColors.text, fontSize: 14, height: 1.4, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
