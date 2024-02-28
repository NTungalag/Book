import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as imgUtil;
import 'package:image_picker/image_picker.dart';

import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/user_events.dart';
import 'package:diplom/models/user_model.dart';
import 'package:diplom/states/user_state.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, email, image;

  XFile? zurag;
  @override
  void initState() {
    super.initState();
    name = widget.user.name!;
    email = widget.user.email;
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(
      source: media,
      imageQuality: 1,
    );
    final imageBytes = await img!.readAsBytes();
    // var base = base64Encode(File(img!.path).readAsBytesSync());
    // Resize the image
    final resizedImage = imgUtil.decodeImage(imageBytes);
    final resized = imgUtil.copyResize(resizedImage!, width: 500);

    // Encode the resized image in base64
    final base = base64Encode(imgUtil.encodeJpg(resized));

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
            title: const Text('Зураг сонгох хэлбэрээ сонгоно уу'),
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
                        Text('Галлерэ'),
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
                        Text('Камер'),
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

  late GoogleMapController googleMapController;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<UserBloc>().add(UpdateUser(
            name: name,
            email: email,
            image: image,
            userId: widget.user.id,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Мэдээлэл засах',
          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.updated) {
            setState(() {
              name = '';
              email = '';

              image = '';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Амжилттай шинэчиллээ'),
                backgroundColor: Colors.green,
              ),
            );

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    title: const Text('Амжилттай шинэчиллээ'),
                  );
                }).then(
              (value) => Navigator.pop(context),
            );
          }
          if (state.status == UserStatus.FAILURE) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Мэдээлэл шинэчлэхэд алдаа гарлаа'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state.status == UserStatus.loading) {
            CircularProgressIndicator();
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
                        widget.user.image != null && zurag == null
                            ? Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blueGrey,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    widget.user.image!,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                  ),
                                ),
                              )
                            : zurag != null
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.blueGrey,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
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
                                          color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: const Text(
                                      "Зураг сонгоогүй байна",
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                        Container(
                          height: 40,
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
                            child: const Text('Зураг сонгох'),
                          ),
                        ),
                      ],
                    ),

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
                      initialValue: widget.user.name,
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
                        labelText: 'Хэрэглэгчийн нэр',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Хоосон байна';
                        }
                        if (text.length < 4) {
                          return 'Богино байна';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() => name = text);
                        //    _validate();
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: widget.user.email,
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
                        labelText: 'Цахим хаяг',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Хоосон байна';
                        }
                        if (text.length < 4) {
                          return 'Богино байна';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        setState(() => email = text);
                        //    _validate();
                      },
                    ),
                    const SizedBox(height: 12),
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
