import 'package:findscent/ui/screens/RecommenderScreen.dart';
import 'package:findscent/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import 'catalog_screen.dart'; 
import 'CollectionScreen.dart';
import 'notes_screen.dart';
import 'compare_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CatalogScreen(),      
    const RecommenderScreen(),  
    const CompareScreen(),      
    const CollectionScreen(),   
    const ProfileScreen(),
    const NotesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg, 
      appBar: AppBar(
        title: const Text(
          'SCENTMATCH',
          style: TextStyle(
            fontWeight: FontWeight.w300, 
            letterSpacing: 4.0, 
            color: AppColors.gold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bg,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.border, height: 1.0), 
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.bg,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.textMuted,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 10, letterSpacing: 1),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.library_books_outlined), activeIcon: Icon(Icons.library_books), label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), activeIcon: Icon(Icons.auto_awesome), label: 'Match'),
            BottomNavigationBarItem(icon: Icon(Icons.compare_arrows_outlined), activeIcon: Icon(Icons.compare_arrows), label: 'Compare'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), activeIcon: Icon(Icons.bookmark), label: 'Collection'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.eco_outlined), activeIcon: Icon(Icons.eco), label: 'Notes'),
          ],
        ),
      ),
    );
  }
}