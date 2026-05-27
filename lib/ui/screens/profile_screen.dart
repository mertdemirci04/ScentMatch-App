import 'package:findscent/ui/screens/FavoriteNotesScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../providers/auth_provider.dart';
import 'history_screen.dart';
import 'about_us_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper function to show error and success snackbars
  void _showMessage(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : AppColors.goldDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showChangePasswordDialog(AuthProvider auth) {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bg,
        shape: const RoundedRectangleBorder(side: BorderSide(color: AppColors.gold)),
        title: const Text("CHANGE PASSWORD", style: TextStyle(color: AppColors.gold, fontSize: 14, letterSpacing: 2)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldPassController, obscureText: true, style: const TextStyle(color: AppColors.text), decoration: InputDecoration(labelText: "Old Password", labelStyle: TextStyle(color: AppColors.textMuted))),
            TextField(controller: newPassController, obscureText: true, style: const TextStyle(color: AppColors.text), decoration: InputDecoration(labelText: "New Password", labelStyle: TextStyle(color: AppColors.textMuted))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("CANCEL", style: TextStyle(color: AppColors.textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold),
            onPressed: () {
              bool success = auth.changePassword(oldPassController.text, newPassController.text);
              Navigator.pop(context);
              _showMessage(success ? "Password updated successfully." : "Incorrect old password!", !success);
            },
            child: const Text("UPDATE", style: TextStyle(color: AppColors.bg)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: auth.isLoggedIn ? AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined, color: AppColors.gold), onPressed: () => _showSettingsModal(auth)),
          const SizedBox(width: 10),
        ],
      ) : null,
      body: auth.isLoggedIn ? _buildModernProfile(auth, context) : _buildLoginForm(auth),
    );
  }

  void _showSettingsModal(AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg,
      shape: RoundedRectangleBorder(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), side: BorderSide(color: AppColors.border)),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: AppColors.gold),
            title: const Text("Change Password", style: TextStyle(color: AppColors.text)),
            onTap: () { Navigator.pop(context); _showChangePasswordDialog(auth); },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Log Out", style: TextStyle(color: Colors.redAccent)),
            onTap: () { Navigator.pop(context); auth.logout(); },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildModernProfile(AuthProvider auth, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(radius: 50, backgroundColor: AppColors.surface2, child: const Icon(Icons.person_outline, size: 50, color: AppColors.gold)),
          const SizedBox(height: 20),
          Text(auth.username.toUpperCase(), style: const TextStyle(color: AppColors.text, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 3)),
          Text("ScentMatch Member", style: TextStyle(color: AppColors.gold.withOpacity(0.7), fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25),
              decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem("Collection", auth.collection.length.toString()),
                  Container(width: 1, height: 40, color: AppColors.border),
                  _buildStatItem("Membership", "Premium"),
                  Container(width: 1, height: 40, color: AppColors.border),
                  _buildStatItem("Points", (auth.collection.length * 10).toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildActionTile(Icons.history, "Scent History", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()))),
          _buildActionTile(Icons.favorite_border, "My Favorite Notes", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoriteNotesScreen()))),
          _buildActionTile(Icons.info_outline, "About Us", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()))),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(label.toUpperCase(), style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
      child: ListTile(
        leading: Icon(icon, color: AppColors.gold, size: 20),
        title: Text(title, style: const TextStyle(color: AppColors.text, fontSize: 14)),
        trailing: Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 12),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLoginForm(AuthProvider auth) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Membership", style: TextStyle(fontSize: 32, color: AppColors.text, fontWeight: FontWeight.w300, letterSpacing: 2)),
          const Text("Portal", style: TextStyle(fontSize: 36, color: AppColors.goldLight, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          Text("Log in to personalize your collection and save your favorite choices.", style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 50),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: AppColors.text),
            decoration: InputDecoration(labelText: "Username", labelStyle: TextStyle(color: AppColors.textMuted), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)), focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.gold))),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(color: AppColors.text),
            decoration: InputDecoration(labelText: "Password", labelStyle: TextStyle(color: AppColors.textMuted), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)), focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.gold))),
          ),
          const SizedBox(height: 50),
          
          // LOG IN BUTTON
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              onPressed: () {
                if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
                  _showMessage("Please enter both username and password.", true);
                  return;
                }
                
                bool isSuccess = auth.login(_nameController.text, _passwordController.text);
                if (!isSuccess) {
                  _showMessage("Incorrect username or password!", true);
                } else {
                  _nameController.clear();
                  _passwordController.clear();
                }
              },
              child: const Text("LOG IN", style: TextStyle(color: AppColors.bg, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ),
          ),
          
          const SizedBox(height: 15),
          
          // REGISTER BUTTON
          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.gold), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              onPressed: () {
                if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
                  _showMessage("Please fill in the fields to register.", true);
                  return;
                }

                bool isSuccess = auth.register(_nameController.text, _passwordController.text);
                if (!isSuccess) {
                  _showMessage("This username is already taken, please try another one.", true);
                } else {
                  _showMessage("Registration successful! Welcome.", false);
                  _nameController.clear();
                  _passwordController.clear();
                }
              },
              child: const Text("REGISTER", style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ),
          ),
        ],
      ),
    );
  }
}