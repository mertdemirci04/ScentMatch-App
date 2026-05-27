class Perfume {
  final int? id;
  final String name;
  final String brand;
  final String topNotes;
  final String middleNotes;
  final String baseNotes;
  final String gender;
  final String description;

  Perfume({
    this.id,
    required this.name,
    required this.brand,
    required this.topNotes,
    required this.middleNotes,
    required this.baseNotes,
    required this.gender,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'top_notes': topNotes,
      'middle_notes': middleNotes,
      'base_notes': baseNotes,
      'gender': gender,
      'description': description,
    };
  }

  factory Perfume.fromMap(Map<String, dynamic> map) {
    return Perfume(
      id: map['id'],
      name: map['name'],
      brand: map['brand'],
      topNotes: map['top_notes'] ?? '',
      middleNotes: map['middle_notes'] ?? '',
      baseNotes: map['base_notes'] ?? '',
      gender: map['gender'] ?? 'Unisex',
      description: map['description'] ?? '',
    );
  }
}