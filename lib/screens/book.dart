// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/user_events.dart';
import 'package:diplom/models/book_model.dart';
import 'package:diplom/models/user_model.dart';
import 'package:diplom/screens/chat.dart';
import 'package:diplom/screens/edit_book.dart';
import 'package:diplom/screens/mapBook.dart';
import 'package:diplom/states/user_state.dart';

class BookScreen extends StatelessWidget {
  final Book book;
  final User user;
  List? categories;

  BookScreen({
    Key? key,
    required this.book,
    required this.user,
    this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.status == UserStatus.success) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chatRoom: state.chatRoomLast!,
                    user: user,
                  ),
                ),
              );
            }
          },
          builder: (context, state) => Column(children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      book.image!,
                    ),
                    opacity: 0.1,
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            book.image!,
                            height: MediaQuery.of(context).size.width / 2.2 + 50,
                            width: MediaQuery.of(context).size.width / 2.2,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.title,
                      style: const TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Номыг бичсэн: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            book.author,
                            style: const TextStyle(fontSize: 17),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Категор: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            book.category!.name,
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Тайлбар: ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            book.description!,
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(children: [
                      const Icon(
                        Icons.location_pin,
                        size: 13,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Map(
                              book: book,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Байршил харах',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          ]),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(36), // Image radius
                    child: Image.network(
                      book.user!.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.user!.name!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            book.user!.email,
                            style: const TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          book.userId == user.id
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditB(book: book, categories: categories!),
                                  ),
                                )
                              : context.read<UserBloc>().add(CreateChatroom(
                                  userOne: user.id,
                                  userTwo: book.userId!,
                                  name: '${book.id} ${book.title}',
                                  description: '${book.id} ${book.title}'));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                        child: Text(book.userId == user.id ? 'Засах' : 'Солилцох'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Container(
      //   color: Colors.white,
      //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      //   width: double.infinity,
      //   height: 100,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       ClipOval(
      //         child: SizedBox.fromSize(
      //           size: const Size.fromRadius(36), // Image radius
      //           child: Image.network(
      //             book.image!,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //       const SizedBox(
      //         width: 16,
      //       ),
      //       Expanded(
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   book.user!.name!,
      //                   style: const TextStyle(fontSize: 18),
      //                 ),
      //                 Text(
      //                   book.user!.email,
      //                   style: const TextStyle(fontSize: 15),
      //                 )
      //               ],
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 book.userId == user.id
      //                     ? Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                           builder: (context) => EditB(book: book, categories: categories!),
      //                         ),
      //                       )
      //                     : context.read<UserBloc>().add(CreateChatroom(
      //                         userOne: user.id,
      //                         userTwo: book.userId!,
      //                         name: '${book.id} ${book.title}',
      //                         description: '${book.id} ${book.title}'));
      //               },
      //               style: ButtonStyle(
      //                   backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
      //               child: Text(book.userId == user.id ? 'Засах' : 'Солилцох'),
      //             )
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
