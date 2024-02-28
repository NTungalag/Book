import 'dart:convert';

import 'package:diplom/models/message_model.dart';
import 'package:diplom/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ChatRoom extends Equatable {
  final int id;
  final String? name;
  final String? description;
  final List<User> users;
  final List<Message> messages;

  final String? updatedAt;
  final String? createdAt;
  const ChatRoom({
    required this.id,
    this.name,
    this.description,
    required this.messages,
    required this.users,
    this.updatedAt,
    this.createdAt,
  });

  ChatRoom copyWith({
    int? id,
    String? name,
    String? description,
    List<User>? users,
    List<Message>? messages,
    String? updatedAt,
    String? createdAt,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      users: users ?? this.users,
      messages: messages ?? this.messages,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'users': users.map((x) => x.toMap()).toList(),
      'messages': messages.map((x) => x.toMap()).toList(),
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] as int,
      name: map['name'] != null ? map['name'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      users: List<User>.from(
        (map['users']).map(
          (x) => User.fromMap(x),
        ),
      ),
      messages: List<Message>.from(
        (map['messages']).map(
          (x) => Message.fromMap(x),
        ),
      ),
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatRoom(id: $id, name: $name, description: $description, users: $users, messages:$messages, updatedAt: $updatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ChatRoom other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        listEquals(other.users, users) &&
        listEquals(other.messages, messages) &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt;
  }

  static const empty = ChatRoom(id: 0, messages: [], users: []);

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        users.hashCode ^
        messages.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode;
  }

  @override
  List<Object?> get props => [id, name, description, users, messages, updatedAt, createdAt];
}
