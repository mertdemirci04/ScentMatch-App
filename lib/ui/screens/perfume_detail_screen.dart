import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/perfume.dart';
import '../../core/constants.dart';
import '../providers/auth_provider.dart';

class PerfumeDetailScreen extends StatelessWidget {
  final Perfume perfume;

  const PerfumeDetailScreen({super.key, required this.perfume});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final inCollection = auth.isInCollection(perfume);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.gold),
        title: const Text(
          "FRAGRANCE DETAILS",
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 12,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.border, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 50,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    perfume.brand.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    perfume.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      color: AppColors.surface,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_outline,
                          color: AppColors.gold,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          perfume.gender.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.goldLight,
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Fragrance Notes",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: AppColors.goldLight,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildNoteRow("TOP", perfume.topNotes),
                  _buildDivider(),
                  _buildNoteRow("MIDDLE", perfume.middleNotes),
                  _buildDivider(),
                  _buildNoteRow("BASE", perfume.baseNotes),

                  const SizedBox(height: 50),

                  const Text(
                    "ABOUT",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Text(
                    perfume.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.8,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 50),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: auth.isLoggedIn
                          ? () {
                              auth.toggleCollection(perfume);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    inCollection
                                        ? "${perfume.name} removed from collection."
                                        : "${perfume.name} added to collection!",
                                  ),
                                  backgroundColor:
                                      AppColors.goldDark,
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor:
                            AppColors.surface,
                        backgroundColor: inCollection
                            ? AppColors.surface
                            : AppColors.gold,
                        shape:
                            const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.zero,
                        ),
                      ),
                      child: Text(
                        auth.isLoggedIn
                            ? (inCollection
                                ? "REMOVE FROM COLLECTION"
                                : "ADD TO COLLECTION")
                            : "LOGIN TO ADD",
                        style: TextStyle(
                          color: auth.isLoggedIn
                              ? (inCollection
                                  ? AppColors.gold
                                  : AppColors.bg)
                              : AppColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteRow(String title, String notes) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          Expanded(
            child: Text(
              notes.isEmpty || notes == "None"
                  ? "Not specified"
                  : notes,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.border,
      height: 20,
    );
  }
}