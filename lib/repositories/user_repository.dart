import 'dart:convert';

import 'package:diplom/models/chat_room_model.dart';
import 'package:diplom/models/user_model.dart';
import 'package:http/http.dart';

class UserRepository {
  String userUrl = 'http://localhost:8000/api';
  Future<ChatRoom> createChatroom(
      {required int userOne,
      required int userTwo,
      required String name,
      required String description}) async {
    Response response = await post(
      Uri.parse('$userUrl/chats'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{
        'name': name,
        'description': description,
        'userOne': userOne.toString(),
        'userTwo': userTwo.toString(),
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];

      ChatRoom chatRooms = ChatRoom.fromMap(data);

      return chatRooms;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<ChatRoom>> getChatRooms({
    int? userId,
  }) async {
    Response response = await get(
      Uri.parse('$userUrl/chats/$userId'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];

      List<ChatRoom> chatRooms = data.map((val) => ChatRoom.fromMap(val)).toList();

      return chatRooms;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<User> updateUser({
    required int userId,
    String? name,
    String? email,
    String? image,
  }) async {
    Response response = await put(
      Uri.parse('$userUrl/users/$userId'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{
        'name': name!,
        'email': email!,
        'image': image!,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      User user = User.fromMap(data);

      return user;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
