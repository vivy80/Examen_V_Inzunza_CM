class Category {
  final int id;
  final String name;
  final String state;

  const Category({
    required this.id,
    required this.name,
    required this.state,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'],
      name: json['category_name'],
      state: json['category_state'] ?? 'Activa',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': id,
      'category_name': name,
      'category_state': state,
    };
  }
}