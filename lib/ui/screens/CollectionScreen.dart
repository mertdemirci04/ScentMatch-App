import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/perfume_provider.dart';
import '../../domain/models/perfume.dart';
import '../../domain/services/recommendation_service.dart';
import 'perfume_detail_screen.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (!auth.isLoggedIn) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Text(
            "Please log in from the profile tab\nto view your collection.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    if (auth.collection.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Text(
            "Your collection is empty yet.\nStart discovering!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.goldLight,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              width: double.infinity,
              child: const Column(
                children: [
                  Text("Personal",
                      style: TextStyle(
                          fontSize: 32,
                          color: AppColors.text,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2)),
                  Text("Collection",
                      style: TextStyle(
                          fontSize: 36,
                          color: AppColors.goldLight,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(
            child: Divider(color: AppColors.goldDark, height: 1),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final p = auth.collection[index];
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PerfumeDetailScreen(perfume: p))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColors.border))),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(p.brand.toUpperCase(),
                                style: const TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 10),
                        Expanded(
                            flex: 4,
                            child: Text(p.name,
                                style: const TextStyle(
                                    color: AppColors.text, fontSize: 15),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios,
                            color: AppColors.textMuted, size: 14),
                      ],
                    ),
                  ),
                );
              },
              childCount: auth.collection.length,
            ),
          ),

          // Recommendations Widget
          SliverToBoxAdapter(
            child: CollectionRecommendationsWidget(
              collection: auth.collection,
            ),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }
}

class CollectionRecommendationsWidget extends StatefulWidget {
  final List<Perfume> collection;

  const CollectionRecommendationsWidget({super.key, required this.collection});

  @override
  State<CollectionRecommendationsWidget> createState() =>
      _CollectionRecommendationsWidgetState();
}

class _CollectionRecommendationsWidgetState
    extends State<CollectionRecommendationsWidget> {
  List<Map<String, dynamic>> _recommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  @override
  void didUpdateWidget(covariant CollectionRecommendationsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collection.length != widget.collection.length) {
      _loadRecommendations();
    }
  }

  Future<void> _loadRecommendations() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final repository = context.read<PerfumeProvider>().repository;
    final recommendationService = RecommendationService(repository);

    final results = await recommendationService.recommendFromCollection(widget.collection);

    if (!mounted) return;

    setState(() {
      _recommendations = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(
            child: CircularProgressIndicator(color: AppColors.goldLight)),
      );
    }

    if (_recommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Recommendations Fitting Your Scent DNA",
            style: TextStyle(
              fontSize: 18,
              color: AppColors.goldLight,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _recommendations.length,
            itemBuilder: (context, index) {
              final item = _recommendations[index];
              final Perfume perfume = item['perfume'];
              final matchPct = item['match_pct'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            PerfumeDetailScreen(perfume: perfume)),
                  );
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.bg.withOpacity(0.5),
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        perfume.brand.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        perfume.name,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldDark.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.goldDark),
                        ),
                        child: Text(
                          "$matchPct% Match",
                          style: const TextStyle(
                            color: AppColors.goldLight,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}