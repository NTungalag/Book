import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/user_events.dart';
import 'package:diplom/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diplom/blocs/book.bloc.dart';
import 'package:diplom/events/book_event.dart';
import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/screens/create_book.dart';
import 'package:diplom/screens/homeScreen.dart';
import 'package:diplom/screens/map.dart';
import 'package:diplom/screens/profile.dart';
import 'package:diplom/screens/search_book.dart';

const tabs = [
  Home(),

  // Search(),
  SearchBook(),
  MapScreen(),
  CreateBookScreen(),
  // ProfileScreen(),
  ProfilePage()
];

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _Tabs();
}

class _Tabs extends State<Tabs> {
  int _page = 0;
  late final BookRepository _bookRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _bookRepository = BookRepository();
    _userRepository = UserRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BookRepository>(create: (context) => BookRepository()),
          RepositoryProvider<UserRepository>(create: (context) => UserRepository()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<BookBloc>(
              create: (BuildContext context) => BookBloc(bookRepository: _bookRepository)
                ..add(const GetBooks('5'))
                ..add(GetCategories()),
            ),
            BlocProvider<UserBloc>(
              create: (BuildContext context) =>
                  UserBloc(userRepository: _userRepository)..add(GetUserBooks()),
            ),
          ],
          child: tabs[_page],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: Colors.black87, //const Color.fromARGB(255, 77, 195, 213),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 30,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 25),
            backgroundColor: Colors.white,
            label: 'Нүүр',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 25,
            ),
            backgroundColor: Colors.white,
            label: 'Хайлт',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map_outlined,
              size: 25,
            ),
            backgroundColor: Colors.white,
            label: 'Г-зураг',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined, size: 25),
            label: 'Ном нэмэх',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 25),
            label: 'Профайл',
            backgroundColor: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
