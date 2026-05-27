import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/perfume.dart';

Map<String, dynamic> _perfumeToMap(Perfume p) => {
      'name': p.name,
      'brand': p.brand,
      'topNotes': p.topNotes,
      'middleNotes': p.middleNotes,
      'baseNotes': p.baseNotes,
      'gender': p.gender,
      'description': p.description,
    };

Perfume _perfumeFromMap(Map<dynamic, dynamic> map) => Perfume(
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      topNotes: map['topNotes'] ?? '',
      middleNotes: map['middleNotes'] ?? '',
      baseNotes: map['baseNotes'] ?? '',
      gender: map['gender'] ?? '',
      description: map['description'] ?? '',
    );

class UserAccount {
  final String username;
  final String password;
  final List<Perfume> collection;
  final List<Perfume> history;
  final List<String> favoriteNotes;

  UserAccount({
    required this.username,
    required this.password,
    List<Perfume>? collection,
    List<Perfume>? history,
    List<String>? favoriteNotes,
  })  : collection = collection ?? [],
        history = history ?? [],
        favoriteNotes = favoriteNotes ?? [];

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'collection': collection.map((p) => _perfumeToMap(p)).toList(),
      'history': history.map((p) => _perfumeToMap(p)).toList(),
      'favoriteNotes': favoriteNotes,
    };
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    var collList = json['collection'] as List? ?? [];
    var histList = json['history'] as List? ?? [];
    var favNotes = (json['favoriteNotes'] as List?)?.map((e) => e.toString()).toList() ?? [];

    return UserAccount(
      username: json['username'],
      password: json['password'],
      collection: collList.map((item) => _perfumeFromMap(item)).toList(),
      history: histList.map((item) => _perfumeFromMap(item)).toList(),
      favoriteNotes: favNotes,
    );
  }
}

class AuthProvider extends ChangeNotifier {
  Map<String, UserAccount> _usersDatabase = {};
  UserAccount? _currentUser;
  bool _isInitialized = false;

  AuthProvider() {
    _loadData();
  }

  bool get isLoggedIn => _currentUser != null;
  bool get isInitialized => _isInitialized;
  String get username => _currentUser?.username ?? "";
  List<Perfume> get collection => _currentUser?.collection ?? [];
  List<Perfume> get history => _currentUser?.history ?? [];
  List<String> get favoriteNotes => _currentUser?.favoriteNotes ?? [];

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final dbString = prefs.getString('users_database');
    if (dbString != null) {
      final Map<String, dynamic> decoded = jsonDecode(dbString);
      _usersDatabase = decoded.map((key, value) => MapEntry(key, UserAccount.fromJson(value)));
    }
    final activeUser = prefs.getString('active_user');
    if (activeUser != null && _usersDatabase.containsKey(activeUser)) {
      _currentUser = _usersDatabase[activeUser];
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedDb = jsonEncode(_usersDatabase.map((key, value) => MapEntry(key, value.toJson())));
    await prefs.setString('users_database', encodedDb);
    if (_currentUser != null) {
      await prefs.setString('active_user', _currentUser!.username);
    } else {
      await prefs.remove('active_user');
    }
  }

  bool register(String username, String password) {
    if (_usersDatabase.containsKey(username)) return false;
    _usersDatabase[username] = UserAccount(username: username, password: password);
    _currentUser = _usersDatabase[username];
    _saveData();
    notifyListeners();
    return true;
  }

  bool login(String username, String password) {
    if (!_usersDatabase.containsKey(username)) return false;
    if (_usersDatabase[username]!.password != password) return false;
    _currentUser = _usersDatabase[username];
    _saveData();
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _saveData();
    notifyListeners();
  }

  bool changePassword(String oldPassword, String newPassword) {
    if (_currentUser == null || _currentUser!.password != oldPassword) return false;
    _usersDatabase[_currentUser!.username] = UserAccount(
      username: _currentUser!.username,
      password: newPassword,
      collection: _currentUser!.collection,
      history: _currentUser!.history,
      favoriteNotes: _currentUser!.favoriteNotes,
    );
    _currentUser = _usersDatabase[_currentUser!.username];
    _saveData();
    notifyListeners();
    return true;
  }

  bool isInCollection(Perfume p) {
    if (_currentUser == null) return false;
    return _currentUser!.collection.any((item) => item.name == p.name && item.brand == p.brand);
  }

  void toggleCollection(Perfume p) {
    if (_currentUser == null) return;
    if (isInCollection(p)) {
      _currentUser!.collection.removeWhere((item) => item.name == p.name && item.brand == p.brand);
    } else {
      _currentUser!.collection.add(p);
    }
    _usersDatabase[_currentUser!.username] = _currentUser!;
    _saveData();
    notifyListeners();
  }

  void addToHistory(Perfume p) {
    if (_currentUser == null) return;
    
    _currentUser!.history.removeWhere((item) => item.name == p.name && item.brand == p.brand);
    _currentUser!.history.insert(0, p);
    
    if (_currentUser!.history.length > 20) {
      _currentUser!.history.removeLast();
    }
    
    _usersDatabase[_currentUser!.username] = _currentUser!;
    _saveData();
    notifyListeners();
  }

  bool isNoteFavorite(String note) {
    if (_currentUser == null) return false;
    return _currentUser!.favoriteNotes.contains(note);
  }

  void toggleFavoriteNote(String note) {
    if (_currentUser == null) return;
    if (isNoteFavorite(note)) {
      _currentUser!.favoriteNotes.remove(note);
    } else {
      _currentUser!.favoriteNotes.add(note);
    }
    _usersDatabase[_currentUser!.username] = _currentUser!;
    _saveData();
    notifyListeners();
  }

  void clearHistory() {
    if (_currentUser == null) return;
    
    _currentUser!.history.clear();
    _usersDatabase[_currentUser!.username] = _currentUser!;
    
    _saveData();
    notifyListeners();
  }
}