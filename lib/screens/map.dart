import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:diplom/blocs/book.bloc.dart';
import 'package:diplom/models/book_model.dart';
import 'package:diplom/screens/book.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const initialCameraPosition = CameraPosition(
    target: LatLng(47.917, 106.918),
    zoom: 15,
  );

  Marker book = Marker(
      markerId: const MarkerId('d'),
      infoWindow: const InfoWindow(title: 'Book'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      position: const LatLng(47.917, 106.918));

  late GoogleMapController googleMapController;

  late List<Book> books;

  @override
  void initState() {
    books = context.read<BookBloc>().state.books.cast<Book>();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (controller) => googleMapController = controller,
        markers: {
          ...books.map(
            (book) => Marker(
              markerId: MarkerId(book.id.toString()),
              visible: true,
              infoWindow: InfoWindow(
                title: book.title,
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => BookScreen(book: book))),
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              position: book.latitude != null
                  ? LatLng(double.tryParse(book.latitude!.toString())!,
                      double.tryParse(book.longitude!.toString())!)
                  : const LatLng(47.916, (106.914)),
            ),
          ),
          Marker(
            markerId: const MarkerId('book.id.toString()'),
            visible: true,
            infoWindow: const InfoWindow(
              title: 'book.title',
              // onTap: () => Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => BookScreen(book: book))),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: const LatLng(47.918, (106.914)),
          ),
          // .toList()
        },
        onLongPress: (argument) {
          // print(argument);
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
