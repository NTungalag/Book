import 'package:diplom/blocs/authentication_bloc.dart';
import 'package:diplom/events/authontication_event.dart';
import 'package:diplom/repositories/authontication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diplom/blocs/book.bloc.dart';
import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/user_events.dart';
import 'package:diplom/models/user_model.dart';
import 'package:diplom/screens/book.dart';
import 'package:diplom/screens/edit_profile_screen.dart';
import 'package:diplom/states/user_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;
  late User user;
  late List categories;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    user = context.read<UserBloc>().state.user!;
    categories = context.read<BookBloc>().state.categories;

    context.read<UserBloc>().add(GetUserBooks(user.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: ((context, state) {
      return Column(
        children: [
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user!.name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      state.user!.email,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w100),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Нийт ${state.books.isNotEmpty ? state.books.length.toString() : '0'} ном ",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  // IconButton(
                  //   onPressed: () => Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => EditProfileScreen(user: user))),
                  //   icon: const Icon(
                  //     Icons.more_horiz,
                  //     size: 20.0,
                  //   ),
                  // ),
                  PopupMenuButton(
                      // icon: Icon(Icons.settings),
                      onSelected: (value) {
                        if (value == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(user: user)));
                        } else {
                          context
                              .read<AuthenticationBloc>()
                              .add(const AuthStatusChanged(AuthenticationStatus.unauthenticated));
                        }
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                      ),
                      itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 1,
                              child: Text('Хувийн мэдээлэл засах'),
                              // onTap: () => Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => EditProfileScreen(user: user))),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text('Системээс гарах'),
                              // onTap: () => context
                              //     .read<AuthenticationBloc>()
                              //     .add(AuthStatusChanged(AuthenticationStatus.unauthenticated)),
                            ),
                          ]),
                  user.image != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.image!),
                          radius: 40.0,
                        )
                      : CircleAvatar(
                          radius: 40.0,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/Images/person.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black12.withOpacity(0.02),
            child: TabBar(
              isScrollable: true,
              controller: tabController,
              indicator: const BoxDecoration(borderRadius: BorderRadius.zero),
              labelColor: Colors.black,
              // labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.black26,
              onTap: (tapIndex) {
                setState(() {
                  selectedIndex = tapIndex;
                });
              },
              tabs: const [
                Tab(
                  iconMargin: EdgeInsets.all(0),
                  icon: Icon(Icons.library_books),
                ),
                Tab(
                  iconMargin: EdgeInsets.all(0),
                  icon: Icon(Icons.notifications),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 180.0, crossAxisCount: 3),
                  itemCount: state.books.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookScreen(
                                    book: state.books[index],
                                    user: user,
                                    categories: categories,
                                  ))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
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
                            padding:
                                const EdgeInsets.only(left: 8, right: 8, top: 135.0, bottom: 8),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Text(
                                state.books[index].title,
                                style: const TextStyle(
                                  color: Colors.black,
                                ), // fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // GridView.builder(
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       mainAxisExtent: 180.0, crossAxisCount: 3),
                //   itemBuilder: (context, index) {
                //     return Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.black,
                //           borderRadius: BorderRadius.circular(10.0),
                //           image: DecorationImage(
                //             image: NetworkImage(listImage[index]),
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.only(left: 5, right: 5, top: 135.0, bottom: 5.0),
                //           child: Container(
                //             alignment: Alignment.center,
                //             decoration: BoxDecoration(
                //                 color: Colors.white.withOpacity(0.6),
                //                 borderRadius: BorderRadius.circular(8)),
                //             child: const Text("Harry potter"),
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                //   itemCount: 10,
                // ),
                const Center(
                  child: Text("nemeh"),
                ),
              ],
            ),
          )
        ],
      );
    }));
  }
}
