import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:diplom/events/user_events.dart';
import 'package:diplom/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:diplom/blocs/book.bloc.dart';
import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/book_event.dart';
import 'package:diplom/models/category_model.dart';
import 'package:diplom/states/book_state.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  State<CreateBookScreen> createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {
  TextEditingController co1 = TextEditingController();
  TextEditingController co2 = TextEditingController();
  TextEditingController co3 = TextEditingController();
  TextEditingController co4 = TextEditingController();

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  static const initialCameraPosition = CameraPosition(
    target: LatLng(47.917, 106.918),
    zoom: 15,
  );

  late String image;
  late User user;
  late String title, description, author, location, latitude, longitude;

  late GoogleMapController googleMapController;

  Category? categoryId;
  Marker? marker;
  XFile? zurag;

  @override
  void initState() {
    super.initState();
    user = context.read<UserBloc>().state.user!;
    latitude = '';
    longitude = '';
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media, imageQuality: 70);
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
            title: const Text('Зураг оруулах хэлбэрээ сонгоно уу'),
            content: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery);
                      },
                      child: Row(children: const [
                        Icon(Icons.image),
                        Text('Галлире'),
                      ]),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                      child: Row(children: const [
                        Icon(Icons.camera),
                        Text('Камер'),
                      ]),
                    )
                  ],
                )),
          );
        });
  }

  void dialog(bool loading) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              content: const CircularProgressIndicator());
        });
  }

  void _submit() {
    if (latitude == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Газрын зураг дээр байршил сонгоно уу'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (image == '' || image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Зураг сонгоно уу'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Номын төрөл сонгоно уу'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (_formKey.currentState!.validate() && categoryId != null) {
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Ном үүсгэх',
          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocConsumer<BookBloc, BookState>(
        listener: (context, state) {
          if (state.status == BookStatus.success) {
            setState(() {
              title = '';
              description = '';
              author = '';
              location = '';
              latitude = '';
              longitude = '';
              image = '';
              zurag = null;
            });
            co1.clear();
            co2.clear();
            co3.clear();
            co4.clear();

            // context.read<BookBloc>().add(const GetBooks());
            context.read<UserBloc>().add(GetUserBooks(user.id));

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Амжилттай нэмэгдлээ'),
              backgroundColor: Colors.green,
            ));
          }
          Center(child: CircularProgressIndicator());

          if (state.status == BookStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Номын мэдээлэл шинэчлэхэд алдаа гарлаа!'),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state.status == BookStatus.loading) {
            // dialog(true);
          }
        },
        builder: (context, state) {
          if (state.status == BookStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(zurag!.path),
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
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
                                color: Colors.grey.shade200,
                              ),
                              child: const Text(
                                "Зураг сонгоогүй байна",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0), color: Colors.green),
                            width: MediaQuery.of(context).size.width / 5 * 3,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor: MaterialStateProperty.all(Colors.transparent)),
                              onPressed: () {
                                myAlert();
                              },
                              child: const Text('Зураг оруулах'),
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 5 * 3,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              color: Colors.white12,
                            ),
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
                              borderRadius: BorderRadius.circular(10.0),
                              icon: const Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Icon(Icons.arrow_drop_down)),
                              iconEnabledColor: Colors.black,
                              style: const TextStyle(color: Colors.black, fontSize: 16),
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              underline: const SizedBox(),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: co1,
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
                        return 'Хоосон байна';
                      }
                      if (text.length < 2) {
                        return 'Богино байна ';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() => title = text);
                    },
                  ),
                  const SizedBox(height: 12),

                  // const SizedBox(height: 12),

                  TextFormField(
                    controller: co2,
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
                        return 'Хоосон байна';
                      }
                      if (text.length < 2) {
                        return 'Богино байна ';
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
                    controller: co3,
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
                        return 'Хоосон байна';
                      }
                      if (text.length < 2) {
                        return 'Богино байна ';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      setState(() => description = text);
                      //    _validate();
                    },
                  ),
                  // const SizedBox(height: 12),

                  const SizedBox(height: 12),
                  TextFormField(
                    controller: co4,
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
                        return 'Хоосон байна';
                      }
                      if (text.length < 2) {
                        return 'Богино байна ';
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
                      markers: marker != null ? {marker!} : {},
                      onTap: (position) {
                        setState(() {
                          Marker newMarker = Marker(
                            draggable: true,
                            markerId: MarkerId(position.toString()),
                            icon:
                                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
                            position: position,
                          );
                          marker = newMarker;
                          latitude = position.latitude.toString();
                          longitude = position.longitude.toString();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color.fromARGB(255, 153, 136, 205),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                      child: const Text('Ном үүсгэх'),
                      onPressed: () => _submit(),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
