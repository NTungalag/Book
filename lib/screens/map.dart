import 'package:diplom/screens/search_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:diplom/blocs/book.bloc.dart';
import 'package:diplom/models/book_model.dart';
import 'package:diplom/screens/book.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _controllerSearch = TextEditingController();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  LocationData? _userLocation;
  static const initialCameraPosition = CameraPosition(
    target: LatLng(47.917, 106.918),
    zoom: 1,
  );

  late GoogleMapController googleMapController;

  late List<Book> books;
  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    setState(() {
      _userLocation = locationData;
    });
  }

  @override
  void initState() {
    books = context.read<BookBloc>().state.books.cast<Book>();
    super.initState();
    if (_userLocation == null) _getUserLocation();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getUserLocation();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (controller) => googleMapController = controller,
        markers: {
          ...books
              .map(
                (book) => Marker(
                    markerId: MarkerId(book.id.toString()),
                    visible: true,
                    infoWindow: InfoWindow(
                      title: book.title,
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => BookScreen(book: book))),
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    position: // book.latitude != null?
                        LatLng(double.tryParse(book.latitude)!, double.tryParse(book.longitude)!)
                    // : const LatLng(47.916, (106.914)),
                    ),
              )
              .toList(),
          Marker(
              markerId: const MarkerId('book.id.toString()'),
              visible: true,
              infoWindow: const InfoWindow(
                title: 'book.title',
                // onTap: () => Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => BookScreen(book: book))),
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              position:
                  LatLng(double.parse(books.first.latitude), double.parse(books.first.longitude))

              // position: const LatLng(47.918, (106.914)),
              ),
          // .toList()
        },
        onLongPress: (argument) {
          print(double.parse(books.first.latitude));
          print(double.parse(books.first.longitude));
        },
        onTap: (argument) {
          // print(argument);
        },
        onCameraMove: (position) {
          print(position.target.latitude);
          print(position.target.longitude);

          // Call your API here with the latitude and longitude
          // final response = await yourApiCall(position.target.latitude, position.target.longitude);

          // Update your UI with the API response
          setState(() {
            // Update your UI based on the response
          });
        },
        onCameraMoveStarted: () {},
        onCameraIdle: () {},
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => googleMapController
      //       .animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition)),
      //   child: const Icon(Icons.center_focus_strong),
      // ),
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchB())),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
