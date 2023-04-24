import 'dart:async';
import 'dart:convert';

import 'package:diplom/models/user_model.dart';
import 'package:http/http.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  String userUrl = 'http://localhost:8000/api/users/login';
  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<User> logIn({
    required String username,
    required String password,
  }) async {
    Response response = await post(
      Uri.parse(userUrl),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body)['user'];

      User u = User.fromMap(user);

      return u;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<User> logOut({
    required String username,
    required String password,
  }) async {
    Response response = await post(
      Uri.parse(userUrl),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'email': username, 'password': password}),
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
  }) async {
    Response response = await post(
      Uri.parse(userUrl),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body)['user'];

      User u = User.fromMap(user);

      return u;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  // void logOut() {
  //   _controller.add(AuthenticationStatus.unauthenticated);
  // }

  void dispose() => _controller.close();
}
