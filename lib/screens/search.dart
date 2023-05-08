// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:diplom/models/book_model.dart';
// import 'package:diplom/screens/book.dart';
// import 'package:diplom/screens/search_book.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:diplom/blocs/book.bloc.dart';
// import 'package:diplom/events/book_event.dart';
// import 'package:diplom/models/category_model.dart';
// import 'package:diplom/repositories/book_repository.dart';
// import 'package:diplom/states/book_state.dart';
// import 'package:http/http.dart';

// class Search extends StatefulWidget {
//   Category? category;
//   Search({
//     Key? key,
//     required this.category,
//   }) : super(key: key);

//   @override
//   State<Search> createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   final TextEditingController _searchController = TextEditingController();
//   late Category? selectedCategory;
//   final _debouncer = Debouncer();
//   final controller = ScrollController();

//   static List<Book> parse(String responseBody) {
//     List parsed = json.decode(responseBody)['data'];
//     return parsed.map((json) => Book.fromMap(json)).toList();
//   }

//   @override
//   void initState() {
//     super.initState();

//     selectedCategory = widget.category;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         appBar: AppBar(
//             elevation: 0,
//             centerTitle: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () => Navigator.pop(context),
//             ),
//             title: const Text(
//               'Хайлт',
//               style: TextStyle(fontFamily: 'semi-bold', fontSize: 25, color: Colors.black),
//             ),
//             backgroundColor: Colors.white),
//         body: BlocBuilder<BookBloc, BookState>(
//           builder: (context, state) {
//             return SafeArea(
//               child: Column(
//                 children: [
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       border: Border.all(
//                         color: Colors.black,
//                         width: 1,
//                         style: BorderStyle.solid,
//                       ),
//                       color: Colors.white12,
//                     ),
//                     margin: const EdgeInsets.all(16),
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: DropdownButton(
//                       value: selectedCategory,
//                       items: state.categories
//                           .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
//                           .toList(),
//                       onChanged: ((value) {
//                         setState(() {
//                           selectedCategory = value as Category;
//                         });
//                       }),
//                       icon: const Padding(
//                           padding: EdgeInsets.only(left: 20), child: Icon(Icons.arrow_drop_down)),
//                       iconEnabledColor: Colors.black,
//                       style: const TextStyle(color: Colors.black, fontSize: 20),
//                       dropdownColor: Colors.redAccent,
//                       underline: Container(),
//                       isExpanded: true,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: TextField(
//                         onChanged: (value) {
//                           _debouncer.run(() {
//                             setState(() {
//                               booklist = ulist
//                                   .where((u) => (u.title.toLowerCase().contains(
//                                         value.toLowerCase(),
//                                       )))
//                                   .toList();
//                             });
//                             fetch();
//                           });
//                         },
//                         controller: _searchController,
//                         decoration: InputDecoration(
//                           hintText: 'Ном хайх',
//                           suffixIcon: IconButton(
//                             icon: const Icon(Icons.clear),
//                             onPressed: () => _searchController.clear(),
//                           ),
//                           // Add a search icon or button to the search bar
//                           prefixIcon: IconButton(
//                             icon: const Icon(Icons.search),
//                             onPressed: () {
//                               // Perform the search here
//                             },
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: RefreshIndicator(
//                       onRefresh: refresh,
//                       child: ListView.builder(
//                         controller: controller,
//                         shrinkWrap: true,
//                         physics: const ClampingScrollPhysics(),
//                         padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
//                         itemCount: booklist.length + 1,
//                         itemBuilder: (BuildContext context, int index) {
//                           if (index < booklist.length) {
//                             return GestureDetector(
//                               onTap: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => BookScreen(
//                                     book: booklist[index],
//                                   ),
//                                 ),
//                               ),
//                               child: Card(
//                                 elevation: 0,
//                                 color: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   side: BorderSide(
//                                     color: Colors.grey.shade100,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     ListTile(
//                                       leading: ClipRRect(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         child: Image.network(
//                                           booklist[index].image!,
//                                         ),
//                                       ),
//                                       title: Text(
//                                         booklist[index].title,
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                       subtitle: Text(
//                                         booklist[index].author,
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                       trailing: GestureDetector(
//                                           onTap: () {},
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8),
//                                             child: IconButton(
//                                                 onPressed: () {},
//                                                 icon: const Icon(
//                                                   Icons.location_pin,
//                                                   color: Colors.black,
//                                                   size: 15,
//                                                 )),
//                                           )),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             return hasMore
//                                 ? const Center(child: CircularProgressIndicator())
//                                 : const SizedBox();
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ));
//   }
// }

// class SearchB extends StatefulWidget {
//   Category category;

//   SearchB({
//     Key? key,
//     required this.category,
//   }) : super(key: key);

//   @override
//   State<SearchB> createState() => _SearchBState();
// }

// class _SearchBState extends State<SearchB> {
//   late final BookRepository _bookRepository;

//   @override
//   void initState() {
//     super.initState();
//     _bookRepository = BookRepository();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(providers: [
//       BlocProvider<BookBloc>(
//         create: (BuildContext context) => BookBloc(bookRepository: _bookRepository)
//           ..add(const GetBooks())
//           ..add(GetCategories()),
//       ),
//     ], child: Search(category: widget.category));
//   }
// }
