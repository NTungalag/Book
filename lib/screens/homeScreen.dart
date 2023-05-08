import 'package:diplom/events/book_event.dart';
import 'package:diplom/models/category_model.dart';
import 'package:diplom/screens/permission.dart';
import 'package:diplom/screens/search_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diplom/blocs/book.bloc.dart';

import 'package:diplom/screens/book.dart';
import 'package:diplom/screens/search.dart';
import 'package:diplom/states/book_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookBloc, BookState>(
      listener: (BuildContext context, state) {
        if (state.status == BookStatus.loaded) {
          // setState(() {
          //   book = state.books.cast<Book>();
          // });
        }
        if (state.status == BookStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('book Failure')),
            );
        }
      },
      builder: (BuildContext context, state) {
        return state.status == BookStatus.loading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Per()),
                        // );
                        context.read<BookBloc>().add(const GetBooks());
                        context.read<BookBloc>().add(GetCategories());
                      },
                      child: const Text('Button'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://thumbs.dreamstime.com/b/open-book-stack-hardback-books-blue-background-back-to-school-education-reading-home-office-large-free-copy-space-235419239.jpg',
                          ),
                          opacity: 0.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Тавтай морил',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black.withOpacity(1),
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Хүссэн номоо солилцоод уншаарай',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(1),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context, MaterialPageRoute(builder: (context) => SearchB())),
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                prefixIcon: const InkWell(
                                  child: Icon(Icons.search),
                                ),
                                enabled: false,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Хайлт хийх",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 14,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16),
                          child: const Text(
                            'Эрэлтэй номын төрөл',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.categories.length,
                              shrinkWrap: true,
                              itemBuilder: (context, i) => GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SearchB(
                                                category: state.categories[
                                                    i]) //dawxar Blocprovider ywaad bgaag xarad
                                            // Search(  state: state.categories,)
                                            )),
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      margin: const EdgeInsets.only(right: 9),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 210, 235, 255),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.heart_broken_rounded,
                                            size: 13,
                                            color: Colors.pinkAccent,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            state.categories[i].name,
                                            style: const TextStyle(
                                                fontSize: 12, color: Color.fromARGB(255, 4, 52, 5)),
                                            softWrap: true,
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 16),
                          child: const Text(
                            'Сүүлд нэмэгдсэн',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context, MaterialPageRoute(builder: (context) => SearchB())),
                            child: const Text(
                              'Бүгдийг үзэх',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 180.0, crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookScreen(book: state.books[index]))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(state.books[index].image!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 135.0, bottom: 8),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(8.0)),
                                    child: Text(
                                      state.books[index].title,
                                      style: const TextStyle(color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: state.books.length,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
