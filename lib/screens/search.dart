// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  List state;
  Search({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Хайлт',
            style: TextStyle(fontFamily: 'semi-bold', fontSize: 20),
          ),
          backgroundColor: const Color.fromARGB(255, 77, 195, 213),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // Add padding around the search bar
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  // Use a Material design search bar
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      // Add a clear button to the search bar
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      ),
                      // Add a search icon or button to the search bar
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Perform the search here
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width,
                height: 20,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.state.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) => GestureDetector(
                          // onTap: () => Navigator.push(
                          //     context, MaterialPageRoute(builder: (context) =>  Search())),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                                  widget.state[i].name,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color.fromARGB(255, 4, 52, 5)),
                                  softWrap: true,
                                )
                              ],
                            ),
                          ),
                        )),
              ),

              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              //   color: Colors.grey.shade200,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const SizedBox(height: 20),
              //       Text(
              //         'Exchange and read books you like',
              //         style: TextStyle(
              //           fontSize: 16,
              //           color: Colors.black.withOpacity(1),
              //         ),
              //       ),
              //       const SizedBox(height: 8),
              //       TextField(
              //         decoration: InputDecoration(
              //             border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(10.0),
              //             ),
              //             prefixIcon: const Icon(Icons.search_rounded),
              //             filled: true,
              //             hintStyle: TextStyle(color: Colors.grey[800]),
              //             hintText: "Хайлт хийх",
              //             fillColor: Colors.white70),
              //       ),

              //       // Container(
              //       //   // color: Colors.indigo,
              //       //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              //       //   width: MediaQuery.of(context).size.width,
              //       //   height: 250,
              //       //   child: ListView.builder(
              //       //       scrollDirection: Axis.horizontal,
              //       //       itemCount: _booksList.length,
              //       //       shrinkWrap: true,
              //       //       itemBuilder: (context, i) => Container(
              //       //             margin: const EdgeInsets.all(10),
              //       //             child: Column(
              //       //               mainAxisAlignment: MainAxisAlignment.start,
              //       //               children: [
              //       //                 Image.network(
              //       //                   _booksList[i]['src'],
              //       //                   // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSyysf701YmXhAns1W7dVK7q0CTqfxb09aTTjfYQp1O2ijVj-7XrCjXY9oLNhJSUF2vFI&usqp=CAU',
              //       //                   height: 200,
              //       //                   // width: 90,
              //       //                   fit: BoxFit.fitHeight,
              //       //                 ),
              //       //                 const SizedBox(height: 8),
              //       //                 Text(_booksList[i]['title']),
              //       //               ],
              //       //             ),
              //       //           )),
              //       // ),
              //     ],
              //   ),
              // ),
              // // GridView.builder(
              //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //         maxCrossAxisExtent: 200,
              //         childAspectRatio: 3 / 2,
              //         crossAxisSpacing: 20,
              //         mainAxisSpacing: 20),
              //     itemCount: _booksList.length,
              //     itemBuilder: (BuildContext ctx, index) {
              //       return Container(
              //         alignment: Alignment.center,
              //         decoration: BoxDecoration(
              //             color: Colors.amber, borderRadius: BorderRadius.circular(15)),
              //         child: Text(_booksList[index]["title"]),
              //       );
              //     }),
            ],
          ),
        ));
  }
}
