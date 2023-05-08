import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:diplom/blocs/book.bloc.dart';
import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/book_event.dart';
import 'package:diplom/models/category_model.dart';
import 'package:diplom/states/book_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  State<CreateBookScreen> createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title, description, author, location, latitude, longitude;
  Category? categoryId;
  static const initialCameraPosition = CameraPosition(
    target: LatLng(47.917, 106.918),
    zoom: 15,
  );
  XFile? zurag;
  late String image;
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(
      source: media,
      imageQuality: 1,
    );
    var base = base64Encode(File(img!.path).readAsBytesSync());
    log(base);
    setState(() {
      zurag = img;

      image = 'data:image/jpeg;base64,$base';
    });
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final ImagePicker picker = ImagePicker();

  Marker book = Marker(
      markerId: const MarkerId('d'),
      infoWindow: const InfoWindow(title: 'Book'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      position: const LatLng(47.917, 106.918));

  late GoogleMapController googleMapController;

  void _submit() {
    var user = context.read<UserBloc>().state.user!;
    if (_formKey.currentState!.validate() && categoryId != null) {
      context.read<BookBloc>().add(CreateBook(
          title: title,
          author: author,
          description: description,
          location: location,
          latitude: latitude,
          longitude: longitude,
          categoryId: categoryId!.id.toString(),
          image: image,
          userId: user.id.toString()));
    }
  }

  void _validate() {
    _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              'Ном үүсгэх',
              style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 1,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.title),
                        labelText: 'Номын нэр',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Can\'t be empty';
                        }
                        if (text.length < 4) {
                          return 'Too short';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() => title = text);
                        //    _validate();
                      },
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        color: Colors.white12,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButton(
                        value: state.categories.first,
                        items: state.categories
                            .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                            .toList(),
                        onChanged: ((value) {
                          setState(() {
                            categoryId = value as Category;
                          });
                        }),
                        icon: const Padding(
                            padding: EdgeInsets.only(left: 20), child: Icon(Icons.arrow_drop_down)),
                        iconEnabledColor: Colors.black,
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                        dropdownColor: Colors.redAccent,
                        underline: Container(),
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 1,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Зохиогч',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Can\'t be empty';
                        }
                        if (text.length < 4) {
                          return 'Too short';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() => author = text);
                        //    _validate();
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      maxLines: 4,
                      minLines: 1,
                      maxLength: 200,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 1,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.description),
                        labelText: 'Тайлбар',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Can\'t be empty';
                        }
                        if (text.length < 4) {
                          return 'Too short';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() => description = text);
                        //    _validate();
                      },
                    ),
                    // const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        myAlert();
                      },
                      child: const Text('Upload Photo'),
                    ),
                    zurag != null
                        ? Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black, width: 1, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(zurag!.path),
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black, width: 1.0, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromARGB(255, 202, 202, 202),
                            ),
                            child: const Text(
                              "Зураг сонгоогүй байна!",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 1,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.location_pin),
                        labelText: 'Байршил',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Can\'t be empty';
                        }
                        if (text.length < 4) {
                          return 'Too short';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() => location = text);
                        //    _validate();
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: GoogleMap(
                        scrollGesturesEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        initialCameraPosition: initialCameraPosition,
                        onMapCreated: (controller) => googleMapController = controller,
                        markers: {
                          Marker(
                            markerId: const MarkerId('book.id.toString()'),
                            visible: true,
                            infoWindow: const InfoWindow(
                              title: 'book.title',
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                            position: const LatLng(47.918, (106.914)),
                          ),
                        },
                        onTap: (argument) {
                          setState(() {
                            latitude = argument.latitude.toString();
                            longitude = argument.longitude.toString();
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 77, 195, 213),
                        )),
                        child: const Text('Ном үүсгэх'),
                        onPressed: () => _submit(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
