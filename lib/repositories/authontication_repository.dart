import 'dart:async';
import 'dart:convert';

import 'package:diplom/models/user_model.dart';
import 'package:http/http.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  String userUrl = 'http://localhost:8000/api/users';
  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<User> logIn({
    required String username,
    required String password,
  }) async {
    print(password);

    Response response = await post(
      Uri.parse('$userUrl/login'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'email': username, 'password': password}),
    );
    print(response.statusCode.toString());

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body)['user'];
      User u = User.fromMap(user);

      return u;
    } else {
      print('fail????');

      throw Exception(response.reasonPhrase);
    }
  }

  Future<User> logOut({
    required int userId,
  }) async {
    Response response = await post(
      Uri.parse('$userUrl/logout'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'userId': userId.toString()}),
    );

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body)['user'];

      User u = User.fromMap(user);

      return u;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<User> register({
    required String username,
    required String password,
    required String email,
  }) async {
    print(password);

    Response response = await post(
      Uri.parse('$userUrl/register'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{
        'email': username,
        'password': password,
        'name': username,
      }),
    );

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body)['user'];

      User u = User.fromMap(user);

      return u;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  void dispose() => _controller.close();
}
