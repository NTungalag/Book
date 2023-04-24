import 'dart:convert';

import 'package:diplom/models/user_model.dart';
import 'package:http/http.dart';

class UserRepository {
  Future<String> authenticate({
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'token';
  }

  Future<bool> deleteUser({required String userId}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<User> getUser() async {
    /// delete from keystore/keychain
    await Future.delayed(const Duration(seconds: 1));
    return User(id: 0, email: 'email', role: 'role', name: 'dsdsds');
  }

  void setUser(User user) {}

  // String userUrl = 'http://localhost:8000/api/users';

  // Future<List<User>> getUser({String? userId}) async {
  //   Response response = await get(
  //     Uri.parse(userUrl),
  //   );

  //   if (response.statusCode == 200) {
  //     List data = json.decode(response.body)['data'];
  //     print(data);
  //     List<User> user = data.map((val) => User.fromMap(val)).toList();
  //     // print(books);
  //     return user;
  //   } else {
  //     throw Exception(response.reasonPhrase);
  //   }
  // }
}
