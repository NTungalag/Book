import 'dart:convert';

import 'package:diplom/models/book_model.dart';
import 'package:diplom/models/category_model.dart';
import 'package:http/http.dart';

class BookRepository {
  // String userUrl = 'http://localhost:8000/api/books';

  String userUrl =
      'http://localhost:8000/api/books?select=title author id description location latitude longitude image userId&limit=10';

  Future<List<Book>> getBooks({String? CategoryID}) async {
    Response response = await get(
      Uri.parse(userUrl),
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];
      print(data.length);
      print(data.first);

      List<Book> books = data.map((val) => Book.fromMap(val)).toList();
      print('=====books');
      print(books);
      return books;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<bool> deleteBook({required String BookId}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  // Future<Book> getBook(String bookId) async {
  //   /// delete from keystore/keychain
  //   await Future.delayed(const Duration(seconds: 1));
  //   return Book();
  // }

  Future<List<Category>> getCategories() async {
    Response response = await get(
      Uri.parse('http://localhost:8000/api/categories?select=name id exchangeCount&limit=10'),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data'];

      List<Category> category = data.map((val) => Category.fromMap(val)).toList();
      return category;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Book> createBook({
    required String title,
    required String author,
    required String description,
    required String location,
    required String longitude,
    required String latitude,
    required String image,
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
        'userId': '2',
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      Book book = Book.fromMap(data);
      print(book);

      return book;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
