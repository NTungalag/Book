import 'package:diplom/blocs/login_bloc.dart';
import 'package:diplom/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  var listImage = [
    "https://i.pinimg.com/originals/aa/eb/7f/aaeb7f3e5120d0a68f1b814a1af69539.png",
    "https://cdn.fnmnl.tv/wp-content/uploads/2020/09/04145716/Stussy-FA20-Lookbook-D1-Mens-12.jpg",
    "https://www.propermag.com/wp-content/uploads/2020/03/0x0-19.9.20_18908-683x1024.jpg",
    "http://www.thefashionisto.com/wp-content/uploads/2014/06/Marc-by-Marc-Jacobs-Men-2015-Spring-Summer-Collection-Look-Book-001.jpg",
    "https://im0-tub-ru.yandex.net/i?id=e2e0f873e86f34e5001ddc59b42e23a6-l&ref=rim&n=13&w=828&h=828",
    "https://www.thefashionisto.com/wp-content/uploads/2013/07/w012-800x1200.jpg",
    "https://manofmany.com/wp-content/uploads/2016/09/14374499_338627393149784_1311139926468722688_n.jpg",
    "https://image-cdn.hypb.st/https%3A%2F%2Fhypebeast.com%2Fimage%2F2020%2F04%2Faries-fall-winter-2020-lookbook-first-look-14.jpg?q=75&w=800&cbr=1&fit=max",
    "https://i.pinimg.com/originals/95/0f/4d/950f4df946e0a373e47df37fb07ea1f9.jpg",
    "https://i.pinimg.com/736x/c4/03/c6/c403c63b8e1882b6f10c82f601180e2d.jpg",
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    // var b = context.read<LoginBloc>().state.books;
    // print(b);
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    "Tungalag.B",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 27.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Ulaanbaatar",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w100),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Unicorn   |  16 Books",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 20.0,
                  ),
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://free2music.com/images/singer/2019/02/10/troye-sivan_2.jpg"),
                  radius: 40.0,
                ),
              ]),
            ],
          ),
        ),
        // const SizedBox(height: 10.0),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     TabBar(
        //       isScrollable: true,
        //       controller: tabController,
        //       indicator: const BoxDecoration(borderRadius: BorderRadius.zero),
        //       labelColor: Colors.black,
        //       // labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        //       unselectedLabelColor: Colors.black26,
        //       onTap: (tapIndex) {
        //         setState(() {
        //           selectedIndex = tapIndex;
        //         });
        //       },
        //       tabs: const [
        //         Tab(
        //           iconMargin: EdgeInsets.all(0),
        //           icon: Icon(Icons.library_books),
        //         ),
        //         Tab(
        //           iconMargin: EdgeInsets.all(0),
        //           icon: Icon(Icons.notifications),
        //         ),
        //         Tab(
        //           iconMargin: EdgeInsets.all(0),
        //           icon: Icon(Icons.bookmark),
        //         ),
        //         Tab(
        //           iconMargin: EdgeInsets.all(0),
        //           icon: Icon(Icons.book_online),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 180.0, crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage(listImage[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, top: 135.0, bottom: 5.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Text("Harry potter"),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 10,
              ),
              const Center(
                child: Text("You don't have any videos1"),
              ),
              const Center(
                child: Text("You don't have any tagged2"),
              ),
              const Center(
                child: Text("You don't have any tagged3"),
              ),
            ],
          ),
        )
      ],
    );
  }
}
