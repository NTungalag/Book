// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Category {
  int id;
  String name;
  String? exchangeCount;
  Category({
    required this.id,
    required this.name,
    this.exchangeCount,
  });

  Category copyWith({
    int? id,
    String? name,
    String? exchangeCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      exchangeCount: exchangeCount ?? this.exchangeCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'exchangeCount': exchangeCount,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      exchangeCount: map['exchangeCount'] != null ? map['exchangeCount'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Category(id: $id, name: $name, exchangeCount: $exchangeCount)';

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.exchangeCount == exchangeCount;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ exchangeCount.hashCode;
}
