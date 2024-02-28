import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/user_events.dart';
import 'package:diplom/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '', password = '', password2 = '', name = '';
  bool _passwordVisible = true;
  bool _passwordVisible2 = true;

  late int bookId;

  @override
  void initState() {
    super.initState();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && password == password2) {
      context.read<UserBloc>().add(Register(password2, email, name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Бүртгүүлэх',
          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        width: double.infinity,
        height: 40,
        child: RawMaterialButton(
          onPressed: () => _submit(),
          elevation: 6.0,
          fillColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Бүртгүүлэх',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Амжилттай бүртгэл үүслээ'),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pop(context);
          }
          if (state.status == UserStatus.FAILURE) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Бүртгэл үүсгэхэд алдаа гарлаа!'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.title),
                        labelText: 'Нэр',
                      ),
                      onChanged: (value) => name = value,
                      onSaved: (String? value) {},
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Хоосон';
                        }
                        if (value.length < 4) {
                          return 'Хэт богино';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email_rounded),
                        labelText: 'Цахим хаяг',
                      ),
                      onChanged: (value) => email = value,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Хоосон';
                        }
                        if (value.length < 4) {
                          return 'Хэт богино';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () => setState(() {
                                  _passwordVisible = !_passwordVisible;
                                }),
                            child:
                                Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility)),
                        icon: const Icon(Icons.security_update),
                        labelText: 'Нууц үг',
                      ),
                      onChanged: (value) => password = value,
                      onSaved: (String? value) {},
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Хоосон';
                        }
                        if (value.length < 4) {
                          return 'Хэт богино';
                        }
                        return null;
                      },
                      obscureText: _passwordVisible,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () => setState(() {
                                  _passwordVisible2 = !_passwordVisible2;
                                }),
                            child:
                                Icon(_passwordVisible2 ? Icons.visibility_off : Icons.visibility)),
                        icon: const Icon(Icons.security_update),
                        labelText: 'Нууц үг',
                      ),
                      onChanged: (value) => password2 = value,
                      onSaved: (String? value) {},
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Хоосон';
                        }
                        if (value.length < 4) {
                          return 'Хэт богино';
                        }
                        if (value != password) {
                          return 'Нууц үг зөв оруулна уу';
                        }
                        return null;
                      },
                      obscureText: _passwordVisible2,
                    ),
                    const SizedBox(
                      height: 150,
                    )
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
