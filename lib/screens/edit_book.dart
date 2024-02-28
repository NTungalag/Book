import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:diplom/blocs/book.bloc.dart';
import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/book_event.dart';
import 'package:diplom/events/user_events.dart';
import 'package:diplom/models/book_model.dart';
import 'package:diplom/models/category_model.dart';
import 'package:diplom/states/book_state.dart';

import '../repositories/book_repository.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
  final List categories;
  const EditBookScreen({super.key, required this.book, required this.categories});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title, description, author, location, latitude, longitude;
  late int bookId;
  Category? categoryId;
  late CameraPosition initialCameraPosition;

  XFile? zurag;
  String? image;
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(
      source: media,
      imageQuality: 70,
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
            title: const Text('Зураг оруулах хэлбэр'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
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
                      getImage(ImageSource.camera);
                      Navigator.pop(context);
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

  late Marker initialPositin;

  late GoogleMapController googleMapController;
  @override
  void initState() {
    super.initState();
    title = widget.book.title;
    author = widget.book.author;
    description = widget.book.description != null ? widget.book.description! : '';
    latitude = widget.book.latitude;
    location = widget.book.location != null ? widget.book.location! : '';
    longitude = widget.book.longitude;
    categoryId = widget.book.category;
    bookId = widget.book.id;

    initialCameraPosition = CameraPosition(
      target: LatLng(double.parse(widget.book.latitude), double.parse(widget.book.longitude)),
      zoom: 14,
    );
    initialPositin = Marker(
        markerId: MarkerId(widget.book.id.toString()),
        infoWindow: InfoWindow(title: widget.book.title),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        position: LatLng(double.parse(widget.book.latitude), double.parse(widget.book.longitude)));
  }

  void _submit() {
    print(image);
    if (_formKey.currentState!.validate() && categoryId != null) {
      context.read<BookBloc>().add(image == null
          ? UpdateBook(
              title: title,
              author: author,
              description: description,
              location: location,
              latitude: latitude,
              longitude: longitude,
              categoryId: categoryId!.id.toString(),
              bookId: widget.book.id,
            )
          : UpdateBook(
              title: title,
              author: author,
              description: description,
              location: location,
              latitude: latitude,
              longitude: longitude,
              image: image,
              categoryId: categoryId!.id.toString(),
              bookId: widget.book.id,
            ));
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Номын мэдээлэл засах',
          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<BookBloc, BookState>(
        listener: (context, state) {
          if (state.status == BookStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Амжилттай шинэчлэгдлээ'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<BookBloc>().add(const GetBooks());
            context.read<UserBloc>().add(GetUserBooks(widget.book.user!.id));
            Navigator.pop(context);
            Navigator.pop(context);
          }
          if (state.status == BookStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Номын мэдээлэл шинэчлэхэд алдаа гарлаа!'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              title = widget.book.title;
              description = widget.book.description!;
              author = widget.book.author;
              location = widget.book.location!;
              latitude = widget.book.latitude;
              longitude = widget.book.longitude;
              // image = '';
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.book.image != null && zurag == null
                            ? Container(
                                width: 100,
                                height: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blueGrey,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    widget.book.image!,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                  ),
                                ),
                              )
                            : zurag != null
                                ? Container(
                                    width: 100,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(10),
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
                                    height: 130,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(10),
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
                              height: 16,
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
                                value: widget.categories.firstWhere((e) => e.id == categoryId!.id),
                                items: widget.categories
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
                      initialValue: widget.book.title,
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
                    // const SizedBox(height: 12),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //     border: Border.all(
                    //       color: Colors.grey,
                    //       width: 1,
                    //       style: BorderStyle.solid,
                    //     ),
                    //     color: Colors.white12,
                    //   ),
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: DropdownButton(
                    //     value: widget.categories.firstWhere((e) => e.id == categoryId!.id),
                    //     items: widget.categories
                    //         .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                    //         .toList(),
                    //     onChanged: ((value) {
                    //       setState(() {
                    //         categoryId = value as Category;
                    //       });
                    //     }),
                    //     borderRadius: BorderRadius.circular(10.0),

                    //     icon: const Padding(
                    //         padding: EdgeInsets.only(left: 20), child: Icon(Icons.arrow_drop_down)),
                    //     iconEnabledColor: Colors.black,
                    //     style: const TextStyle(color: Colors.black, fontSize: 16),
                    //     // dropdownColor: Colors.redAccent,
                    //     underline: Container(),
                    //     isExpanded: true,
                    //   ),
                    // ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: widget.book.author,
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
                      initialValue: widget.book.description,
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
                    // ElevatedButton(
                    //   onPressed: () {
                    //     myAlert();
                    //   },
                    //   child: const Text('Зураг сонгох'),
                    // ),
                    // zurag != null
                    //     ? Container(
                    //         width: 100,
                    //         height: 100,
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //               color: Colors.black, width: 1, style: BorderStyle.solid),
                    //           borderRadius: BorderRadius.circular(20),
                    //           color: Colors.blueGrey,
                    //         ),
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(horizontal: 20),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(8),
                    //             child: Image.file(
                    //               File(zurag!.path),
                    //               fit: BoxFit.cover,
                    //               width: MediaQuery.of(context).size.width,
                    //               height: 300,
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : Container(
                    //         width: 100,
                    //         height: 100,
                    //         alignment: Alignment.center,
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //               color: Colors.black, width: 1.0, style: BorderStyle.solid),
                    //           borderRadius: BorderRadius.circular(20),
                    //           color: const Color.fromARGB(255, 202, 202, 202),
                    //         ),
                    //         child: const Text(
                    //           "Зураг сонгоогүй байна!",
                    //           style: TextStyle(fontSize: 20),
                    //         ),
                    //       ),

                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: widget.book.location,
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
                          markers: {initialPositin},
                          onTap: (LatLng position) {
                            setState(() {
                              // Create a new marker with the tapped position
                              Marker newMarker = Marker(
                                draggable: true,
                                markerId: MarkerId(position.toString()),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueMagenta),
                                position: position,
                              );
                              // Add the new marker to the set of markers
                              initialPositin = newMarker;
                              latitude = position.latitude.toString();
                              longitude = position.longitude.toString();
                            });
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 153, 136, 205),
                        )),
                        child: const Text('Шинэчлэх'),
                        onPressed: () => _submit(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditB extends StatefulWidget {
  final Book book;
  final List categories;

  EditB({
    Key? key,
    required this.book,
    required this.categories,
  }) : super(key: key);

  @override
  State<EditB> createState() => _EditBState();
}

class _EditBState extends State<EditB> {
  late final BookRepository _bookRepository;

  @override
  void initState() {
    super.initState();
    _bookRepository = BookRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<BookBloc>(
        create: (BuildContext context) =>
            BookBloc(bookRepository: _bookRepository)..add(GetCategories()),
      ),
    ], child: EditBookScreen(book: widget.book, categories: widget.categories));
  }
}
