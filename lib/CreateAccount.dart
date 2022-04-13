import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wbbm_bmti/Bloc/Account.dart';
import 'package:wbbm_bmti/Event/Account.dart';
import 'package:wbbm_bmti/Repository/Account.dart';
import 'package:wbbm_bmti/State/Account.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: BlocProvider(
        create: (context) => AccountBloc(
          FakeAccountRepository(),
        ),
        child: CreateAccountPage(),
      ),
    );
  }
}

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final textFullNameController = TextEditingController();
  final textCompanyController = TextEditingController();
  final textEmailAddressController = TextEditingController();
  final textProvinsiController = TextEditingController();
  final textKotaController = TextEditingController();
  final textPasswordController = TextEditingController();
  final textRePasswordController = TextEditingController();

  AccountBloc bloc;
  final _formKey = GlobalKey<FormState>();

  Future<File> imageFile;
  File image;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      // ignore: deprecated_member_use
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          image = snapshot.data;
          return Container(
            height: 250,
            child: GestureDetector(
              onTap: () => pickImageFromGallery(ImageSource.gallery),
              child: Image.file(
                snapshot.data,
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 0.7,
                color: Colors.grey,
              ),
            ),
            width: 100,
            height: 100,
            child: IconButton(
              icon: Icon(
                Icons.add_photo_alternate,
                size: 64,
                color: Colors.grey,
              ),
              onPressed: () {
                pickImageFromGallery(ImageSource.gallery);
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<AccountBloc>(context);
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is InsertLoaded) {
          if (state.accountInsert.status == 1) {
            Navigator.pop(context);
          }
          Flushbar(
            message: state.accountInsert.message,
            duration: Duration(seconds: 5),
            margin: EdgeInsets.all(8),
            borderRadius: 8,
          )..show(context);
        }
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _textFieldWidget(
                    context, textFullNameController, "Nama Anda", false),
                _textFieldWidget(context, textCompanyController,
                    "Instansi / Perusahaan", false),
                _textFieldWidget(
                    context, textEmailAddressController, "Email Anda", false),
                _textFieldWidget(
                    context, textProvinsiController, "Provinsi", false),
                _textFieldWidget(
                    context, textKotaController, "Kota/Kabupaten", false),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: _textFieldWidget(
                          context, textPasswordController, "Password", true),
                    ),
                    Flexible(
                      child: _textFieldWidget(context, textRePasswordController,
                          "Konfirmasi", true),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Foto"),
                      showImage(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 24,
                    left: 24,
                    right: 24,
                  ),
                  child: SizedBox(
                    width: 280,
                    child: FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (textPasswordController.text.trim() ==
                              textRePasswordController.text.trim()) {
                            bloc.add(
                              InsertAccount(
                                email: textEmailAddressController.text.trim(),
                                password: textPasswordController.text.trim(),
                                perusahaan: textCompanyController.text.trim(),
                                name: textFullNameController.text.trim(),
                                provinsi: textProvinsiController.text.trim(),
                                kota: textKotaController.text.trim(),
                                image: image,
                              ),
                            );
                          } else {
                            Flushbar(
                              message: "Konfirmasi password tidak sama",
                              duration: Duration(seconds: 3),
                              margin: EdgeInsets.all(8),
                              borderRadius: 8,
                            )..show(context);
                          }
                        }
                      },
                      child: Text(
                        "Create Account",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _textFieldWidget(BuildContext context, TextEditingController controller,
      String hint, bool obsecure) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
      child: TextFormField(
        obscureText: obsecure,
        controller: controller,
        decoration: InputDecoration(hintText: hint),
        validator: (value) {
          if (value.isEmpty) {
            return '$hint wajib diisi';
          }
          return null;
        },
      ),
    );
  }
}
