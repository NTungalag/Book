// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  int id;
  String? name;
  String email;
  String? role;
  String? about;
  int? chatRoomId;
  User({
    required this.id,
    this.name,
    required this.email,
    this.role,
    this.about,
    this.chatRoomId,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? about,
    int? chatRoomId,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      about: about ?? this.about,
      chatRoomId: chatRoomId ?? this.chatRoomId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'about': about,
      'chatRoomId': chatRoomId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] as String,
      role: map['role'] != null ? map['role'] as String : null,
      about: map['about'] != null ? map['about'] as String : null,
      chatRoomId: map['chatRoomId'] != null ? map['chatRoomId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role, about: $about, chatRoomId: $chatRoomId)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.about == about &&
        other.chatRoomId == chatRoomId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        role.hashCode ^
        about.hashCode ^
        chatRoomId.hashCode;
  }
}
