import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:diplom/blocs/book.bloc.dart';
import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/user_events.dart';
import 'package:diplom/models/book_model.dart';
import 'package:diplom/models/user_model.dart';
import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/screens/book.dart';
import 'package:diplom/screens/chat.dart';
import 'package:diplom/screens/search_book_screen.dart';
import 'package:diplom/states/user_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late User user;
  bool loading = true;
  final _controllerSearch = TextEditingController();

  late GoogleMapController googleMapController;
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;

  late List categories;

  List<Book> books = [];
  double latitude = 47.920687018461734;
  double longitude = 106.96607038378716;
  final BookRepository _bookRepository = BookRepository();
  //SURGUULI LATITUDE 47.920285, LONGITUDE 106.966015

  static const initialCameraPosition = CameraPosition(
    target: LatLng(47.920687018461734, 106.96607038378716),
    zoom: 16,
  );

  LocationData? _currentLocation;

  Future<void> _getCurrentLocation() async {
    final location = Location();
    final hasPermission = await location.requestPermission();

    if (hasPermission == PermissionStatus.granted) {
      location.onLocationChanged.listen((LocationData currentLocation) {
        setState(() {
          _currentLocation = currentLocation;
          loading = false;
        });

        googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(currentLocation.latitude!, currentLocation.longitude!),
            9,
          ),
        );
        // Use current location
      });

      final currentLocation = await location.getLocation();

      setState(() {
        _currentLocation = currentLocation;
        loading = false;
      });

      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(currentLocation.latitude!, currentLocation.longitude!),
          9,
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  getBooksNear(String latitude, String longitude) async {
    var books = await _bookRepository.getBooks(latitude: latitude, longitude: longitude);

    return books;
  }

  @override
  void initState() {
    super.initState();

    user = context.read<UserBloc>().state.user!;
    categories = context.read<BookBloc>().state.categories;
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, user.image!)
        .then((value) => setState((() {
              userIcon = value;
              print('object');
            })));

    _getCurrentLocation();
    loading = false;
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: BlocConsumer<UserBloc, UserState>(
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
          if (state.status == UserStatus.loading) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      // title: const Text('Please choose media to select'),
                      content: Center(child: CircularProgressIndicator()));
                });
          }
        },
        builder: ((context, state) {
          return GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controller) {
              googleMapController = controller;
              googleMapController.showMarkerInfoWindow(MarkerId('location'));
            },
            markers: !loading
                ? {
                    ...books
                        .map(
                          (book) => Marker(
                            markerId: MarkerId(book.id.toString()),
                            visible: true,
                            infoWindow: InfoWindow(
                              snippet: book.author,
                              title: book.title,
                              onTap: () {
                                showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.0),
                                      topLeft: Radius.circular(15.0),
                                    ),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 100,
                                      margin: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(children: [
                                            ClipOval(
                                              child: SizedBox.fromSize(
                                                size: const Size.fromRadius(36), // Image radius
                                                child: Image.network(
                                                  book.image!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  book.title,
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                                Text(
                                                  book.author,
                                                  style: const TextStyle(fontSize: 15),
                                                )
                                              ],
                                            ),
                                          ]),
                                          user.id == book.userId
                                              ? SizedBox()
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    // create xiixese umnu chatRoom uussen esehiig shalgana , uussen baiwal chatroomiig n GET
                                                    context.read<UserBloc>().add(CreateChatroom(
                                                        userOne: user.id,
                                                        userTwo: book.userId!,
                                                        name: '${book.id} ${book.title}',
                                                        description: '${book.id} ${book.title}'));
                                                    Navigator.pop(context);
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<Color>(
                                                              Colors.green)),
                                                  child: const Text('Солилцох'),
                                                )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                            position: LatLng(
                              double.tryParse(book.latitude)!,
                              double.tryParse(book.longitude)!,
                            ),
                          ),
                        )
                        .toList(),
                    Marker(
                        markerId: const MarkerId('location'),
                        visible: true,
                        infoWindow: const InfoWindow(
                          title: 'Таны байршил',
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
                        position: const LatLng(47.920687018461734, 106.96607038378716)),
                  }
                : {
                    Marker(
                        markerId: const MarkerId('book.id.toString()'),
                        visible: true,
                        infoWindow: const InfoWindow(
                          title: 'Таны байршил',
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
                        position: const LatLng(47.918, 106.918)),
                  },
            onCameraMove: (position) {
              latitude = position.target.latitude;
              longitude = position.target.longitude;
              print(latitude);
              print(longitude);
            },
            onCameraMoveStarted: () {},
            onCameraIdle: () async {
              var book = await getBooksNear(latitude.toString(), longitude.toString());

              print(book);

              setState(() {
                books = book;
              });
            },
          );
        }),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => googleMapController
      //       .animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition)),
      //   child: const Icon(Icons.center_focus_strong),
      // ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBookScreen())),
          child: Container(
            margin: const EdgeInsets.all(16),
            child: TextField(
              controller: _controllerSearch,
              enabled: false,
              textInputAction: TextInputAction.search,
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
                contentPadding: const EdgeInsets.all(10.0),
                hintText: 'Хайлт хийх',
              ),
              onChanged: (string) {},
            ),
          ),
        ),
        books.isEmpty
            ? const SizedBox()
            : Container(
                color: Colors.grey.withOpacity(0.4),
                margin: const EdgeInsets.only(bottom: 70),
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) => GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookScreen(
                                        book: books[i],
                                        user: user,
                                        categories: categories,
                                      ))),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
                            child: Column(children: [
                              Container(
                                margin: EdgeInsets.only(top: 7),
                                width: 60,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(books[i].image!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 90.0, bottom: 8),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(8.0)),
                                    child: Text(''
                                        // books[i].title,
                                        // style: const TextStyle(color: Colors.white),
                                        // overflow: TextOverflow.ellipsis,
                                        ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 60,
                                child: Text(
                                  books[i].title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 60,
                                child: Text(
                                  books[i].author,
                                  style: const TextStyle(color: Colors.black, fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ]),
                          ),
                        )),
              ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
