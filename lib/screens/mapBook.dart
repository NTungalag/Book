import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:diplom/models/book_model.dart';

import 'package:location/location.dart';

class Map extends StatefulWidget {
  final Book book;
  const Map({super.key, required this.book});

  @override
  State<Map> createState() => _MapScreenState();
}

class _MapScreenState extends State<Map> {
  final _controllerSearch = TextEditingController();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  LocationData? _userLocation;
  static const initialCameraPosition = CameraPosition(
    target: LatLng(47.917, 106.918),
    zoom: 15,
  );

  late GoogleMapController googleMapController;

  late Marker book;

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
    // books = context.read<BookBloc>().state.books.cast<Book>();
    super.initState();
    book = Marker(
      markerId: MarkerId(widget.book.id.toString()),
      infoWindow: InfoWindow(title: widget.book.title),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        double.parse(widget.book.latitude),
        double.parse(widget.book.longitude),
      ),
    );
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
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.book.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade100,
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (controller) => googleMapController = controller,
        markers: {book},
        onLongPress: (argument) {
          // print(double.parse(books.first.latitude));
          // print(double.parse(books.first.longitude));
        },
        onTap: (argument) {
          // print(argument);
        },
        onCameraMove: (position) {
          // print(position);
        },
        onCameraMoveStarted: () {},
        onCameraIdle: () {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition)),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
