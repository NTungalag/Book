// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:diplom/models/category_model.dart';
import 'package:diplom/models/user_model.dart';

class Book {
  int id;
  String title;
  String author;
  String? description;
  String? location;
  String latitude;
  String longitude;
  String? image;
  int? userId;
  User user;
  Category category;
  String createdAt;
  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.location,
    required this.latitude,
    required this.longitude,
    this.image,
    this.userId,
    required this.user,
    required this.category,
    required this.createdAt,
  });

  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? description,
    String? location,
    String? latitude,
    String? longitude,
    String? image,
    int? userId,
    User? user,
    Category? category,
    String? createdAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
      'userId': userId,
      'user': user.toMap(),
      'category': category.toMap(),
      'createdAt': createdAt,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int,
      title: map['title'] as String,
      author: map['author'] as String,
      description: map['description'] != null ? map['description'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      latitude: map['latitude'] as String,
      longitude: map['longitude'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      category: Category.fromMap(map['category'] as Map<String, dynamic>),
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Book(id: $id, title: $title, author: $author, description: $description, location: $location, latitude: $latitude, longitude: $longitude, image: $image, userId: $userId, user: $user, category: $category, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Book other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.author == author &&
        other.description == description &&
        other.location == location &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.image == image &&
        other.userId == userId &&
        other.user == user &&
        other.category == category &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        author.hashCode ^
        description.hashCode ^
        location.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        image.hashCode ^
        userId.hashCode ^
        user.hashCode ^
        category.hashCode ^
        createdAt.hashCode;
  }
}
