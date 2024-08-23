import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/screens/chat.dart';
import 'package:diplom/screens/chat_rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diplom/blocs/book.bloc.dart';
import 'package:diplom/events/book_event.dart';
import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/screens/chat_rooms.dart';
import 'package:diplom/screens/create_book.dart';
import 'package:diplom/screens/homeScreen.dart';
import 'package:diplom/screens/map.dart';
import 'package:diplom/screens/profile.dart';

var tabs = [
  const Home(),
  // const SearchBook(),
  const MapScreen(),
  const CreateBookScreen(),
  // const ChatScreen(),
  const ChatRooms(),
  // const ChatR(),
  const ProfilePage(),
];

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _Tabs();
}

class _Tabs extends State<Tabs> {
  int _page = 0;
  late final BookRepository _bookRepository;

  @override
  void initState() {
    super.initState();
    _bookRepository = BookRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey.shade100,
      body: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<BookRepository>(create: (context) => BookRepository()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<BookBloc>(
              create: (BuildContext context) => BookBloc(bookRepository: _bookRepository)
                ..add(const GetBooks(page: '1'))
                ..add(GetCategories()),
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
            icon: Icon(Icons.home_outlined, size: 23),
            backgroundColor: Colors.white,
            label: 'Нүүр',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined, size: 23),
            backgroundColor: Colors.white,
            label: 'Танд ойр',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined, size: 23),
            label: 'Ном нэмэх',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 23),
            label: 'Чат',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 23),
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
