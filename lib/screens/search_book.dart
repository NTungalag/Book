import 'dart:async';
import 'dart:convert';

import 'package:diplom/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchBook extends StatefulWidget {
  const SearchBook({super.key});

  @override
  SearchState createState() => SearchState();
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class SearchState extends State<SearchBook> {
  final _debouncer = Debouncer();

  List<Book> ulist = [];
  List<Book> userLists = [];

  String urlBook =
      'http://localhost:8000/api/books?select=title author id image userId&sort=id&limit=10';

  Future<List<Book>> getAllBook() async {
    try {
      final response = await get(Uri.parse(urlBook));
      if (response.statusCode == 200) {
        // print(response.body);
        List<Book> list = parse(response.body);
        return list;
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Book> parse(String responseBody) {
    List parsed = json.decode(responseBody)['data'];
    return parsed.map((json) => Book.fromMap(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    getAllBook().then((subjectFromServer) {
      setState(() {
        ulist = subjectFromServer;
        userLists = ulist;
      });
    });
  }

  //Main Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Хайлт',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: const Color.fromARGB(255, 77, 195, 213),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                suffixIcon: const InkWell(
                  child: Icon(Icons.search),
                ),
                contentPadding: const EdgeInsets.all(10.0),
                hintText: 'Хайлт',
              ),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    userLists = ulist
                        .where((u) => (u.title.toLowerCase().contains(
                              string.toLowerCase(),
                            )))
                        .toList();
                  });
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
              itemCount: userLists.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 0,
                  color: Colors.grey.shade400.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.grey.shade100,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(
                            userLists[index].image!,
                            // width: 20,
                            // height: 20,
                          ),
                        ),
                        title: Text(
                          userLists[index].title,
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          userLists[index].author ?? "null",
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.location_pin,
                                    color: Colors.black,
                                    size: 15,
                                  )),
                            )),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
