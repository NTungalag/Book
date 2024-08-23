import 'dart:convert';

import 'package:http/http.dart';

import 'package:diplom/models/book_model.dart';
import 'package:diplom/models/category_model.dart';

class BookRepository {
  String limit = '100';
  String userUrl =
      'http://localhost:8000/api/books?select=title author id description location latitude longitude image userId createdAt';

  Future<List<Book>> getBooks({
    int? categoryId,
    int? userId,
    String? latitude,
    String? longitude,
    String? title,
    String? page,
    String? sort,
  }) async {
    String url = userUrl;
    if (userId != null) {
      url = '$userUrl&userId=$userId';
    }
    if (latitude != null && longitude != null) {
      url = '$userUrl&page=$page!&limit=$limit&latitude=$latitude&longitude=$longitude';
    }
    if (categoryId != null) {
      url = '$userUrl&page=$page!&categoryId=$categoryId';
    }
    if (sort != null) {
      url = '$url&sort=$sort';
    }

    Response response = await get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];

      List<Book> books = data.map((val) => Book.fromMap(val)).toList();
      return books;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<Category>> getCategories() async {
    Response response = await get(
      Uri.parse('http://localhost:8000/api/categories?select=name id exchangeCount&limit=10'),
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];

      List<Category> category = data.map((val) => Category.fromMap(val)).toList();
      return category;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> createBook({
    required String title,
    required String author,
    required String description,
    required String location,
    required String longitude,
    required String latitude,
    required String image,
    required String categoryId,
    required String userId,
  }) async {
    Response response = await post(
      Uri.parse(
        'http://localhost:8000/api/books',
      ),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{
        'title': title,
        'author': author,
        'description': description,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'image': image,
        'categoryId': categoryId,
        'userId': userId,
      }),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];

      return true;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Book> updateBook({
    required int bookId,
    String? title,
    String? author,
    String? description,
    String? location,
    String? longitude,
    String? latitude,
    String? image,
    String? categoryId,
  }) async {
    Response response = await put(
      Uri.parse('http://localhost:8000/api/books/$bookId'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(image == null
          ? {
              'title': title!,
              'author': author!,
              'description': description!,
              'location': location!,
              'latitude': latitude!,
              'longitude': longitude!,
              // 'image': image!,
              'categoryId': categoryId!,
            }
          : {
              'title': title!,
              'author': author!,
              'description': description!,
              'location': location!,
              'latitude': latitude!,
              'longitude': longitude!,
              'image': image,
              'categoryId': categoryId!,
            }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      Book user = Book.fromMap(data);

      return user;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
