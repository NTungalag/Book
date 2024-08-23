// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// import 'package:diplom/blocs/user_bloc.dart';
// import 'package:diplom/models/book_model.dart';
// import 'package:diplom/models/user_model.dart';
// import 'package:diplom/repositories/book_repository.dart';
// import 'package:diplom/screens/search_book.dart';
// import 'package:diplom/states/user_state.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late User user;
//   bool loading = false;
//   final _controllerSearch = TextEditingController();
//   late GoogleMapController googleMapController;
//   List<Book> books = [];
//   double latitude = 0;
//   double longitude = 0;
//   final BookRepository _bookRepository = BookRepository();
//   //SURGUULI LATITUDE 47.920285, LONGITUDE 106.966015

//   static const initialCameraPosition = CameraPosition(
//     target: LatLng(47.917, 106.918),
//     zoom: 15,
//   );
//   late bool _serviceEnabled; //
//   late PermissionStatus _permissionGranted; //
//   LocationData? _userLocation; //

//   Future<void> _getUserLocation() async {
//     Location location = Location();

//     // Check if location service is enable
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }

//     // Check if permission is granted
//     _permissionGranted = await location.hasPermission();

//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     final locationData = await location.getLocation();

//     getBooksNear(locationData.latitude.toString(), locationData.longitude.toString());
//   }

//   getBooksNear(String latitude, String longitude) async {
//     var books = await _bookRepository.getBooks(latitude: latitude, longitude: longitude);

//     return books;
//   }

//   @override
//   void initState() {
//     loading = true;
//     user = context.read<UserBloc>().state.user!;
//     // books = context.read<BookBloc>().state.books.cast<Book>();
//     super.initState();
//     _getUserLocation();
//   }

//   @override
//   void dispose() {
//     googleMapController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: BlocConsumer<UserBloc, UserState>(
//         listener: (context, state) {
//           if (state.status == UserStatus.updated) {
//             setState(() {
//               loading = false;
//             });
//           }
//         },
//         builder: ((context, state) {
//           return GoogleMap(
//             mapType: MapType.normal,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: false,
//             initialCameraPosition: initialCameraPosition,
//             onMapCreated: (controller) => googleMapController = controller,
//             markers: true
//                 ? {
//                     ...books
//                         .map(
//                           (book) => Marker(
//                             markerId: MarkerId(book.id.toString()),
//                             visible: true,
//                             infoWindow: InfoWindow(
//                               title: book.title,
//                               // onTap: () => Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(builder: (context) => BookScreen(book: book)),
//                               // ),
//                             ),
//                             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//                             position: LatLng(
//                               double.tryParse(book.latitude)!,
//                               double.tryParse(book.longitude)!,
//                             ),
//                           ),
//                         )
//                         .toList(),
//                     // Marker(
//                     //   markerId: const MarkerId('book.id.toString()'),
//                     //   visible: true,
//                     //   infoWindow: const InfoWindow(
//                     //     title: 'book.title',
//                     //     // onTap: () => Navigator.push(
//                     //     //     context, MaterialPageRoute(builder: (context) => BookScreen(book: book))),
//                     //   ),
//                     //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//                     //   position: LatLng(
//                     //     double.parse(books[2].latitude),
//                     //     double.parse(books[2].longitude),
//                     //   ),
//                     // ),
//                   }
//                 : {},
//             onCameraMove: (position) {
//               latitude = position.target.latitude;
//               longitude = position.target.longitude;
//             },
//             onCameraMoveStarted: () {},
//             onCameraIdle: () async {
//               var book = await getBooksNear(latitude.toString(), longitude.toString());
//               setState(() {
//                 books = book;
//               });

//               // getBooksNear(loca.latitude.toString(), loca.longitude.toString());
//             },
//           );
//         }),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () => googleMapController
//       //       .animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition)),
//       //   child: const Icon(Icons.center_focus_strong),
//       // ),
//       floatingActionButton: GestureDetector(
//         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchB())),
//         child: Container(
//           margin: const EdgeInsets.all(16),
//           child: TextField(
//             controller: _controllerSearch,
//             enabled: false,
//             textInputAction: TextInputAction.search,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.white,
//               disabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                 borderSide: const BorderSide(
//                   color: Colors.grey,
//                 ),
//               ),
//               prefixIcon: const InkWell(
//                 child: Icon(Icons.search),
//               ),
//               contentPadding: const EdgeInsets.all(10.0),
//               hintText: 'Хайлт хийх',
//             ),
//             onChanged: (string) {},
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
//     );
//   }
// }
