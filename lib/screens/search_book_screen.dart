// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'package:diplom/blocs/book.bloc.dart';
import 'package:diplom/events/book_event.dart';
import 'package:diplom/models/book_model.dart';
import 'package:diplom/models/category_model.dart';
import 'package:diplom/models/user_model.dart';
import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/screens/book.dart';
import 'package:diplom/states/book_state.dart';

import '../blocs/user_bloc.dart';

class SearchBook extends StatefulWidget {
  final Category? category;
  const SearchBook({
    Key? key,
    this.category,
  }) : super(key: key);

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
  final controller = ScrollController();
  final _controllerSearch = TextEditingController();
  final limit = 25;
  late Category? selectedCategory;
  late User user;
  int page = 1;
  bool hasMore = true;
  String searchText = '';

  List<Book> ulist = [];
  List<Book> books = [];

  String urlBook =
      'http://localhost:8000/api/books?select=title author id image createdAt description location latitude longitude userId&sort=id&limit=6';

  static List<Book> parse(String responseBody) {
    List parsed = json.decode(responseBody)['data'];
    return parsed.map((json) => Book.fromMap(json)).toList();
  }

  fetch() async {
    String url = '';

    if (searchText == '') {
      url =
          '$urlBook&page=$page${selectedCategory == null ? '' : '&categoryId=${selectedCategory!.id}'}';
    } else {
      url =
          '$urlBook&page=$page&title=$searchText&op=cn${selectedCategory == null ? '' : '&categoryId=${selectedCategory!.id}'}';
    }

    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<Book> bookList = parse(response.body);

      setState(() {
        page++;
        books.addAll(bookList);
        ulist = books;
        if (books.length < limit) {
          hasMore = false;
          hasMore = false;
        }
      });
    } else {
      throw Exception('Error');
    }
  }

  @override
  void initState() {
    super.initState();
    // getAllBook().then((subjectFromServer) {
    //   setState(() {
    //     ulist = subjectFromServer;
    //     books = ulist;
    //   });
    // });
    selectedCategory = widget.category;
    user = context.read<UserBloc>().state.user!;

    fetch();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    books = [];
    String url = '';
    if (searchText == '') {
      url = '$urlBook${selectedCategory == null ? '' : '&categoryId=${selectedCategory!.id}'}';
    } else {
      url =
          '$urlBook&title=$searchText&op=cn${selectedCategory == null ? '' : '&categoryId=${selectedCategory!.id}'}';
    }

    final response = await get(Uri.parse('$url&page=1'));
    if (response.statusCode == 200) {
      List<Book> list = parse(response.body);
      List<Book> bookList = list;

      setState(() {
        page++;
        books.addAll(bookList);
        ulist = books;
        if (books.length < limit) {
          hasMore = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Хайлт',
            style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            selectedCategory != null
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 0),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButton(
                      value: selectedCategory,
                      items: state.categories
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: ((value) {
                        setState(() {
                          selectedCategory = value as Category;
                        });
                        refresh();
                      }),
                      icon: const Padding(
                          padding: EdgeInsets.only(left: 20), child: Icon(Icons.arrow_drop_down)),
                      iconEnabledColor: Colors.black,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      dropdownColor: Colors.white,
                      underline: SizedBox(),
                      borderRadius: BorderRadius.circular(10.0),
                      isExpanded: true,
                    ),
                  )
                : const SizedBox(),
            Container(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
              child: TextField(
                controller: _controllerSearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
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
                  prefixIcon: const InkWell(
                    child: Icon(Icons.search),
                  ),
                  suffixIcon: InkWell(
                    onTap: () => setState(() {
                      searchText = '';
                      page = 1;
                      books = [];
                      _controllerSearch.clear();
                      fetch();
                    }),
                    child: const Icon(Icons.close),
                  ),
                  contentPadding: const EdgeInsets.all(10.0),
                  hintText: 'Хайлт',
                ),
                onChanged: (string) {
                  _debouncer.run(() {
                    setState(() {
                      // books = ulist
                      //     .where((u) => (u.title.toLowerCase().contains(
                      //           string.toLowerCase(),
                      //         )))
                      //     .toList();
                      books = [];
                      searchText = string;
                      page = 1;
                    });
                    fetch();
                  });
                },
              ),
            ),
            books.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text('Илэрц олдсонгүй'),
                    ),
                  )
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.builder(
                        controller: controller,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                        itemCount: books.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < books.length) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookScreen(
                                    book: books[index],
                                    user: user,
                                  ),
                                ),
                              ),
                              child: Card(
                                elevation: 0,
                                color: Colors.white,
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
                                          books[index].image!,
                                        ),
                                      ),
                                      title: Text(
                                        '${books[index].title}  |  ${books[index].category!.name}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        books[index].author,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      trailing: GestureDetector(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
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
                              ),
                            );
                          } else {
                            return hasMore
                                ? const Center(child: CircularProgressIndicator())
                                : const SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
          ],
        ),
      );
    });
  }
}

class SearchBookScreen extends StatefulWidget {
  Category? category;

  SearchBookScreen({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  State<SearchBookScreen> createState() => _SearchBState();
}

class _SearchBState extends State<SearchBookScreen> {
  late final BookRepository _bookRepository;
  late User user;

  @override
  void initState() {
    super.initState();
    _bookRepository = BookRepository();
    user = context.read<UserBloc>().state.user!;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<BookBloc>(
        create: (BuildContext context) => BookBloc(bookRepository: _bookRepository)
          ..add(const GetBooks())
          ..add(GetCategories()),
      ),
    ], child: SearchBook(category: widget.category));
  }
}
