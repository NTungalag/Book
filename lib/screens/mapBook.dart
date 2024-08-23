import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:diplom/models/book_model.dart';

class Map extends StatefulWidget {
  final Book book;
  const Map({super.key, required this.book});

  @override
  State<Map> createState() => _MapScreenState();
}

class _MapScreenState extends State<Map> {
  late CameraPosition initialCameraPosition;

  late GoogleMapController googleMapController;

  late Marker book;

  @override
  void initState() {
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

    initialCameraPosition = CameraPosition(
      target: LatLng(
        double.tryParse(widget.book.latitude)!,
        double.tryParse(widget.book.longitude)!,
      ),
      zoom: 15,
    );
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.book.title,
          style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
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
        onMapCreated: (controller) {
          googleMapController = controller;
          googleMapController.showMarkerInfoWindow(MarkerId(widget.book.id.toString()));
        },
        markers: {book},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition)),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
