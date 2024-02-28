import 'package:diplom/models/chat_room_model.dart';
import 'package:equatable/equatable.dart';

import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/models/user_model.dart';

class UserState extends Equatable {
  const UserState({
    this.status = UserStatus.INVALID,
    this.books = const [],
    this.user = User.empty,
    this.chatRoomLast = ChatRoom.empty,
    this.chatRooms = const [],
  });

  final UserStatus status;
  final List books;
  final User? user;
  final List<ChatRoom> chatRooms;
  final ChatRoom? chatRoomLast;

  UserState copyWith(
      {UserStatus? status,
      List? books,
      User? user,
      List<ChatRoom>? chatRooms,
      ChatRoom? chatRoomLast}) {
    return UserState(
      status: status ?? this.status,
      books: books ?? this.books,
      user: user ?? this.user,
      chatRooms: chatRooms ?? this.chatRooms,
      chatRoomLast: chatRoomLast ?? this.chatRoomLast,
    );
  }

  @override
  List<Object> get props {
    return [status, books, user!, chatRooms, chatRoomLast!];
  }
}
