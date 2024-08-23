// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  int id;
  String? message;
  int? status;
  int? userId;
  String? updatedAt;
  String? createdAt;
  int? chatRoomId;
  Message({
    required this.id,
    this.message,
    this.status,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.chatRoomId,
  });

  Message copyWith({
    int? id,
    String? message,
    int? status,
    int? userId,
    String? updatedAt,
    String? createdAt,
    int? chatRoomId,
  }) {
    return Message(
      id: id ?? this.id,
      message: message ?? this.message,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      chatRoomId: chatRoomId ?? this.chatRoomId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'status': status,
      'userId': userId,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'chatRoomId': chatRoomId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as int,
      message: map['message'] != null ? map['message'] as String : null,
      status: map['status'] != null ? map['status'] as int : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      chatRoomId: map['chatRoomId'] != null ? map['chatRoomId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, message: $message, status: $status, userId: $userId, updatedAt: $updatedAt, createdAt: $createdAt, chatRoomId: $chatRoomId)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.message == message &&
        other.status == status &&
        other.userId == userId &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt &&
        other.chatRoomId == chatRoomId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        status.hashCode ^
        userId.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode ^
        chatRoomId.hashCode;
  }
}
